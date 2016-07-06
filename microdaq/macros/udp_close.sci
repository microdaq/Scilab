function udp_close()
    //EXTERNC MDAQ_API void sci_mlink_udp_close(int *result);
    
    result = [];
    [result] = call("sci_mlink_udp_close",..
            "out",..
                [1,1], 1, 'i');

endfunction
