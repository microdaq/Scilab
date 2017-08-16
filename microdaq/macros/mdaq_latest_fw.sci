function fw_ver = mdaq_latest_fw()
    fw_ver = [];
    try 
       [a fw_ver] = getURL("raw.githubusercontent.com/microdaq/Firmware/test/LATEST", TMPDIR + filesep() + "LATEST");
       fw_ver = strtod( strsplit(fw_ver, ',') );
    catch
      warning("Unable to connect to MicroDAQ firmware server.")
    end
   
endfunction
