function [] = microdaq_setup(arg1, arg2)

    if argn(2) <> 1 & argn(2) <> 2 then
        mprintf("Description:\n");
        mprintf("\tConfigures MicroDAQ toolbox\n");

        mprintf("\nMicroDAQ firmware:\n\t The MicroDAQ toolbox ver 1.3 requires MicroDAQ firmware ver 2.2.x or higher.\n\t Check MicroDAQ firmware version with MicroDAQ web panel and upgrade if needed.\n\t Download page: https://github.com/microdaq/Firmware");

        mprintf("\n\nDSP compiler (only for E2000 series devices):\n\t The MicroDAQ toolbox ver 1.3 requires only C6000 DSP compiler. Donwload and install:\n");

        mprintf("\t TI C6000 DSP compiler, ver. 7.4.21    \n\t Download page: http://software-dl.ti.com/codegen/non-esd/downloads/download.htm#C6000\n");

        mprintf("\t WARNING: Download exactly ver. 7.4.21. Other versions of compiler may not work properly. \n");

        mprintf("\nHelp and demos:\n\t Examples and demos can be found in Scilab demo browser in\n\t MicroDAQ section. For help type ''help microdaq'' in Scilab console\n");


        mprintf("Usage:\n");
        mprintf("\tmicrodaq_setup(ipAddress, compilerPath)\n")
        mprintf("\tipAddress - MicroDAQ IP address e.g ""10.10.1.1""\n");
        mprintf("\tcompilerPath - compiler installation path (requred only for E2000 series) e.g ""c:\\ti\\c6000_7.4.21\\""\n");
        return
    end

    // set MicroDAQ IP address
    try
        mdaqSetIP(arg1)
    catch 
        error("Unable to set MicroDAQ IP address");
    end

    // checking firmware
    [firmVer rawFrimVer res] = mdaq_fw_version_url();
    if res == %F then
        disp('Unable to verify MicroDAQ firmware - make sure you have latest MicroDAQ firmware installed!');
    elseif firmVer(1) < 2 then
        disp('Firmware version '+rawFrimVer+' is not supported.Please upgrade MicroDAQ firmware!');
    else
        result = mdaqOpen();
        if result < 0  then
            disp('Unable to connect to MicroDAQ device!');
        else
            global %microdaq;
            disp(%microdaq.model + ' connected, firmware version: '+rawFrimVer);
            mdaqClose(result);
        end
    end

    if argn(2) == 2 then
        
        // check provided compiler install path
        if getos() == "Windows" then
            compilerFile = "cl6x.exe"
        else
            compilerFile = "cl6x"
        end
        if isfile(pathconvert(arg2 + "\bin\") + compilerFile) then
            CompilerRoot = getshortpathname(pathconvert(arg2, %F));     
        else
            error("Unable to locate compiler (" + compilerFile + ") in " + arg2);
        end
        
        dir_temp = pwd();

        targetRoot = pathconvert(fileparts(get_function_path('microdaq_setup'))+"..\etc", %F);
        targetPathsFile = pathconvert(fileparts(get_function_path('microdaq_setup'))+"\..\rt_templates\target_paths.mk", %F);
        cpu0LinkerFile = pathconvert(targetRoot + '\sysbios\cpu0\configPkg\linker.cmd', %F);
        mkdir(pathconvert(targetRoot + '\sysbios\cpu0\configPkg', %F));
        cpu1LinkerFile = pathconvert(targetRoot + '\sysbios\cpu1\configPkg\linker.cmd', %F);
        mkdir(pathconvert(targetRoot + '\sysbios\cpu1\configPkg', %F));
        linkerTemplateFile = pathconvert(targetRoot + '\sysbios\linker.template', %F);

        [cpu0Linker, res1] = mopen(cpu0LinkerFile, 'w')
        [cpu1Linker, res2] = mopen(cpu1LinkerFile, 'w')
        if res1 < 0 | res2 < 0 then
            error("Unable to create linker file")
        end

        [linkerTemplate, res1] = mopen(linkerTemplateFile, 'r')
        if res1 < 0 then
            error("Unable to open linker template file")
        end 
        linker = mgetl(linkerTemplate);
        mclose(linkerTemplate);    

        [targetPaths, res1] = mopen(targetPathsFile, 'w');
        if res1 < 0 then
            error('Building failed. Cannot create file ''target_path.mk''');
        end

        mputl('-l""' + pathconvert(targetRoot + '\sysbios\boot.ae674', %F) + '""', cpu0Linker);
        mputl('-l""' + pathconvert(targetRoot + '\sysbios\ti.targets.rts6000.ae674', %F) + '""', cpu0Linker);
        mputl('-l""' + pathconvert(targetRoot + '\sysbios\cpu0\libs\sysbios_pe674.oe674', %F) + '""', cpu0Linker);
        mputl('-l""' + pathconvert(targetRoot + '\sysbios\cpu0\libs\sysbios.ae674', %F) + '""', cpu0Linker);
        mputl(linker, cpu0Linker);
        mclose(cpu0Linker)

        mputl('-l""' + pathconvert(targetRoot + '\sysbios\boot.ae674', %F) + '""', cpu1Linker);
        mputl('-l""' + pathconvert(targetRoot + '\sysbios\ti.targets.rts6000.ae674', %F) + '""', cpu1Linker);
        mputl('-l""' + pathconvert(targetRoot + '\sysbios\cpu1\libs\sysbios_pe674.oe674', %F) + '""', cpu1Linker);
        mputl('-l""' + pathconvert(targetRoot + '\sysbios\cpu1\libs\sysbios.ae674', %F) + '""', cpu1Linker);
        mputl(linker, cpu1Linker);
        mclose(cpu1Linker)

        mputl('# MicroDAQ paths', targetPaths)
        mputl('',targetPaths)
        mputl('CompilerRoot  = ' + CompilerRoot, targetPaths)
        mputl('TargetRoot    = '+ targetRoot, targetPaths)
        mclose(targetPaths)
    end
    messagebox("MicroDAQ toolbox is configured and ready to use!", "Toolbox configuration", "info");
endfunction
