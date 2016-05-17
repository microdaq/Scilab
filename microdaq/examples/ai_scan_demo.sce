// Acquire data from AI channels: 1,2,3,4 with 10kHz frequency
// Duration: 10sec

ai_scan_data = [];
mdaq_ai_scan_init([1 2 3 4], 10, %T, %F, 10000, 10);

for i=1:100
    ai_scan_data = [ ai_scan_data; mdaq_ai_scan(1000, 1) ];
    disp(i)
end

plot(ai_scan_data);
