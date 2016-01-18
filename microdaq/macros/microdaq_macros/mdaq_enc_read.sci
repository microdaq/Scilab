function [position, direction] = mdaq_enc_read(arg1, arg2)
    position = [];
    direction = [];
    
    if argn(2) == 1 then
        enc = arg1; 
    end
    
    if argn(2) == 2 then
        link_id = arg1;   
        enc = arg2; 

        if link_id < 0 then
            disp("ERROR: Invalid link ID!")
            return;
        end
    end
    
    if argn(2) > 2 | argn(2) < 1 | enc > 2 | enc < 1 then
        mprintf("Description:\n");
        mprintf("\tReads encoder position and motion direction\n");
        mprintf("Usage:\n");
        mprintf("\tmdaq_enc_read(link_id, encoder);\n")
        mprintf("\tlink_id - connection id returned by mdaq_open() (OPTIONAL)\n");
        mprintf("\tencoder - encoder module (1 or 2)\n");
        return;
    end
    
    if argn(2) == 1 then
        link_id = mdaq_open();
        if link_id < 0 then
            disp("ERROR: Unable to connect to MicroDAQ device!");
            return; 
        end
    end
    
    result = [];
    [position direction result] = call("sci_mlink_enc_get",..
                link_id, 1, "i",..
                enc, 2, "i",..
            "out",..
                [1, 1], 3, "i",..
                [1, 1], 4, "i",..
                [1, 1], 5, "i");
    if result < 0  then
        mdaq_error(result)
    end    
    
    if argn(2) == 1 then
        mdaq_close(link_id);
    end
endfunction
