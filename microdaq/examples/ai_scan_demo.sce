// Acquire data from AI channels: 1,2,3,4 with 10kHz frequency
// Duration: 10sec

 //mdaq_dsp_start("dac_ch1_2_gen_scig\dac_ch1_2_gen.out", -1)

duration = 5; 
sample_freq = 10000;
buffer_size = 1000; 

ai_scan_data = [];
mdaq_ai_scan_init2([1:4], 1, %f, sample_freq, duration)

tic()

for i=1:(sample_freq * duration) / buffer_size
    ai_scan_data = [ai_scan_data;mdaq_ai_scan(buffer_size, %T) ];
end
disp(toc())
plot(ai_scan_data);
