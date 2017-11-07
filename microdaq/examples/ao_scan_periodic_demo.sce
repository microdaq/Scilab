sineData = sin(linspace(0, 2*%pi, 1000)) + 1.0;
sawtoothData = linspace(0, 5, 1000);
mdaqAOScanInit(1:2, [sineData' sawtoothData'], [0,5], %F, 1000, 5);
mdaqAOScan();