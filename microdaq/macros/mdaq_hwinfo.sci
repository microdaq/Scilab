function mdaq_hwinfo()
    hwid = [];
    connection_id = mdaq_open();
    if connection_id > -1 then
        result = -1;
        [hwid, result] = call("sci_mlink_hwid",..
                connection_id, 1, "i",..
            "out",..
                [5, 1], 2, "i",..
                [1, 1], 3, "i");
        mdaq_close(connection_id);
        
        global %microdaq; 
        if isequal(%microdaq.private.mdaq_hwid, hwid) == %F |..
           isfile(mdaq_toolbox_path() + "etc"+filesep()+"mlink"+filesep()+"hwid") ==  %F then
            %microdaq.private.mdaq_hwid = hwid;
            %microdaq.model = 'MicroDAQ E' + string(hwid(1))..
                            + '-ADC0' + string(hwid(2)).. 
                            + '-DAC0' + string(hwid(3))..
                            + '-' + string(hwid(4)) + string(hwid(5));
            mdaq_hwid = hwid; 
            save(mdaq_toolbox_path() + "etc"+filesep()+"mlink"+filesep()+"hwid", 'mdaq_hwid');
        end
        
        if hwid(4) == 0 then
            cpu = 375;
        else 
            cpu = 456; 
        end
        
        if hwid(5) == 0  then
            storage = 4;
        else
            storage = 32;
        end
                    
        ai_config = ["8 channel, 166ksps, 12-bit, ±10V range",..
                      "8 channel, 166ksps, 16-bit, ±10V range",..
                      "8 channel, 600ksps, 12-bit, ±10V range",..
                      "16 channel, 600ksps, 12-bit, ±10V range",..
                      "16 channel, 500ksps, 16-bit, ±10V range"];
                      
        ao_config = ["8 channel, 12-bit, 0-5V range",..
                     "8 channel, 12-bit, ±10V range",..
                     "8 channel, 16-bit, ±10V range"];

        mprintf("-----------------------------------\n");
        mprintf("   %s\n", %microdaq.model);
        mprintf("-----------------------------------\n");
        mprintf("Hardware configuration:\n");
        mprintf("\tCPU: %dMHz\n", cpu);
        mprintf("\tStorage: %dGB\n", storage);
        
        mprintf("\tAnalog inputs: %s\n", ai_config(hwid(2)));
        mprintf("\tAnalog outputs: %s\n", ao_config(hwid(3)));
        
        mprintf("IP settings:\n");
        mprintf("\tIP address: %s\n", %microdaq.ip_address);

        mprintf("Firmware version:\n");
        mdaq_fw = mdaq_fw_version(); 
        if mdaq_fw <> [] then
            mprintf("\t%d.%d.%d (build: %d)\n",.. 
                        mdaq_fw(1),..
                        mdaq_fw(2),..
                        mdaq_fw(3),..
                        mdaq_fw(4)..
                        );
        else
            mprintf("\tUnable to read!\n");
        end
        
    else
        disp("Unable to connect to MicroDAQ device!");
    end
    
endfunction
