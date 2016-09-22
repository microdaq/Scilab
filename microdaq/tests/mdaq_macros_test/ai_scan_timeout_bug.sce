mdaq_ping()
mdaq_set_ip("10.10.1.2");

//10 kHz
dur_t = 2.1; //sec 
freq_hz = 1000; 
mdaq_ai_scan_init(1:8, 10, %T, %F, freq_hz, dur_t);
data = []

tic();
//for i=1:(10*dur_t)
//    data = [data; mdaq_ai_scan(1000, %T)];
//end
data = mdaq_ai_scan(freq_hz*dur_t, %T);
disp("Elapsed test time: "+string(toc())+" sec.");

plot(data);





