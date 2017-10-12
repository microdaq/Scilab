function [] = microdaq_setup(arg1, arg2, arg3, arg4)
    sciVer = getversion('scilab');
    if isequal(sciVer(1:2), [5,5]) & argn(2) == 0 then
        scriptPath = mdaq_toolbox_path()+'macros'+filesep()+'microdaq_setup_template.sce';
        exec(scriptPath, -1);
        while STATE
            if findobj('Tag', 'edit2') == [] then
                global STATE
                STATE = 0
                sleep(100)
            end
        end
        return
    elseif isequal(sciVer(1:3), [6,0,0]) then
        mprintf("\nMicroDAQ toolbox on Scilab 6.0 has limited functionality. \nCode generation from Xcos diagram, DSP management functions\nand legacy C code integration in not supported.\nUse Scilab 5.5.2 to have full-featured MicroDAQ toolbox for Scilab\n");
        if argn(2) <> 1 then
            mprintf("Use microdaq_setup with IP address setting to configure toolbox e.g.:\n\tmicrodaq_setup(""10.10.1.1"")\n");
            return
        else
            mdaq_set_ip(arg1)
            return
        end
    elseif isequal(sciVer(1:2), [5,5]) & argn(2) == 4 then
        CompilerRoot = getshortpathname(pathconvert(arg1, %F));
        XDCRoot = getshortpathname(pathconvert(arg2, %F));
        BIOSRoot = getshortpathname(pathconvert(arg3, %F));
        ipAddress = arg4;
    else
        error("Unsupported Scilab version!");
    end

    try
        mdaq_set_ip(ipAddress);
    catch
        mprintf("Wrong IP address!\n");
        mprintf("Usage:\n\t microdaq_setup(compilerPath, xdctoolsPath, sysbiosPath, ipAddress);\n");
        return;
    end

    // checking firmware
    [firmVer rawFrimVer res] = mdaq_fw_version_url();
    if res == %F then
        disp('Unable to verify MicroDAQ firmware - make sure you have latest MicroDAQ firmware installed!');
    elseif firmVer(1) < 2 then
        disp('Firmware version '+rawFrimVer+' is not supported.Please upgrade MicroDAQ firmware!');
    else
        result = mdaq_open();
        if result < 0  then
            disp('Unable to connect to MicroDAQ device!');
        else
            global %microdaq;
            disp(%microdaq.model + ' connected, firmware version: '+rawFrimVer);
            mdaq_close(result);
        end
    end

    dir_temp = pwd();

    TARGET_ROOT = pathconvert(dirname(get_function_path('microdaq_setup'))+"\..\etc", %F);
    FILE_ROOT = pathconvert(dirname(get_function_path('microdaq_setup'))+"\..\rt_templates\target_paths.mk", %F);

    sysbios_build_cmd = 'SET PATH=' + pathconvert(XDCRoot + "/jre/bin/") + ';%PATH% & ';
    sysbios_build_cmd = XDCRoot + filesep() + 'xs --xdcpath=""' + BIOSRoot + filesep() +'packages' + '"" xdc.tools.configuro -o configPkg -t ti.targets.elf.C674 -p ti.platforms.evmOMAPL137 -r release -c ' + CompilerRoot + ' --compileOptions ""-g --optimize_with_debug""  sysbios.cfg';

    sysbios_build_cmd = strsubst(sysbios_build_cmd, filesep()+filesep(), filesep());

    disp("Building TI SYS/BIOS real-time operating system for MicroDAQ");
    cd( TARGET_ROOT+ filesep() + 'sysbios' + filesep() + 'cpu0' + filesep());
    unix_w(sysbios_build_cmd);
    cd( TARGET_ROOT+ filesep() + 'sysbios' + filesep() + 'cpu1' + filesep());
    unix_w(sysbios_build_cmd);

    //path to /configPkg/linker.cmd
    LINKER0_PATH = pathconvert(TARGET_ROOT + '\sysbios\cpu0\configPkg\linker.cmd', %F);
    LINKER1_PATH = pathconvert(TARGET_ROOT + '\sysbios\cpu1\configPkg\linker.cmd', %F);

    if isfile(LINKER0_PATH) then
        [linker0,err] = mopen(LINKER0_PATH,'a')
        [linker1,err] = mopen(LINKER1_PATH,'a')
        if err < 0 then
            error("Unable to build MicroDAQ toolbox components!")
        else
            //Append 'sysbios_linker.cmd' to /configPkg/linker.cmd
            SYSBIOS_LINKER_PATH = pathconvert(TARGET_ROOT + '\sysbios\sysbios_linker.cmd', %F);
            [sysbios_linker,err] = mopen(SYSBIOS_LINKER_PATH, 'r');
            content = mgetl(sysbios_linker);
            mclose(sysbios_linker)
            mputl(content,linker0)
            mputl(content,linker1)
            mclose(linker0);
            mclose(linker1);

            //Generate 'target_path.mk'
            [f,result0] = mopen(FILE_ROOT,'w');
            if result0 < 0 then
                error('Building failed. Cannot create file ''target_path.mk''');
            else
                mputl('# MicroDAQ paths',f)
                mputl('',f)
                mputl('CompilerRoot  = '+CompilerRoot,f)
                mputl('TargetRoot    = '+TARGET_ROOT,f)
                mputl('XDCRoot       = '+XDCRoot,f)
                mputl('BIOSRoot      = '+BIOSRoot,f)
                mclose(f)
            end
            disp('Setup complete - toolbox is ready to use!');
            cd(dir_temp);
        end;
    else
        cd(dir_temp);
        error('Building failed.');
    end

endfunction
