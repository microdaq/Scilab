mdaq_ping()
mdaq_ai_scan_init(1:2, 10, %T, %F, 10000, 20);
data = []
for i=1:10
    data = [data; mdaq_ai_scan(1000, %T)];
end
plot(data);
figure();

//Ta konfiguracja juz nie przechodzi...
mdaq_ai_scan_init(1:8, 10, %T, %F, 10000, 20);
data = []
for i=1:10
    data = [data; mdaq_ai_scan(1000, %T)];
end

plot(data);
//powinno widocznych 8 kanalow 


