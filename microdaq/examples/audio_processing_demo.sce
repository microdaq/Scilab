// Data acqisition parameters
Rate = 44100;
Channel = 1; 
aiRange = 2; // analog input range: ±5V
aoRange = 3; // analog output range: ±2.5V
aoTrigger = 0; 
IsContinuous = %T;
IsDifferential = %F; 

Gain = 1.5;

// Init analog input/output scanning 
mdaq_ai_scan_init(Channel, aiRange, IsDifferential, Rate, -1);      
mdaq_ao_scan_init(Channel, aoRange, IsContinuous, aoTrigger, Rate, -1);

// Start scanning - analog input and output
audioData = mdaq_ai_scan(Rate / 10, %T);
mdaq_ao_data_queue(audioData, %T);
mdaq_ao_scan();

// Acquire data in the loop
while(mdaq_key_read(1) == %F)
    // Audio stream acqisition
    audioData = mdaq_ai_scan(Rate / 10, %T);
    
    // Signal processing 
    audioData = audioData * Gain; 
    
    // Queue audio stream data 
    mdaq_ao_data_queue(audioData, %T);
end 

// When finished stop analog input/output scanning
mdaq_ao_scan_stop();
mdaq_ai_scan_stop();
