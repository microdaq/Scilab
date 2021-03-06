function mdaqBlockBuild(debug_build, host_build)
    global %microdaq;

    if  check_mdaq_compiler() == %F then
        disp("ERROR: Compiler not found - run microdaq_setup! ");
        return;
    end
    
    if argn(2) < 2 then
        host_build = %F;
    end 
    
    if argn(2) < 1 then
        debug_build = %F;
    end 

    root_path = mdaqToolboxPath();
    userlib_src_path = root_path + filesep() + "src" + filesep() + "c"+ filesep() + "userlib" + filesep();
    userlib_path = root_path + filesep() + "etc" + filesep() + "userlib" + filesep() + "lib" + filesep();
    userhostlib_path = root_path + filesep() + "etc" + filesep() + "userlib" + filesep() + "hostlib" + filesep();
    macros_path = mdaqToolboxPath() + "macros" + filesep() + "user_blocks" + filesep();
      
    p_dir = pwd();
    chdir(userlib_src_path);
    GMAKE = root_path + "\etc\bin\gmake.exe";
    mprintf(" ### Building DSP library...\n")
    if getenv('WIN32','NO')=='OK' then
        if argn(2) > 1 & argn(2) < 3 then
            if debug_build then
                unix_w(GMAKE + ' -f Makefile' + ' OPT_FLAG=-g');
            else
                unix_w(GMAKE + ' -f Makefile' );
            end

        else
            unix_w(GMAKE + ' -f Makefile' );
        end

    else
        if argn(2) > 0 & argn(2) < 2 then
            if debug_build then
                unix_w('make' + ' OPT_FLAG=-g')
            else
                unix_w('make')
            end
        else
            unix_w('make')
        end

    end
    
    //delete old one 
    mdelete(userlib_path+'userlib');
    
    if isfile("userlib.lib") then
        copyfile("userlib.lib", userlib_path);
    end
    
    //get list of existing blocks 
    blocks = [];
    cd(macros_path);
    macros = ls("*_sim.sci")
    for i=1:size(macros,'*')
        blocks(i) = part(macros(i), 1:length(macros(i)) - 8);
    end
    if blocks == [] then
        chdir(p_dir);  
        error("Nothing to build. Add new block first.")
    end
    chdir(userlib_src_path);

    //Building userdll for host
    if haveacompiler() & (host_build == %T) then
        if %microdaq.private.userhostlib_link_id <> -1000 then
                ulink(%microdaq.private.userhostlib_link_id);
        end
        //delete files related to user blocks  
        mdelete(userhostlib_path+'loader.sce');
        mdelete(userhostlib_path+'libuserhost'+getdynlibext());
        mdelete(macros_path+'lib');
        mdelete(macros_path+'names');
        mdelete(macros_path+'*.bin');
        try 
            xcosPalDelete("MicroDAQ User");
        catch
          
        end
        
        
        c_files = ls("*.c");    
        if c_files == [] then
            chdir(p_dir); 
            return;
        end
        
        mprintf(" ### Building host library...\n")
        c_flags = "";
        scicos_libpath = "";
        os = getos();
        if os == 'Windows' then
            cflags = "-I scilab";
            scicos_libpath = SCI + filesep() + "bin" + filesep() + "scicos"
        elseif os == 'Linux' then
            cflags    = '-I '+pwd()+filesep()+'scilab';
            scicos_libpath = SCI+"/../../lib/scilab/libsciscicos";
        else
            error("This platform is not supported!");
        end

        ldflags=['-lpthread -lstdc++ -lm '];  
        libs=[scicos_libpath];

        tbx_build_src(blocks, c_files', 'c', userlib_src_path ,libs , "", cflags, "", "", "userhost", "loader.sce");

        //generate custom loader 
        blocks_link = "";
        for i=1:max(size(blocks))
            blocks_link =blocks_link+'''' +blocks(i)+''''
            if i <> max(size(blocks)) then
                blocks_link = blocks_link + ',';
            end
        end

        disp(blocks_link);

        loader_template = [
        '//Generated by mdaqBlockBuild function, do not change content.'
        'global %microdaq;'
        ''
        '//ulink previous library'
        'if %microdaq.private.userhostlib_link_id <> -1000 then'
        '   ulink(%microdaq.private.userhostlib_link_id);'
        'end'
        ''
        'userhost_path = get_absolute_file_path(''loader.sce'');'
        '%microdaq.private.userhostlib_link_id = link(userhost_path+''libuserhost''+getdynlibext(), ['+blocks_link'+'], ''c'');'
        'clear userhost_path;'
        ];

        fd = mopen('loader.sce','wt');
        mputl(loader_template,fd);
        mclose(fd);


        if isfile("libuserhost"+getdynlibext()) then
            if isdir(userhostlib_path) == %F then
                mkdir(userhostlib_path);
            end
            
            copyfile("libuserhost"+getdynlibext(), userhostlib_path);
            copyfile("loader.sce", userhostlib_path);
            exec("cleaner.sce");
            exec(userhostlib_path+"loader.sce");
        end
    elseif haveacompiler() == %F then 
        mprintf("WARNING: No compiler detected, cannot build user host library. Make sure that the valid\n")
        mprintf("\t compiler is installed. More information about supported compilers is available at:\n");
        mprintf("\t https://help.scilab.org/doc/5.5.2/en_US/supported_compilers.html");
    end
    
    userhostlib_loader = mdaqToolboxPath() + pathconvert("/etc/userlib/hostlib/loader.sce", %f);
    if isfile(userhostlib_loader) then
        mprintf("\tLoad user host library\n");
        exec(userhostlib_loader);
    end
    
    mprintf(" ### Building user block macros...\n")
    
    tbx_build_macros("microdaq", macros_path);
    cd(mdaqToolboxPath());
    tbx_build_blocks(mdaqToolboxPath(), blocks, "macros" + filesep() + "user_blocks");  
    chdir(p_dir);
    
    
    root_tlbx = mdaqToolboxPath();
    //Reload user block palette   
    if isfile(macros_path+'lib') == %T 
        //microdaqUserBlocks = lib(macros_path);
        getd(macros_path);
        mprintf("\tReload MicroDAQ User blocks\n");
        blocks = [];
        
        tmp_path = pwd();
        cd(macros_path);
        macros = ls("mdaq_*.bin");
        cd(tmp_path);
        
        for b=1:size(macros, "r")
            macros(b) = part(macros(b), 1:length(macros(b)) - 4);
            if strstr(macros(b), "_sim") == ""
                if isfile(macros_path + macros(b) + '.sci')  == %T then
                    blocks = [blocks, macros(b)];
                end
            end
        end
        
        try
            xcosPalDelete("MicroDAQ User");
        catch
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
endfunction


