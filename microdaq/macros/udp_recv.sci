function data = udp_recv(vector_size, count)

    [data result] = call("sci_mlink_udp_recv",..
                count * vector_size, 2, 'i',..
                0, 3, 'i',..
            "out",..
                [vector_size, count], 1, 'd',..
                [1, 1], 4, 'i');

    if result < 0 then
        disp("ERROR: Unable to receive data");
        data = [];
        return
    end
    
    data = data(:,1:result/vector_size)'
endfunction
