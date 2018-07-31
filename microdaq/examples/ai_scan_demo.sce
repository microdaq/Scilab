aiData = [];
dataCount = 0;
mdaqAIScanInit(1:8, [-10,10], %F, 10000, 1)
for i=1:10
    [data result] = mdaqAIScan(1000, 1);
    aiData = [aiData; data];
    dataCount = dataCount + result;
    mprintf('Acquired %d scans (total: %d scans)\n', result, dataCount);
end
mdaqAIScanStop();
plot(aiData);
