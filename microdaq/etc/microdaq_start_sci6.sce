// Copyright (c) 2015, Embedded Solutions
// All rights reserved.
// This file is released under the 3-clause BSD license. See COPYING-BSD.

//check compatibility 
sci_ver = getversion('scilab');
[sci_ver_str opts] = getversion();
if (sci_ver(1) <> 5) | (sci_ver(2) <> 5) | (sci_ver(3) < 2)  then
    if sci_ver(1) <> 6 then 
        error(gettext('Scilab 5.5.2 or 6.x.x is required.'));
    end
end

//LINUX: ONLY X64 ARCHITECTURE SUPPORT 
if getos() == "Linux" & opts(2) == 'x86' then 
    mprintf("\nERROR:  Linux x86 platform is no longer supported.\n\tList of supported platforms can be found here: http://atoms.scilab.org/toolboxes/microdaq");
    return;
end


// create global microdaq settings struct
global %microdaq;
%microdaq = struct("model", ["Unknown"],..
                            "ip_address", [],..
                            "dsp_loaded", %F,..
                            "dsp_ext_mode", %T,..
                            "dsp_debug_mode", %F,..
                            "private", struct(..
                            "mlink_link_id", -1000,..
                            "userhostlib_link_id", -1000,..
                            "connection_id", -1,..
                            "has_mdaq_block", %F,..
                            "has_mdaq_param_sim", %F,..
                            "mem_write_idx", 0,..
                            "mem_read_idx", 0,..
                            "to_file_idx", 0,..
                            "dac_idx", 0,..
                            "adc_idx", 0,..
                            "webscope_idx", 0,..
                            "udpsend_idx", 0,..
                            "udprecv_idx", 0,..
                            "tcpsend_idx", 0,..
                            "tcprecv_idx", 0,..
                            "mdaq_signal_id", 0,..
                            "mdaq_param_id", 0,..
                            "ao_scan_ch_count", -1,..
                            "mdaq_hwid",..
                            "adc_info",..
                            "dac_info", [])..
                            );

// check minimal version (xcosPal required)
// =============================================================================
if ~isdef('xcosPal') then
    // and xcos features required
    error(gettext('Scilab 5.5.2 or more is required.'));
end

