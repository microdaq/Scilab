mdaq_set_ip("10.10.1.2");
channels = [1:2]
ch_range = 3;
scan_freq = 1000;
trigger = 0;
duration = 1;

//Single mode test
continuous = 0

mdaq_ao_scan_init(channels, ch_range, continuous, trigger, scan_freq, duration);
    mdaq_ao_data_update(1, [0.0 0.0 3.3 3.3]);
    mdaq_ao_data_update(1, [0.0 3.3 0.0 3.3]);
mdaq_ao_scan();
sleep(500);
    mdaq_ao_data_update(2, [0.0 0.0 3.3 3.3]);
    mdaq_ao_data_update(1, [0.0 3.3 0.0 3.3]);
sleep(500);
mdaq_ao_scan_stop();
