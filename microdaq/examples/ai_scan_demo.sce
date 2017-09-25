// Acquire data from AI channels: 1,2,3,4 with 10kHz frequency
// Duration: 10sec

duration = 5; 
sample_freq = 10000;
buffer_size = 1000; 

aiData = [];
mdaq_ai_scan_init([1:4], 1, %f, sample_freq, duration)

tic()
for i=1:(sample_freq * duration) / buffer_size
    aiData = [aiData; mdaq_ai_scan(buffer_size, %T) ];
end
plot(aiData);
clear aiData;
