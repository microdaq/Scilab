function mdaq_upgrade(firmware)
    [fw fwString res] = mdaq_fw_version_url();
    if res == %F then
        mprintf("Unable to connect to MicroDAQ device!\n"); 
        return; 
    elseif fw(1) < 2 then 
        mprintf("\nAutomatic upgrade from current version (%s) is impossible.\n", fwString);
        mprintf("Please make an upgrade manually by doing the following steps:\n");
        mprintf("\t1. Download latest upgrade package from: https://github.com/microdaq\n");
        mprintf("\t2. Connect USB cable and copy package to ''upgrade'' folder on MicroDAQ storage.\n");
        mprintf("\t3. Click ''upgrade'' button on web interface. (http://%s)\n", mdaq_get_ip());
        return;
    end 
            
    if argn(2) == 1 then
        fw_file = firmware;
        if isfile(fw_file) <> %T then
            disp("File not found"); 
            return; 
        end
    else
        fw_ver = mdaq_fw_version();
        mprintf("Checking www.github.com/microdaq for latest MicroDAQ firmware...\n");
        latest_fw_ver = mdaq_latest_fw(); 
        if latest_fw_ver == [] then
            disp("Unable to connect to www.github.com/microdaq"); 
            return;
        end
        
        
        if find((latest_fw_ver > fw_ver) == %T) == [] then
            mprintf("MicroDAQ firmware is already the newest version (%d.%d.%d Build: %d) - no need to upgrade MicroDAQ device.\n",..
                        fw_ver(1),..
                        fw_ver(2),..
                        fw_ver(3),..
                        fw_ver(4));
            return;
        end
        
        mprintf("Are you sure you want to upgrade your MicroDAQ firmware?\n");
        mprintf("\tCurrent firmware: %d.%d.%d Build: %d \n\tLatest firmware: %d.%d.%d Build: %d (will be used for upgrade)\n",..
                        fw_ver(1),..
                        fw_ver(2),..
                        fw_ver(3),..
                        fw_ver(4),..
                        latest_fw_ver(1),..
                        latest_fw_ver(2),..
                        latest_fw_ver(3),..
                        latest_fw_ver(4));
        answer = input("Please answer (yes or no) : ", "string");
        
        if answer <> "yes" & answer <> "Yes" & answer <> "YES" then
            return;    
        end
        
        fw_name = "mlink_" + string(latest_fw_ver(1)) + "." +..
                             string(latest_fw_ver(2)) + "." +..
                             string(latest_fw_ver(3)) + "_arm.opk";
                             
        mprintf("Downloading firmware from www.github.com/microdaq...\n");
        try
            getURL("raw.githubusercontent.com/microdaq/MLink/upgrade_test/" + fw_name, TMPDIR + filesep() + fw_name);
        catch
            disp("Unable to connect to MicroDAQ firmware server"); 
            return
        end
        fw_firmware = TMPDIR + filesep() + fw_name;
    end

    mprintf("Uploading firmware on MicroDAQ...\n");    
    link_id = mdaqOpen();
    if link_id < 0 then
        disp("Unable to connect to MicroDAQ device!");
        return; 
    end

    result = call("sci_mlink_fw_upload",..
                link_id, 1, "i",..
                fw_firmware, 2, "c",..
            "out",..
                [1,1], 3, "i");
                
    if result < 0 then
        disp("Unable to upload firware file"); 
        return; 
    end
    mdaqClose(link_id);

    mdaq_ip = mdaq_get_ip(); 

    mprintf("Upgrading firmware...");    
    try
        getURL("http://" + mdaq_ip + "/php/upgrade.php", TMPDIR + filesep() + "upgrade_result.txt");
    catch
        disp("Unable to connect to MicroDAQ device!");
        return; 
    end

    upgraded_fw_ver = mdaq_fw_version();    
    if upgraded_fw_ver <> [] then
        if upgraded_fw_ver == fw_ver then
            disp("ERROR"); 
            return;
        end        
    end

    mprintf("DONE (%d.%d.%d Build: %d)\n",..
                        upgraded_fw_ver(1),..
                        upgraded_fw_ver(2),..
                        upgraded_fw_ver(3),..
                        upgraded_fw_ver(4));

endfunction
