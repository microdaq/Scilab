function [] = microdaq_setup(CompilerRoot, XDCRoot, BIOSRoot, IPAddress)
    if getversion() == "scilab-6.0.0" then
        if argn(2) == 0 then
           mprintf("Usage:\n\tmicrodaq_setup(compilerPath, XdcPath, BIOSPath, IPaddress);");
           return;
        end
        dir_temp = pwd();
        p = [CompilerRoot, XDCRoot, BIOSRoot]
        for i=1:3
            len = length(p(i));
            if part(p(i), len:len ) == "\" |..
                part(p(i), len:len ) =="/" then
                p(i) = part(p(i), 1:len - 1)
            end
        end
        CompilerRoot = p(1);
        XDCRoot = p(2);
        BIOSRoot = p(3);
        clear p;

        //build system
        TARGET_ROOT = dirname(get_function_path('mdaqSetup'))+"\..\etc";
        FILE_ROOT = dirname(get_function_path('mdaqSetup'))+"\..\rt_templates\target_paths.mk"

        sysbios_build_cmd = "SET PATH=" + XDCRoot + filesep() + "jre" + filesep() + "bin" + filesep() +";%PATH% & ";
        sysbios_build_cmd = sysbios_build_cmd + XDCRoot + filesep() + 'xs --xdcpath=""' + BIOSRoot + '/packages;""' + ' xdc.tools.configuro -o configPkg -t ti.targets.elf.C674 -p ti.platforms.evmOMAPL137 -r release -c ' + CompilerRoot + ' --compileOptions ""-g --optimize_with_debug""  sysbios.cfg'

        disp("Building TI SYS/BIOS real-time operating system for MicroDAQ");
        cd( TARGET_ROOT+ filesep() + 'sysbios' + filesep() + 'cpu0' + filesep());
        unix_w(sysbios_build_cmd);
        cd( TARGET_ROOT+ filesep() + 'sysbios' + filesep() + 'cpu1' + filesep());
        unix_w(sysbios_build_cmd);

        //path to /configPkg/linker.cmd
        LINKER0_PATH = TARGET_ROOT + '\sysbios\cpu0\configPkg\linker.cmd';
        LINKER1_PATH = TARGET_ROOT + '\sysbios\cpu1\configPkg\linker.cmd';

        if isfile(LINKER0_PATH) then
            [linker0,err] = mopen(LINKER0_PATH,'a')
            [linker1,err] = mopen(LINKER1_PATH,'a')
            if err < 0 then
                messagebox('Building failed.','Building sys','error');
            else
                //Append 'sysbios_linker.cmd' to /configPkg/linker.cmd
                SYSBIOS_LINKER_PATH = TARGET_ROOT + '\sysbios\sysbios_linker.cmd';
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
                    messagebox('Building failed. Cannot create file ''target_path.mk'' ','Building sys','error');
                    close_callback();
                    return
                else
                    mputl('# MicroDAQ paths',f)
                    mputl('',f)
                    mputl('CompilerRoot  = '+CompilerRoot,f)
                    mputl('TargetRoot    = '+TARGET_ROOT,f)
                    mputl('CCSRoot       = ',f)
                    mputl('XDCRoot       = '+XDCRoot,f)
                    mputl('BIOSRoot      = '+BIOSRoot,f)
                    mclose(f)
                end

                mdaq_set_ip(IPAddress);

                //close window
                messagebox('Completed.','Building sys','info');
                //consol success message
                disp('');
                cd(dir_temp);
            end;
        else
            cd(dir_temp);
            messagebox('Building failed.','Building sys','error');
        end;

    else
        SETUP_PATH = mdaq_toolbox_path()+'macros'+filesep()+'microdaq_setup_template.sce';
        exec(SETUP_PATH,-1);
        while STATE
            if findobj('Tag','edit1') == [] then
                global STATE
                STATE = 0
                sleep(500)
            end
        end
    end

endfunction
