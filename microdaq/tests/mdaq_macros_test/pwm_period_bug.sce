function test()
    params = list();

    //Test period
    params($+1) = struct("module", 1, "period", 1      , "active_low", %T, "duty_a", 50, "duty_b", 0);
    params($+1) = struct("module", 1, "period", 2      , "active_low", %T, "duty_a", 50, "duty_b", 0);
    params($+1) = struct("module", 1, "period", 500000, "active_low", %T, "duty_a", 50, "duty_b", 0);
    params($+1) = struct("module", 1, "period", 1000000, "active_low", %T, "duty_a", 50, "duty_b", 0);
    
    for i=1:size(params)
        input("Press any key to run test.");
        mprintf("PWM TEST PARAMS:\nmodule: %d, period: %d, active_low: %s, duty_a: %d, duty_b: %d\n\n",...
        params(i).module, params(i).period, string(params(i).active_low), params(i).duty_a, params(i).duty_b);

        mdaq_pwm_init(params(i).module, params(i).period, params(i).active_low);
        mdaq_pwm_write(params(i).module, params(i).duty_a, params(i).duty_b);
    end
endfunction

test();
clear test;

