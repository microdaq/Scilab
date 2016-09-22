//mdaq_ao_scan_stop()
//
//scan_freq = 20000; 
//out_freq = 800;
//duration = 20;
//sin_waveform_point_count = round(scan_freq/out_freq);
//sin_amp = 5; 
//bias = 0; 
//
//ao_data = sin(linspace(0,2*%pi,sin_waveform_point_count + 1)') * sin_amp; 
//ao_data = ao_data + bias; 
//
//mdaq_ao_scan_init()
//mdaq_ao_scan_init(1, 3, 0, scan_freq, duration)
//
//
//for ch=1:4
//    mdaq_ao_scan_data(ch, ch*1000, ao_data(1:sin_waveform_point_count));
//end
//
//mdaq_ao_scan()
//


mdaq_ai_scan_init(1:8, 10, %T, %F, 1000, 20);
data = []
for i=1:10
    data = [data; mdaq_ai_scan(100, %T)];
end

plot(data);
