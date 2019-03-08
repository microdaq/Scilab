function []=%mdaqao_p(obj)
    if obj.Channels <> [] then
        rows = [];
        row = '';
        for j=1:size(obj.Channels, "c")
            dac_range = obj.Range;
            range_res = dac_range(j, 2) - dac_range(j, 1); 
            resolution = string((int(range_res/2^obj._DACResolution * 1000000)) / 1000);
            rangeStr="";
            if dac_range(j, 1) < 0 then
                rangeStr = "±" + string(dac_range(j, 2))+"V";
            else
                rangeStr = "0-" + string(dac_range(j, 2))+"V";
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
        
            
            rows = [rows; "AO"+string(obj.Channels(j)), rangeStr, resolution+"mV", nameStr]
        end

        mprintf("Analog signal generation session:\n");
        mprintf("  --------------------------------------------------------------\n")
        str2table(rows, ["Channel",  "Output range", "Resolution", "Name"], 8)
        mprintf("  --------------------------------------------------------------\n")

        if obj.isContinuous == 1 then
            mprintf("  Mode:\t\t\tStream\n");
        else
            mprintf("  Mode:\t\t\tPeriodic (regeneration)\n");
        end

        if obj.Rate < 1000 then
            mprintf("  Output update rate:\t%d sps per channel\n", obj.Rate);
        else
            mprintf("  Output update rate:\t%.5f ksps per channel\n", obj.Rate/1000);
        end

        if obj.Rate < 1000 then
            mprintf("  Output update period: %.5f seconds\n", 1 / obj.Rate);
        end

        if obj.Rate >= 1000 then
            mprintf("  Output update period: %.5f ms\n", 1 / obj.Rate * 1000);
        end

        if obj.BufferSize(1) <> 0 then
            mprintf("  Buffer size: \t\t%s samples per channel\n", string(obj.BufferSize(1)))
        end

        if obj.DurationInSeconds < 0 then
            mprintf("  Number of used channels:\t%d\n", size(obj.Channels, "c"))
            mprintf("  Number of samples to generate:\tInf\n");
            mprintf("  Duration:\t\tInf\n");
        else
            mprintf("  Channels in use:\t%d\n", size(obj.Channels, "c"))
            mprintf("  Smaples to generate:\t%d\n", obj.DurationInSeconds * obj.Rate);
            if obj.DurationInSeconds == 1 then
                mprintf("  Duration:\t\t%.2f second\n", obj.DurationInSeconds);
            else
                mprintf("  Duration:\t\t%.2f seconds\n", obj.DurationInSeconds);
            end
        end
        mprintf("  --------------------------------------------------------------")
    end
endfunction

