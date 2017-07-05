function fw_ver = mdaq_latest_fw()
    try 
        getURL("raw.githubusercontent.com/microdaq/Firmware/test/LATEST", TMPDIR + filesep() + "LATEST");
    catch
        fw_ver = [];
        return
    end
    fw_ver = csvRead( TMPDIR + filesep() + "LATEST", " ");
endfunction
