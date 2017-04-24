mdaq_set_ip("10.10.1.2");
channels = [1:3]
ch_range = 3;
scan_freq = 10000;
trigger = 0;
duration = 10;
blocking = 1;

//Single mode test
continuous = 1
high = ones(1000, 4)*3.3;
low = zeros(1000, 3);

mdaq_ao_scan_stop();
mdaq_ao_scan_init(channels, ch_range, continuous, trigger, scan_freq, duration);
    mdaq_ao_data_queue(high, blocking);
mdaq_ao_scan();
for i=1:10
    mdaq_ao_data_queue(low, blocking);
    mdaq_ao_data_queue(high, blocking);
end
    
sleep(500);
mdaq_ao_scan_stop();
