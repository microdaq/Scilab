function [] = microdaq_setup()
    sci_ver_str = getversion('scilab', 'string_info');
    
    if sci_ver_str == 'scilab-5.5.2' then
     SETUP_PATH = mdaq_toolbox_path()+'macros'+filesep()+'microdaq_setup_template.sce';
        exec(SETUP_PATH,-1);
        while STATE
            if findobj('Tag','edit1') == [] then
                global STATE
                STATE = 0
                sleep(500)
            end
        end
    else
       ip = input("Set MicroDAQ IP address (eg. ''10.10.1.1''): ", "string");
       mdaq_set_ip(ip);
       
        result = mdaq_open();
        if result < 0  then
            warning('Unable to connect to MicroDAQ device!');
        else
            global %microdaq;
            mprintf('%s connected!', %microdaq.model);
            mdaq_close(result);
        end
    end
endfunction
