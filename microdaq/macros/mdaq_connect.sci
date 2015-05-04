function link_fd = mdaq_connect(ip, port)
    [result, link_fd] = call("sci_mlink_connect",..
            ip, 1, "c",..
            port, 2, "i",..
        "out",..
            [1, 1], 3, "i",..
            [1, 1], 4, "i");
endfunction
