function [mdaq_ip, result] = mdaq_get_ip()
    mdaq_ip = [];
    ip_config_file_path = mdaq_toolbox_path()..
            + "etc"+filesep()+"mlink"+filesep()+"ip_config.txt";

    [ip_config_file, result] = mopen(ip_config_file_path, 'r');
    if result == 0 then
        tmp = mgetl(ip_config_file);
        mdaq_ip = string(tmp);
        mclose(ip_config_file);
    else
        error("Unable to get MicroDAQ IP address - use mdaq_set_ip()");
    end
endfunction
