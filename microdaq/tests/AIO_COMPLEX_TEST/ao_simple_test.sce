function test()
    disp("------------ SIMPLE ANALOG INPUT/OUTPUT TEST -------------");
    data = [1:8];
    disp("SET DATA:")
    disp([data]);
    
    mdaqAOWrite(1:8, [-10 10], data);
    
    disp("READ DATA:")
    disp(mdaqAIRead(1:8, [-10.24 10.24], %F));
endfunction

test();
clear test;

