function mdaq_pru_set(arg1, arg2, arg3, arg4)
    link_id = -1; 

    if argn(2) == 3 then
        pru_core = arg1;  
        pru_reg = arg2; 
        value = arg3; 
    end
    
    if argn(2) == 4 then
        link_id = arg1; 
        pru_core = arg2;  
        pru_reg = arg3; 
        value = arg4; 

        if link_id < 0 then
            disp("ERROR: Invalid link ID!")
            return;
        end
    end

    if argn(2) > 4 | argn(2) < 3 | pru_core > 1 | pru_core < 0 | pru_reg > 15 | pru_reg < 0 then
        mprintf("Description:\n");
        mprintf("\tSets PRU register\n");
        mprintf("Usage:\n");
        mprintf("\tmdaq_pru_set(link_id, pru_core, pru_reg, value);\n")
        mprintf("\tlink_id - connection id returned by mdaq_open() (OPTIONAL)\n");
        mprintf("\tpru_core - PRU core number (0 or 1)\n");
        mprintf("\tpru_reg - PRU register (0-15)\n");
        mprintf("\tvalue - PRU register value (integer only)\n");
        return;
    end
    
    if argn(2) == 3 then
        link_id = mdaq_open();
        if link_id < 0 then
            disp("ERROR: Unable to connect to MicroDAQ device!");
            return; 
        end
    end
    
    result = [];
    result = call("sci_mlink_pru_reg_set",..
                link_id, 1, "i",..
                pru_core, 2, "i",..
                pru_reg, 3, "i",..
                int(value), 4, "i",..
            "out",..
                [1, 1], 5, "i");

    if result < 0  then
        mdaq_error(result)
    end
    
    if argn(2) == 3 then
        mdaq_close(link_id);
    end
endfunction
