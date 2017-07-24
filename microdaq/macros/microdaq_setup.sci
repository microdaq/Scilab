function [] = microdaq_setup()
    sci_ver_str = getversion('scilab', 'string_info');
    
    if sci_ver_str == 'scilab-5.5.2' then
     SETUP_PATH = mdaq_toolbox_path()+'macros'+filesep()+'microdaq_setup_template.sce';
        exec(SETUP_PATH,-1);
        while STATE
            if findobj('Tag','edit2') == [] then
                global STATE
                STATE = 0
                sleep(100)
            end
        end
    else
        str = [ 
        "MicroDAQ toolbox running on Scilab 6 do not support some major features.";
        "Curentlly features like DSP managment functions and C code integration";
        "are only available on Scilab 5.5.2.";
        ];
        messagebox(str, "MicroDAQ setup", "info");
    end
endfunction
