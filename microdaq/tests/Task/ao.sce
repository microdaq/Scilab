ao_data = 0.1:0.1:5;
ao = mdaqAOTask();
ao.init(1, ao_data', [0 5], %F, 100, 4);
ao.start();
ao.write(1, ao_data'-0.1, %T); disp('- 1');
ao.write(1, ao_data'-0.2, %T); disp('- 2');
ao.write(1, ao_data'-0.3, %T); disp('- 3');
ao.write(1, zeros(50, 1), %T); disp('- 4');
ao.waitUntilDone(-1);
ao.stop(); 
return;

