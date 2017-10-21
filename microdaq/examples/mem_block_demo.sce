data = 1:10;
time = 0:0.1:1000;

data_size = size(time, '*');

sin_data = sin(time);
i = 1; 
amp=0;
finish = %F; 

disp("---- mem_block_demo model parameter access ----");
disp("Press F1 or F2 to increase/decrease sine waveform noise");
disp("Hold F1 and F2 in order to terminate script")

// connect to MicroDAQ
con = mdaqOpen();

while(i < data_size & finish == %F )
    // read F1 and F2 key state
    f1 = mdaqKeyRead(con, 1);
    f2 = mdaqKeyRead(con, 2);

    // when F1 pressed increase noise amplitude
    if f1 then
        amp = amp + 0.01;
    end
    
    // when F2 pressed decrease noise amplitude
    if f2 then
        amp = amp - 0.01;
    end
    
    // check loop exit condition
    if f1 then
        if f2 then
            finish = %T
        end
    end
    
    noise = amp * (rand() - 0.5);

    // set parameters 
    mdaqMemWrite(con, 1, data * sin_data(i));
    mdaqMemWrite(con, 11, data * (sin_data(i) + noise));
    i = i + 1;
    sleep(5)
end
disp("Ending script...");
// close connection with MicroDAQ
mdaqClose(con)
