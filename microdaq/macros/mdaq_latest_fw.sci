function fw_ver = mdaq_latest_fw()
    try 
        getURL("raw.githubusercontent.com/microdaq/MLink/upgrade_test/LATEST", TMPDIR + filesep() + "LATEST");
    catch
        fw_ver = [];
        return
    end
    fw_ver = csvRead( TMPDIR + filesep() + "LATEST", " ");
endfunction
