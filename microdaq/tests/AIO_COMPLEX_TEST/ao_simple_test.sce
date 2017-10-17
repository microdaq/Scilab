function test()
    disp("------------ SIMPLE ANALOG INPUT/OUTPUT TEST -------------");
    data = [1:8];
    disp("SET DATA:")
    disp([data]);
    
    mdaq_ao_write(1:8, [-10 10], data);
    
    disp("READ DATA:")
    disp(mdaq_ai_read(1:8, [-10.24 10.24], %F));
endfunction

test();
clear test;

