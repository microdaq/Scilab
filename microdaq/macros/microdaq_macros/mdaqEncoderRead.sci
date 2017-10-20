function [position, direction] = mdaqEncoderRead(arg1, arg2)
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
        mprintf("\tmdaqEncoderRead(link_id, encoder);\n")
        mprintf("\tlink_id - connection id returned by mdaqOpen() (OPTIONAL)\n");
        mprintf("\tencoder - encoder module (1 or 2)\n");
        return;
    end
    
    if argn(2) == 1 then
        link_id = mdaqOpen();
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

    if argn(2) == 1 then
        mdaqClose(link_id);
    end
    
    if result < 0  then
        error(mdaq_error2(result), 10000 + abs(result)); 
    end
endfunction
