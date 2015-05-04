function block=mdaq_mem_write_sim(block,flag)
    global %microdaq;
    if %microdaq.dsp_loaded == %F then
        select flag
        case 4 // Initialization
            disp("WARNING: mdaq_mem_write block isn''t supported in host simulation mode!")
        end
    end
endfunction
