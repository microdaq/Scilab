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
mdaqAIScanInit(Channel, aiRange, IsDifferential, Rate, -1);      
mdaqAOScanInit(Channel, zeros(Rate / 10,1), aoRange, IsContinuous, Rate, -1);

// Start scanning - analog input and output
mdaqAOScan();

// Acquire data in the loop
while(mdaqKeyRead(1) == %F)
    // Audio stream acqisition
    audioData = mdaqAIScan(Rate / 10, %T);
    
    // Signal processing 
    audioData = audioData * Gain; 
    
    // Queue audio stream data 
    mdaqAOScanData(Channel, audioData, %T);
end 

// When finished stop analog input/output scanning
mdaqAOScanStop();
mdaqAIScanStop();
