scan_freq = 800000; 
duration = 10;
sin_waveform_point_count = 15
sin_amp = 5; 
bias = 0; 

ao_data = sin(linspace(0,2*%pi,sin_waveform_point_count + 1)') * sin_amp; 
ao_data = ao_data + bias; 

mdaq_ao_scan_init()
mdaq_ao_scan_init(1:8, 3, scan_freq, duration)

for ch=1:8
    mdaq_ao_scan_data(ch, ch*100, ao_data(1:sin_waveform_point_count));
end

mdaq_ao_scan()

