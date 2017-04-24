// TESTED ON:
//mdaq_ai_scan_init(link_id, channels, range, differential, frequency, time);
//	link_id - connection id returned by mdaq_open() (OPTIONAL)
//	channels - analog input channels to read
//	range - analog input range:
//	    1: ±10V
//	    2: ±5V
//	    3: 0-10V
//	    4: 0-5V
//	differential - measurement type (%T - differential, %F - single-ended)
//	frequency - scan frequency
//	duration - scan duration in seconds

    params = list();
    
//    //Range 
//    params($+1) = struct("channels", 1:8, "range", 1, "differential", %F, "frequency", 10000, "time", 0.1, "data_count", 100);
//    params($+1) = struct("channels", 1, "range", 2, "differential", %F, "frequency", 10000, "time", 0.1, "data_count", 100);
//    params($+1) = struct("channels", 1:8, "range", 3, "differential", %F, "frequency", 10000, "time", 0.1, "data_count", 100);
//    params($+1) = struct("channels", 1, "range", 4, "differential", %F, "frequency", 10000, "time", 0.1, "data_count", 100);
    
    // Frequency -
      params($+1) = struct("channels", [1:2], "range", 4, "differential", %F, "frequency", 1000, "time", 6, "data_count", 100, "blocking", %T)
//      params($+1) = struct("channels", 1, "range", 2, "differential", %F, "frequency", 10000, "time", 1, "data_count", 1)

//    //Invalid parameters 
//    params($+1) = struct("channels", 1, "range", 2, "differential", %F, "frequency", 0.1, "time", 1, "data_count", 1);
//    params($+1) = struct("channels", 1, "range", 2, "differential", %F, "frequency", 1000000, "time", 1, "data_count", 1000);
       
    for i=1:size(params)
        //input("Press any key to run test.");
       
        mprintf("\n\n ------------- Test set num: %d -------------\n", i);
        mprintf('Test params:\n')
        disp(params(i))
        data = []
        
        mprintf("\nmdaq_ai_scan_init:")
        try
            mdaq_ai_scan_init(params(i).channels, params(i).range, params(i).differential, params(i).frequency, params(i).time);
        catch
            disp('mdaq_ai_scan_init: params error')
        end 
        
        mdaq_dio_func(1, %F);
        mdaq_dio_dir(1, 1);
        mdaq_dio_write(1, 1);
       
        mprintf("\nAcquiring data...\n")
        tic()
        
        
        if params(i).blocking then
            ntimes = ((params(i).time*params(i).frequency)/params(i).data_count)
            for j=1:ntimes
                mprintf('reading %d/%d...\n', j, ntimes)
                [newdata res] = mdaq_ai_scan(params(i).data_count, params(i).blocking); 
                data = [data; newdata];
            end
            //disp(data)
        else
            res = 0
            try
                while res > -1 then  
                    [newdata res] = mdaq_ai_scan(params(i).data_count, params(i).blocking); 
                    disp(newdata)
                    disp(res)
                    if( res > 0 ) then 
                        mprintf('reading data %d...\n', res)
        olordef('white');
                data = [data; newdata]; 
                    end 
                end
            catch
                //disp(data)
            end 
        end
  
        mprintf('AI scan time execution: %f sec\n', toc());
   
//        // short display
//        dlen = length(data);
//        if dlen > 5 then
//            disp(data(1:5))
//            mprintf('\t...5 of %d samples', dlen)
//        else
//            disp(data(1:dlen))
//        end
    end


mdaq_dio_write(1, 0);
time_base = linspace(0, 6, 6000)';

plot(time_base, data(:,1));
xtitle("Analog input, channel 1", "Time [sec]", "Voltage [V]");
figure();

plot(time_base, data(:,2)); 
xtitle("Analog input, channel 2", "Time [sec]", "Voltage [V]");

 
