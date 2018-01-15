clc;
disp("Start signal-test:")

// --- ERRORS ----
disp("check errors handling...")
try
    mdaqDSPStop(); 
catch
    //if dsp wasn't loaded, then 'Unable to access DSP variable' error will occur 
end

assert_checkerror("mdaqDSPSignalRead(1, 1, 10, 1500)", "Request timeout");
assert_checkerror("mdaqDSPStart(''notExistingFirmware.out'', 0.1)"  , "Firmware file not found")
assert_checkerror("mdaqDSPStart(''dsp_test_apps\signalmodel_ext.out'', 4300)"  , "Period for DSP application is to long  (max 70 minutes)")
assert_checkerror("mdaqDSPStart(''dsp_test_apps\signalmodel_ext.out'', 0.0000001)"  , "Period for DSP application is to short (min 1 us)")
mdaqDSPStart('dsp_test_apps\signalmodel_ext.out', 0.1);
assert_checkerror("mdaqDSPSignalRead(1, 9, 10, 1500)", "Wrong signal size or size of data is not multipy of signal size")
assert_checkerror("mdaqDSPSignalRead(5, 1, 10, 1500)", "Wrong signal id (not found in data stream)")
mdaqDSPStart('dsp_test_apps\signalmodel_stand.out', 0.1);
assert_checkerror("mdaqDSPSignalRead(1, 1, 10, 1500)", "Cannot read signal data (model is running in standalone mode)");
mdaqDSPStart('dsp_test_apps\signalmodel_ext.out', 1);
assert_checkerror("mdaqDSPSignalRead(1, 1, 10, 400)", "Request timeout");
mdaqDSPStop();
disp("pass.")

// --- STRESS TEST ---
disp("stress test (load DSP app multiple times)...")
for i=1:10
    mdaqDSPStart('signalmodel_scig\signalmodel.out', 0.0001);   
    mdaqDSPStop()
end
disp("pass.")

// -- USE-CASE01 
disp("use-case01 read 3 signals (same sizes)...")
mdaqDSPStart('dsp_test_apps\use-case.out', 0.1);
vec_size = 10
for i=1:3
    [data] = mdaqDSPSignalRead(i, 1, vec_size, 1500);
    plot(data);
end

mdaqDSPStop();
disp("make sure if pass.")

// -- USE-CASE02
figure();
disp("use-case02 read 4 signals (different sizes) + MEM BLOCK...")
vec_size = 100;
mdaqDSPStart('dsp_test_apps\use-case.out', 0.05);
mdaqMemWrite(1, [9 10 11 12]);
[data1] = mdaqDSPSignalRead(1, 1, vec_size, 1500);
[data2] = mdaqDSPSignalRead(2, 1, vec_size, 1500);
[data3] = mdaqDSPSignalRead(3, 1, vec_size, 1500);
[data4] = mdaqDSPSignalRead(4, 4, vec_size, 1500);
plot(data1); plot(data2); plot(data3); 
plot(data4(:, 1)); plot(data4(:, 2)); plot(data4(:, 3));
mdaqDSPStop();
disp("make sure if pass.")

// -- USE-CASE03
figure();
disp("use-case03 one signal read...")
vec_size = 100;
mdaqDSPStart('dsp_test_apps\use-case.out', 0.001);
data3 = []
mdaqMemWrite(1, [9 10 11 12]);
for i=1:10
    [data3] = [data3; mdaqDSPSignalRead(3, 1, vec_size, 1500)];
end
plot(data3);

mdaqDSPStop();
disp("make sure if pass.")

// -- USE-CASE04
disp("use-case04 random read...")
vec_size = 5;
mdaqDSPStart('dsp_test_apps\use-case.out', 0.1);
data1 = []
data2 = []
data3 = []
[data1] = [data1; mdaqDSPSignalRead(1, 1, vec_size, 1500)];
[data1] = [data1; mdaqDSPSignalRead(1, 1, vec_size, 1500)];
[data2] = [data2; mdaqDSPSignalRead(2, 1, vec_size, 1500)];
[data3] = [data3; mdaqDSPSignalRead(3, 1, vec_size, 1500)];

[data1] = [data1; mdaqDSPSignalRead(1, 1, vec_size, 1500)];
[data2] = [data2; mdaqDSPSignalRead(2, 1, vec_size*2, 1500)];
[data3] = [data3; mdaqDSPSignalRead(3, 1, vec_size, 1500)];
disp(data1);disp(data2);disp(data3);
mdaqDSPStop();
disp("make sure if pass.")



