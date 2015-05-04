function block=mdaq_uart_read_sim(block,flag)
    global %microdaq;
    if %microdaq.dsp_loaded == %F then
        select flag
        case 4 // Initialization
            disp("WARNING: mdaq_uart_read block isn''t supported in host simulation mode!")
        end
    end
endfunction