// =============================================================================
// force to load some libraries (dependancies)
loadScicos();
// =============================================================================
etc_tlbx  = get_absolute_file_path("microdaq_start_sci6.sce");
etc_tlbx  = getshortpathname(etc_tlbx);
root_tlbx = strncpy( etc_tlbx, length(etc_tlbx)-length("\etc\") );

fd=mopen(root_tlbx+filesep()+"VERSION");
version=mgetl(fd,-1);
mclose(fd);

mprintf("Start MicroDAQ toolbox ver: %s\n", mgetl(root_tlbx + filesep() + "VERSION", 1));

if isdef("microdaqlib") then
    warning("MicroDAQ toolbox is already loaded!");
    return;
end

// Load functions library
// =============================================================================
mprintf("\tLoad macros\n");
pathmacros = pathconvert( root_tlbx ) + "macros" + filesep();

if isdir(pathmacros) == %F then
    macroBinPath = pathconvert(root_tlbx+'/bin/'+string(sci_ver(1)));
    copyfile(macroBinPath, root_tlbx);
end


microdaqlib = lib(pathmacros);
pathmacros = pathconvert( root_tlbx ) + "macros" + filesep() + "microdaq_blocks" + filesep();
microdaqBlocks = lib(pathmacros);
pathmacros = pathconvert( root_tlbx ) + "macros" + filesep() + "microdaq_macros" + filesep();
microdaqMacros = lib(pathmacros);
userblock_path = root_tlbx + pathconvert("/macros/user_blocks/");


if isfile(mdaqToolboxPath() + "etc"+filesep()+"mlink"+filesep()+"hwid") then
    load(mdaqToolboxPath() + "etc"+filesep()+"mlink"+filesep()+"hwid");
    %microdaq.private.mdaq_hwid = mdaq_hwid;
    %microdaq.private.adc_info = adc_info;
    %microdaq.private.dac_info = dac_info;
    
    %microdaq.model = 'MicroDAQ E' + string(mdaq_hwid(1))..
    + '-ADC0' + string(mdaq_hwid(2))..
    + '-DAC0' + string(mdaq_hwid(3))..
    + '-' + string(mdaq_hwid(4)) + string(mdaq_hwid(5));
    clear mdaq_hwid;
end

// Load demos
// =============================================================================
if or(getscilabmode() == ["NW";"STD"]) then
    mprintf("\tLoad demos\n");
    pathdemos = pathconvert(root_tlbx+filesep()+"demos"+filesep()+"microdaq.dem.gateway.sce", %F, %T);
    add_demo("MicroDAQ", pathdemos);
end

// Load and add help chapter
// =============================================================================
if or(getscilabmode() == ["NW";"STD"]) then
    mprintf("\tLoad help\n");
    path_addchapter = pathconvert(root_tlbx+'/jar/', %F);
    if ( isdir(path_addchapter) <> [] ) then
        add_help_chapter("MicroDAQ", path_addchapter, %F);
    else
        warning("Cannot load help file.")
    end
end


// Load shared libraries
mprintf("\tLoad MLink library\n");
exec(pathconvert(root_tlbx + "/etc/mlink/MLink.sce", %f),-1);

if (sci_ver_str == 'scilab-5.5.2') | (sci_ver_str == 'scilab-5.5.2.1') then
    if isdef("xcosAddToolsMenu") == %F then
        loadXcosLibs();
        sleep(1000)
    end
    
    // Load libmdaqblocks
    exec(pathconvert(root_tlbx + "/etc/mdaqlib/loader.sce", %f),-1);

    // Add MicroDAQ toolbox options to XCos menu
    xcosAddToolsMenu("MicroDAQ web panel", "mdaq_webpanel()");
    xcosAddToolsMenu("MicroDAQ user disk", "mdaq_userdisk()");
    xcosAddToolsMenu("MicroDAQ execution profile", "mdaq_exec_profile_show()");
    xcosAddToolsMenu("MicroDAQ upload model", "mdaq_dsp_upload()");
    xcosAddToolsMenu("MicroDAQ build model", "mdaq_code_gen(%F)");
    xcosAddToolsMenu("MicroDAQ load model", "load_last_dsp_image()");
    xcosAddToolsMenu("MicroDAQ build and load model", "mdaq_code_gen(%T)");


    // Add blocks to the Xcos palette
    // =============================================================================
    mprintf("\tLoad MicroDAQ blocks\n");
    
    // if TMPDIR contains gif or svg files remove them
    img_files = ls(TMPDIR);
    img_files_index = grep(img_files, ".gif");
    if img_files_index <> [] then
        for i = 1:size(img_files_index, '*')
            deletefile(TMPDIR + filesep() + img_files(img_files_index(i)));
        end
    end
    
    img_files_index = grep(img_files, ".svg");
    if img_files_index <> [] then
        for i = 1:size(img_files_index, '*')
            deletefile(TMPDIR + filesep() + img_files(img_files_index(i)));
        end
    end
end
    // ---- Load MicroDAQ User blocks ----
    // This feature is not available on Scilab 6, yet 
    if sci_ver(1) <> 6 then
        if isfile(userblock_path+'lib') == %T then
            microdaqUserBlocks = lib(userblock_path);
        else
            microdaqUserBlocks = [];
        end
        // Load MicroDAQ base blocks
        load_mdaq_palette();
    
        if isfile(userblock_path+'lib') == %T then
            mprintf("\tLoad MicroDAQ User blocks\n");

            blocks = [];
            tmp_path = pwd();
            cd(userblock_path);
            macros = ls("mdaq_*.bin");
            cd(tmp_path);
            for b=1:size(macros, "r")
                macros(b) = part(macros(b), 1:length(macros(b)) - 4);
                if part(macros(b), length(macros(b)) - 3:length(macros(b))) <> "_sim"
                    if isfile(userblock_path + macros(b) + '.sci')  == %T then
                        blocks = [blocks, macros(b)];
                    end
                end
            end
      
            pal = xcosPal("MicroDAQ User");
    
            for i=1:size(blocks, "*")
                h5  = ls(root_tlbx + "/images/h5/"  + blocks(i) + "." + ["sod" "h5"]);
                gif = ls(root_tlbx + "/images/gif/" + blocks(i) + "." + ["png" "jpg" "gif"]);
                svg = ls(root_tlbx + "/images/svg/" + blocks(i) + "." + ["png" "jpg" "gif" "svg"]);
                pal = xcosPalAddBlock(pal, h5(1), gif(1), svg(1));
            end
    
            if ~xcosPalAdd(pal,"MicroDAQ User") then
                error(msprintf(gettext("%s: Unable to export %s.\n"), "microdaq.start", "pal"));
            end
        end
    end

    %microdaq.ip_address = mdaq_get_ip();
if sci_ver(1) == 5 then 
        if check_mdaq_compiler() == %F then
            mprintf("\nFor more help on MicroDAQ toolbox, DSP managment functions, C code integration\ntools and other MicroDAQ toolbox features see help (help microdaq).\n\n");
            mprintf("WARNING: MicroDAQ toolbox ver 1.2.x requires firmware ver 2.0.0 or higher.\n\t Make sure that latest firmware has been installed. Link to latest\n\t firmware version https://github.com/microdaq/Firmware\n\n\t TI Code Composer Studio 5.x is no longer supported. Please install\n\t proper C6000 compiler, XDC tools and SYS/BIOS according to \n\t following links:\n\n")
            mprintf("\t - C6000 compiler, ver. 7.4.21:              http://software-dl.ti.com/codegen/non-esd/downloads/download.htm#C6000\n");
            mprintf("\t - XDCTools, ver. 3.50.00.10 (with a JRE):   http://software-dl.ti.com/dsps/dsps_public_sw/sdo_sb/targetcontent/rtsc/\n");
            mprintf("\t - SYS/BIOS, ver. 6.50.01.12:                http://software-dl.ti.com/dsps/dsps_public_sw/sdo_sb/targetcontent/sysbios/\n\n");
    
            mprintf("WARNING: Replace all MicroDAQ blocks in your existing models with blocks from release 1.2v.\n");
            if sci_ver(1) == 5 then 
                mprintf("\nRun microdaq_setup to configure toolbox:\n\tmicrodaq_setup() - GUI mode\n\tmicrodaq_setup(compilerPath, xdctoolsPath, sysbiosPath, ipAddress) - non-GUI mode");
            end
        end
    
    userhostlib_loader = root_tlbx + pathconvert("/etc/userlib/hostlib/loader.sce", %f);
    
    if isfile(userhostlib_loader) then
        mprintf("\tLoad user host library\n");
        exec(userhostlib_loader);
    end
else
    [mdaq_ip_addr, res] = mdaq_get_ip();
    if mdaq_ip_addr == [] then
       mprintf("\nWARNING: DSP support on MicroDAQ E2000/E1100 is not available\n\t on Scilab 6.0.0. Use Scilab 5.5.2 for C code generation\n\t for DSP.\n");
       mprintf("\nRun microdaq_setup to configure toolbox:\n\tmicrodaq_setup(ipAddress)"); 
    end
end


