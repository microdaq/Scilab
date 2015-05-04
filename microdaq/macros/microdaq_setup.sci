function [] = microdaq_setup()
    SETUP_PATH = mdaq_toolbox_path()+'macros'+filesep()+'microdaq_setup_template.sce';
    exec(SETUP_PATH,-1);
    while STATE
        if findobj('Tag','edit1') == [] then
            global STATE
            STATE = 0
            sleep(500)
        end
    end
endfunction
