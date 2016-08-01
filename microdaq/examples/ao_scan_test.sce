sin_waveform_point_count = 26
scan_freq = 8000 * sin_waveform_point_count; 
ch_count = 4;

duration = 10;
sin_amp = 5;
bias = 0; 

ao_data = sin(linspace(0,2*%pi,sin_waveform_point_count + 1)') * sin_amp; 
ao_data = ao_data + bias; 

mdaq_ao_scan_init(1:ch_count, 3, 0, scan_freq, duration)

for ch=1:ch_count
    mdaq_ao_scan_data(ch, ch*100, ao_data(1:sin_waveform_point_count));
end

mdaq_ao_scan()
