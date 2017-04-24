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
 
function test()
    params = list();
    params($+1) = struct("channels", [1:8], "range", 2, "differential", %F, "frequency", 10000, "time", 1, "data_count", 1, "blocking", %T)
    //params($+1) = struct("channels", [1:8], "range", 1, "differential", %F, "frequency", 1000, "time", 1, "data_count", 100, "blocking", %T)   
    //params($+1) = struct("channels", [1:8], "range", 2, "differential", %F, "frequency", 1000, "time", 1, "data_count", 100, "blocking", %T)   
    //params($+1) = struct("channels", [1:8], "range", 3, "differential", %F, "frequency", 1000, "time", 1, "data_count", 100, "blocking", %T)   
    //params($+1) = struct("channels", [1:8], "range", 4, "differential", %F, "frequency", 1000, "time", 1, "data_count", 100, "blocking", %T)   
    //params($+1) = struct("channels", [1:8], "range", 2, "differential", %F, "frequency", 1000, "time", 0, "data_count", 200, "blocking", %T)
    //params($+1) = struct("channels", [1:4], "range", 2, "differential", %F, "frequency", 1000, "time", 9999, "data_count", 200, "blocking", %T)
    //params($+1) = struct("channels", [1:3], "range", 2, "differential", %F, "frequency", 1000, "time", 1, "data_count", 200, "blocking", %F)
    
    for i=1:size(params)
        input("Press any key to run test.");
       
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
        
        mprintf("\nAcquiring data...\n")
        tic()
        
        if params(i).blocking then
            if params(i).time < 0 then 
                ntimes = 10000000000;
            else
                ntimes = ((params(i).time*params(i).frequency)/params(i).data_count)
                disp(ntimes)
            end
            
            for j=1:ntimes
                mprintf('reading %d/%d...\n', j, ntimes)
                [newdata res] = mdaq_ai_scan(params(i).data_count, params(i).blocking); 
                //disp(newdata);
                data = [data; newdata];
                
                //if params(i).time < 0 then 
//                    if j == 5 then 
//                        mdaq_ai_scan_stop();
//                        mprintf("Called mdaq_ai_scan_stop()\n")
//                        break;
//                    end
                //end

            end
            disp(data)
            disp(size(data))
        else
            res = 0
            try
                while res > -1 then  
                    [newdata res] = mdaq_ai_scan(params(i).data_count, params(i).blocking); 
                    disp(res)
                    if( res > 0 ) then 
                        mprintf('reading data %d...\n', res)
                        data = [data; newdata]; 
                    end 
                end
            catch
                disp(data)
                disp(size(data))
            end 
        end
  
        mprintf('AI scan time execution: %f sec\n', toc());        
    end
endfunction

test();
clear test;



 

