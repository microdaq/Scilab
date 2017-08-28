// Copyright (c) 2015, Embedded Solutions
// All rights reserved.

// This file is released under the 3-clause BSD license. See COPYING-BSD.

function MLink()
    
    global %microdaq;
    etc_tlbx  = mdaq_toolbox_path();
    etc_tlbx  = etc_tlbx + filesep()+'etc'+filesep()+'mlink'+..
                    filesep()+'MLink'+filesep();
    MLink_path = etc_tlbx + 'MLink';

    [version, opts] = getversion();
    if opts(2) == "x64" then
        MLink_path = strcat([MLink_path, "64"]);
    else
        MLink_path = strcat([MLink_path, "32"])
    end

    [OS,version] = getos()
    if (getos() == "Windows") then
       MLink_path = strcat([MLink_path, ".dll"])
    end
    if (getos() == "Linux") then
       MLink_path = strcat([MLink_path, ".so"])
    end

    // NOT SUPPORTED
    if (getos() == "SunOS") then
       disp("Solaris is not supported!");
    end
    if (getos() == "Darwin") then
       MLink_path = strcat([MLink_path, ".dylib"])
    end

    // Link library
    %microdaq.private.mlink_link_id = link(MLink_path, ["sci_mlink_error"..
                               "sci_mlink_connect"..
                               "sci_mlink_disconnect"..
                               "sci_mlink_disconnect_all"..
                               "sci_mlink_dsp_load"..
                               "sci_mlink_dsp_start"..
                               "sci_mlink_dsp_upload"..
                               "sci_mlink_dsp_stop"..
                               "sci_mlink_dsp_profile_get"..
                               "sci_mlink_dsp_param"..
                               "sci_mlink_set_obj"..
                               "sci_client_connect"..
                               "sci_signal_get"..
                               "sci_signals_get"..
                               "sci_signals_get_config"..
                               "sci_signal_register"..
                               "sci_client_disconnect"..
                               "sci_mlink_mem_set2"..
                               "sci_mlink_mem_get2"..
                               "sci_mlink_ai_read"..
                               "sci_mlink_ao_write"..
                               "sci_mlink_ai_scan_init"..
                               "sci_mlink_ai_scan_get_ch_count"..
                               "sci_mlink_ai_scan"..
                               "sci_mlink_ai_scan_stop"..
                               "sci_mlink_dio_set"..
                               "sci_mlink_dio_get"..
                               "sci_mlink_dio_set_dir"..
                               "sci_mlink_dio_set_func"..
                               "sci_mlink_led_set"..
                               "sci_mlink_func_key_get"..
                               "sci_mlink_enc_reset"..
                               "sci_mlink_enc_get"..
                               "sci_mlink_pwm_config"..
                               "sci_mlink_pwm_set"..
                               "sci_mlink_pru_reg_get"..
                               "sci_mlink_pru_reg_set"..
                               "sci_mlink_hwid"..
                               "sci_mlink_version"..
                               "sci_mlink_fw_upload"..
                               "sci_mlink_udp_open"..
                               "sci_mlink_udp_recv"..
                               "sci_mlink_udp_close"..
                               "sci_mlink_ao_scan_init"..
                               "sci_mlink_ao_scan"..
                               "sci_mlink_ao_scan_stop"..
                               "sci_mlink_ao_scan_data"..
                               "sci_fpga_reg_read"..
                               "sci_fpga_reg_write"..
                               "sci_fpga_data_write"..
                               "sci_fpga_data_read"..
                               ], 'c');
endfunction

MLink();
clear MLink

