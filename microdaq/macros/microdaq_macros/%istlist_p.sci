function %istlist_p(obj)
    if obj.channels <> [] then
        rows = [];

        for j=1:obj.ch_count
            if obj.aiMode(j) == 1 then
                measure_type = "Differential"
            elseif (obj.aiMode(j) == 0)
                measure_type = "Single-ended"
            end
            adc_range = obj.aiRange(j, 2) - obj.aiRange(j, 1); 
            resolution = string((int(adc_range/2^obj.adc_res * 1000000)) / 1000);
            rangeStr="";
            if obj.aiRange(j, 1) < 0 then
                rangeStr = "±" + string(obj.aiRange(j, 2))+"V";
            else 
                rangeStr = "0-" + string(obj.aiRange(j, 2))+"V";
            end
            rows = [rows; "AI"+string(obj.channels(j)), measure_type, rangeStr, resolution+"mV"]
        end
        
        mprintf("\nAnalog input task settings:\n");
        mprintf("\t--------------------------------------------------\n")
        str2table(rows, ["Channel", "Terminal config", "Range", "Resolution"], 3)
        mprintf("\t--------------------------------------------------\n")
        mprintf("\tTask rate:\t\t%.1f scans per second\n", obj.scan_freq);
        mprintf("\tActual task rate:\t%.1f scans per second\n", obj.real_freq);

        if 1 /obj.real_freq > 0.001 then
            mprintf("\tScan period: \t\t%.5f seconds\n", 1 / obj.real_freq);
        end
        
        if 1 /obj.real_freq <= 0.001 then
            mprintf("\tScan period: \t\t%.5f ms\n", 1 / obj.real_freq * 1000);
        end

        if obj.scan_time < 0
            mprintf("\tNumber of channels:\t%d\n", obj.ch_count)
            mprintf("\tNumber of scans:\tInf\n");
            mprintf("\tDuration:\t\tInf\n");
        else
            mprintf("\tNumber of channels:\t%d\n", obj.ch_count)
            mprintf("\tNumber of scans:\t%d\n", obj.scan_time * obj.scan_freq);
            if obj.scan_time == 1 
                mprintf("\tDuration:\t\t%.2f second\n", obj.scan_time);
            else
                mprintf("\tDuration:\t\t%.2f seconds\n", obj.scan_time);
            end
        end
        mprintf("\t--------------------------------------------------\n")
    end
endfunction

