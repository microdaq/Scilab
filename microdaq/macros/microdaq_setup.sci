function [] = microdaq_setup(arg1, arg2)
    sciVer = getversion('scilab');
    if sciVer(1) == 5 & argn(2) <> 2 then
        mprintf("Description:\n");
        mprintf("\tConfigures MicroDAQ toolbox\n");
        mprintf("Usage:\n");
        mprintf("\tmicrodaq_setup(compilerPath, ipAddress)\n")
        mprintf("\tcompilerPath - the C6000 compiler installation path e.g ""c:\\ti\\c6000_7.4.21\\""\n");
        mprintf("\tipAddress - MicroDAQ IP address e.g ""10.10.1.1""\n");
        return
    elseif sciVer(1) == 6 & argn(2) <> 1 then
        mprintf("Description:\n");
        mprintf("\tConfigures MicroDAQ toolbox\n");
        mprintf("Usage:\n");
        mprintf("\tmicrodaq_setup(ipAddress)\n")
        mprintf("\tipAddress - MicroDAQ IP address e.g ""10.10.1.1""\n");
        return
    end

    if sciVer(1) == 5 then
        if isfile(pathconvert(arg1 + "\bin\") + "cl6x.exe") | isfile(pathconvert(arg1 + "/bin/") + "cl6x") then
            CompilerRoot = getshortpathname(pathconvert(arg1, %F));
            ipAddress = arg2;         
        else
            error("Unable to locate compiler in " + arg1);
        end
    elseif sciVer(1) == 6 then
        ipAddress = arg1; 
        try
            mdaqSetIP(ipAddress)
        catch 
            error("Unable to set MicroDAQ IP address");
        end
        disp('Setup complete - toolbox is ready to use!');
        return 
    else
        error("Unsupported Scilab version");
    end
    
    // set MicroDAQ IP address
    try
        mdaqSetIP(ipAddress)
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

    disp('Setup complete - toolbox is ready to use!');
endfunction
