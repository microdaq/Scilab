function result = mdaqAOScanInit(arg1, arg2, arg3, arg4, arg5, arg6, arg7)
    global %microdaq;
    result = []
    link_id = -1;
    channelNames = [];
    if argn(2) == 1 then
        channels = arg1.Channels;
        data = [];
        ao_range = arg1.Range;
        continuous = arg1.isContinuous;
        scan_freq = arg1.Rate;
        scan_time = arg1.DurationInSeconds;
        channelNames = arg1.Name
    elseif  argn(2) == 2 then
        channels = arg2.Channels;
        data = [];
        ao_range = arg2.Range;
        continuous = arg2.isContinuous;
        scan_freq = arg2.Rate;
        scan_time = arg2.DurationInSeconds;
        channelNames = arg2.Name
    elseif argn(2) == 6 then
        channels = arg1;
        data = arg2;
        ao_range = arg3;
        continuous = arg4;
        scan_freq = arg5;
        scan_time = arg6;
    elseif argn(2) == 7 then
        link_id = arg1;
        channels = arg2;
        data = arg3;
        ao_range = arg4;
        continuous = arg5;
        scan_freq = arg6;
        scan_time = arg7;

        if link_id < 0 then
            error("Invalid connection id!")
        end
    end

    global %microdaq;
    if %microdaq.private.mdaq_hwid <> [] then
        if  %microdaq.private.mdaq_hwid(3) == 0 then
            error("Unable to detect MicroDAQ configuration. Run mdaqHWInfo() function.");
        end
        dac_info = get_dac_info(%microdaq.private.mdaq_hwid);
        if find([1 2 6 7] == argn(2)) == [] then
            mprintf("Description:\n");
            mprintf("\tInitiates analog signal generation\n");
            mprintf("Usage:\n");
            mprintf("\tmdaqAOScanInit(linkID, channels, initialData, range, isStreamMode, rate, duration)\n")
            mprintf("\tlinkID - connection id (optional)\n");
            mprintf("\tchannels - analog output channels\n");
            mprintf("\tinitialData - initial output data\n");
            mprintf("\trange - analog output range\n");
            mprintf("\t        [-10,10] - single range argument applied for all used channels\n");
            mprintf("\t        [-10,10; -5,5] - multi-range argument for two channels\n");
            mprintf("\tisStreamMode - mode of operation (%s - stream, %s - periodic)\n", "%T", "%F");
            mprintf("\trate - update per second per channel rate\n");
            mprintf("\tduration - duration in seconds (-1 - infinity)\n");
            return;
        end
    else
        error('Unable to detect MicroDAQ configuration. Run mdaqHWInfo() function.');
    end

    ch_count = size(channels, "c");  
    dac_ch_count = strtod(dac_info.channel);  

    if size(channels, 'r') > 1 then
        error("Wrong channel - single row vector expected!")
    end

    if ch_count < 1 | ch_count > dac_ch_count then
        error("Wrong AO channel selected!")
    end

    if max(channels) > dac_ch_count | min(channels) < 1 then
        error("Wrong AO channel selected!")
    end

    if size(data, "c") <> ch_count & data <> [] then
        error("Wrong output data - colums should match selected channels!")
    end

    if size(ao_range, 'c') <> 2 then
        error("Vector range [low,high;low,high;...] expected!")
        return;
    end

    if size(ao_range, 'r') == 1 then
        range_tmp = ao_range;
        ao_range = ones(ch_count,2);
        ao_range(:,1) = range_tmp(1);
        ao_range(:,2) = range_tmp(2);
    end
    range_tmp = ao_range;
    ao_range = matrix(ao_range', 1, ch_count*2);

    if data <> [] then
        data_size = size(data, "*"); 
    else
        data_size = 0; 
    end

    if type(continuous) == 1 then
        if size(find(continuous>1), '*') > 0
            error('Wrong isContinuous - boolean value expected (%T/1, %F/0)');
        end 
    end

    if continuous == %T | continuous == 1 then
        continuous = 1;
    else
        continuous = 0;
    end

    if scan_time < 0 & scan_time <> -1 then
        warning("For infinite AO scan operation use -1 as a duration parameter.\n"); 
        scan_time = -1;
    end

    %microdaq.private.ao_scan_ch_count = ch_count;

    if argn(2) == 6 | argn(2) == 1 then
        link_id = mdaqOpen();
        if link_id < 0 then
            error("Unable to connect to MicroDAQ device!"); 
        end
    end

    result = [];
    result = call("sci_mlink_ao_scan_init",..
                    link_id, 1, "i",..
                    channels, 2, "i",..
                    ch_count, 3, "i",..
                    data, 4, "d",..
                    data_size, 5, "i",..
                    ao_range, 6, "d",..
                    continuous, 7, "i", ..
                    scan_freq, 8, "d",..
                    scan_time, 9, "d",..
                "out",..
                    [1, 1], 10, "i");

    if argn(2) == 6 | argn(2) == 1 then
        mdaqClose(link_id);
    end

    if result < 0 then
        error(mdaq_error2(result), 10000 + abs(result)); 
    else
        if result == 1 then
            mprintf("\nWARNING: Your MicroDAQ device does not support running AI and AO scan simultaneously.\n")
        end

        dac_res = strtod(part(dac_info.resolution, 1:2))
        for j=1:ch_count

            if continuous == 1 then
                isContinous = %t
            else
                isContinous = %f
            end

            dataSize = size(data);
            result = tlist(["mdaqao",..
                        "Rate","DurationInSeconds","_ChannelCount","_DACResolution","Range", "Channels", "isContinuous", "BufferSize", "Name"],..
                        scan_freq,  scan_time,  ch_count,  dac_res,  matrix(ao_range, 2, ch_count)', channels, isContinous, dataSize, channelNames);

        end
    end

endfunction

