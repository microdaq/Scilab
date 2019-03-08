function []=%mdaqai_p(obj)
    if obj.Channels <> [] then
        rows = [];

        for j=1:size(obj.Channels, "c")
            if obj._Mode(j) == 1 then
                measure_type = "Differential"
            elseif (obj._Mode(j) == 0)
                measure_type = "Single-ended"
            end
            adc_range = obj.Range(j, 2) - obj.Range(j, 1); 
            resolution = string((int(adc_range/2^obj._ADCResolution * 1000000)) / 1000);
            rangeStr="";
            if obj.Range(j, 1) < 0 then
                rangeStr = "±" + string(obj.Range(j, 2))+"V";
            else 
                rangeStr = "0-" + string(obj.Range(j, 2))+"V";
            end

            try
                if obj.Name(j) == [] then
                    nameStr = "-"
                else
                    nameStr = string(obj.Name(j));
                end
            catch
                nameStr = "-"
            end
            
            rows = [rows; "AI"+string(obj.Channels(j)), measure_type, rangeStr, resolution+"mV", nameStr]
        end
        
        mprintf("Analog input data acquisition session:\n");
        mprintf("  --------------------------------------------------------------\n")
        str2table(rows, ["Channel", "Terminal config", "Range", "Resolution", "Name"], 4)
        mprintf("  --------------------------------------------------------------\n")

        if obj.Rate < 1000 then
            mprintf("  Rate:\t\t\t%.1f sps per channel\n", obj.Rate);
        else
            mprintf("  Rate:\t\t\t%.1f ksps per channel\n", obj.Rate/1000);
        end
        
        if obj._RealRate < 1000 then
            mprintf("  Actual rate:\t\t%.1f sps per channel\n", obj._RealRate);
        else
            mprintf("  Actual rate:\t\t%.1f ksps per channel\n", obj._RealRate/1000);
        end
        
        if 1 / obj._RealRate > 0.001 then
            mprintf("  Scan period: \t\t%.5f seconds\n", 1 / obj._RealRate);
        end
        
        if 1 /obj._RealRate <= 0.001 then
            mprintf("  Scan period: \t\t%.5f ms\n", 1 / obj._RealRate * 1000);
        end

        if obj.DurationInSeconds < 0 then
            mprintf("  Number of channels:\t%d\n", obj._ChannelCount)
            mprintf("  Number of scans:\tInf\n");
            mprintf("  Duration:\t\tInf\n");
        else
            mprintf("  Channels in use:\t%d\n", obj._ChannelCount)
            mprintf("  Number of scans:\t%d\n", obj.DurationInSeconds* obj.Rate);
            if obj.DurationInSeconds == 1 then
                mprintf("  Duration:\t\t%.2f second\n", obj.DurationInSeconds);
            else
                mprintf("  Duration:\t\t%.2f seconds\n", obj.DurationInSeconds);
            end
        end
        mprintf("  --------------------------------------------------------------\n")
    end
endfunction

