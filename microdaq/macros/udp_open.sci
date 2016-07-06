function result = udp_open(ip, port)

//EXTERNC MDAQ_API void sci_mlink_udp_open(char *ip, int *port, int *result);
    result = [];
    if type(ip) == 10 then
    [result] = call("sci_mlink_udp_open",..
            ip, 1, "c",..
            port, 2, "i",..
        "out",..
            [1, 1], 3, "i");        
    else
        disp("ERROR: Incorrect IP address!");
    end
endfunction
