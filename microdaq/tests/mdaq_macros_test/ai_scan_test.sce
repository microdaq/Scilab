//MicroDAQ E1100-ADC01-DAC01-00
mdaq_set_ip('10.10.1.3'); 

channels = [1 2 3 4 5 6 7 8];

mdaq_ai_scan_init(channels, 10, %T, %T, 1000, 20);
data = []
for i=1:10
    data = [data; mdaq_ai_scan(100, %T)];
end

plot(data);

 
//Description:
//	Init AI scan
//Usage:
//	mdaq_ai_scan_init(link_id, channels, range, bipolar, differential, frequency, time);
//	link_id - connection id returned by mdaq_open() (OPTIONAL)
//	channels - analog input channels to read
//	range - analog input range (5 or 10)
//	bipolar - analog input polarity (%T - bipolar, %F - unipolar)
//	differential - analog input mode (%T - differential, %F - single-ended)
//	frequency - analog input scan frequency
//	time - analog input scan duration in seconds

//Description:
//	Starts and reads scan data
//Usage:
//	mdaq_ai_scan(link_id, scan_count, blocking);
//	link_id - connection id returned by mdaq_open() (OPTIONAL)
//	scan_count - number of scans to read
//	blocking - blocking or non-blocking read (%T/%F)
// ans  =
