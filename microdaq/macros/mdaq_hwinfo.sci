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

        if ((hwid(1) == 1000) |  (hwid(1) == 2000) | (hwid(1) == 1100))..
            & find(get_adc_list() == hwid(2)).. 
            & find(get_dac_list() == hwid(3)) then
            
            global %microdaq;
                %microdaq.private.mdaq_hwid = hwid;
                %microdaq.model = 'MicroDAQ E' + string(hwid(1))..
                + '-ADC0' + string(hwid(2))..
                + '-DAC0' + string(hwid(3))..
                + '-' + string(hwid(4)) + string(hwid(5));
                mdaq_hwid = hwid;
                
                adc_info = get_adc_info(hwid);
                dac_info = get_dac_info(hwid);
                save(mdaq_toolbox_path() + "etc"+filesep()+"mlink"+filesep()+"hwid", 'mdaq_hwid','adc_info','dac_info');
                
                %microdaq.private.adc_info = adc_info;
                %microdaq.private.dac_info = dac_info;

            if hwid(4) == 0 then
                cpu = 375;
            else
                cpu = 456;
            end

            if hwid(5) == 0  then
                storage = 4;
            end

            if hwid(5) == 1  then
                storage = 16;
            end

            if hwid(5) == 2  then
                storage = 32;
            end

            mprintf("-----------------------------------\n");
            mprintf("   %s\n", %microdaq.model);
            mprintf("-----------------------------------\n");
            mprintf("Hardware configuration:\n");
            mprintf("\tCPU: %dMHz\n", cpu);
            mprintf("\tStorage: %dGB\n", storage);

            adc_info = get_adc_info(hwid);
            mprintf("\tAnalog inputs (AI): %s channel, %s, %s, %s range\n", adc_info.channel, adc_info.rate, adc_info.resolution, adc_info.range_desc);
            dac_info = get_dac_info(hwid);
            mprintf("\tAnalog outputs (AO):  %s channel, %s, %s range\n", dac_info.channel, dac_info.resolution, dac_info.range_desc);
 
            
            mprintf("\tDigital input/output (DIO): %d channels, 5V/TTL\n", mdaq_get_dio_config());

            mprintf("IP settings:\n");
            mprintf("\tIP address: %s\n", %microdaq.ip_address);

            mprintf("Firmware version:\n");
            mdaq_fw = mdaq_fw_version();
            if mdaq_fw <> [] then
                mprintf("\t%d.%d.%d (build: %d)\n",..
                        mdaq_fw(1),..
                        mdaq_fw(2),..
                        mdaq_fw(3),..
                        mdaq_fw(4));
            else
                mprintf("\tUnable to read firmware version!\n");
            end
            
            mprintf("Latest firmware version:\n");
            try 
                getURL("raw.githubusercontent.com/microdaq/MLink/master/LATEST", TMPDIR + filesep() + "LATEST");
            catch
                mprintf("\tUnable to connect to MicroDAQ firmware server\n")
                return
            end
            
            latest_mdaq_fw = mdaq_latest_fw();
            if latest_mdaq_fw <> [] then
                mprintf("\t%d.%d.%d (build: %d)\n",..
                            latest_mdaq_fw(1),..
                            latest_mdaq_fw(2),..
                            latest_mdaq_fw(3),..
                            latest_mdaq_fw(4));
    
                if latest_mdaq_fw(1) > mdaq_fw(1) | latest_mdaq_fw(2) > mdaq_fw(2) then
                    mprintf("\tMicroDAQ firmware upgrade is required\n"); 
                    return;
                end
    
                if latest_mdaq_fw(2) >= mdaq_fw(2) & latest_mdaq_fw(3) > mdaq_fw(3) then
                    mprintf("\tMicroDAQ firmware upgrade is recomended\n"); 
                    return;
                end
            end
        else
            disp("Unable to read hardware ID - upgrade MicroDAQ firmware!")
        end
    else
        disp("Unable to connect to MicroDAQ device!");
    end
endfunction
