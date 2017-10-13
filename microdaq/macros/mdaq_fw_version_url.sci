function [fw_ver,fw_ver_str, res] = mdaq_fw_version_url()
    res = mdaq_system_ping();
    fw_ver = [];
    fw_ver_str =[];
    
    if res then
        [logfile mlinkLog] = getURL(mdaq_get_ip()+"/log/mlink-server.log", TMPDIR);
        fw_ver_str = part(mlinkLog,strindex(mlinkLog, ' ver: ')+5:strindex(mlinkLog, 'build:')-1); 
        fw_ver = strtod(strsplit(fw_ver_str, '.'));
    end
endfunction
