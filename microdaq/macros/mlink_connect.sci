function [link_fd, hwid] = mdaq_connect(ip, port)
    [result, link_fd] = call("sci_mlink_connect",..
            ip, 1, "c",..
            port, 2, "i",..
        "out",..
            [1, 1], 3, "i",..
            [1, 1], 4, "i");
    if result > -1 then
        [hwid, result] = call("sci_mlink_hwid",..
            link_fd, 1, "i",..
        "out",..
            [5, 1], 2, "i",..
            [1, 1], 3, "i");
        
        if result > -1 then 
            global %microdaq; 
            if isequal(%microdaq.private.mdaq_hwid, hwid) == %F then
                %microdaq.private.mdaq_hwid = hwid;
                %microdaq.model = 'MicroDAQ E' + string(hwid(1))..
                                + '-ADC0' + string(hwid(2)).. 
                                + '-DAC0' + string(hwid(3))..
                                + '-' + string(hwid(4)) + string(hwid(5));
                                mdaq_hwid = hwid; 
                save(mdaq_toolbox_path() + "etc"+filesep()+"mlink"+filesep()+"hwid", 'mdaq_hwid');
            end
        end
    end
endfunction