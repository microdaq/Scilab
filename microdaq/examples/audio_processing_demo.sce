// Data acqisition parameters
Rate = 44100;
Channel = 1; 
aiRange = [-1, 1];    // analog input range: ±1V
aoRange = [-2.5, 2.5]; // analog output range: ±2.5V
isContinuous = %T;
isDifferential = %F; 
initialAOData = zeros(Rate / 10, 1);

Gain = 1.5;

// Init analog input/output scanning 
mdaqAIScanInit(Channel, aiRange, isDifferential, Rate, -1);      
mdaqAOScanInit(Channel, initialAOData, aoRange, isContinuous, Rate, -1);

// Start scanning - analog input and output
mdaqAOScanStart();
mdaqAIScanStart();

// Acquire data in the loop
while(mdaqKeyRead(1) == %F)
    // Audio stream acqisition
    audioData = mdaqAIScanRead(Rate / 10, 1);
    
    // Signal processing 
    audioData = audioData * Gain; 
    
    // Queue audio stream data 
    mdaqAOScanData(Channel, audioData, %T);
end 

// When finished stop analog input/output scanning
mdaqAOScanStop();
mdaqAIScanStop();
