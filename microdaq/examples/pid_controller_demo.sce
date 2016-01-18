// This demo show how to use MicroDAQ macros to access 
// MicroDAQ peripherals. This example uses PID algorithm 
// to control DC motor. The DC motor is driven by H-bridge 
// which is controlled by PWM and DIO. 
//
// MicroDAQ DIO20, DIO22 are used to control H-bridge 
// enable and direction pins. MicroDAQ PWM is used to 
// control H-bridge voltage. DC motor is equipped with 
// quadrature encoder. MicroDAQ encoder module is used 
// to read DC motor shaft position. 

function dc_motor_controller(data_color,command, Kp, Ki, Kd)
pwm_module = 3; 
pwm_period = 200; // in microseconds
dio_enable = 20; 
dio_direction = 22; 
enc = 2; 
dt = 0.0041;
prev_err = 0; 
int_err = 0; 
command_data = [0];
response_data = [0];
control_data = [0]
time = [];

// connect to MicroDAQ device, con will be used as a first 
// argument for MicroDAQ hardware access macros
con = mdaq_open();
if con > -1 then
    
    // configure MicroDAQ PWM module 3 with period 200us
    // and non-inverted PWM waveform
    mdaq_pwm_init(con, pwm_module, pwm_period, %F); 
    
    // initialize MicroDAQ Encoder 2 module with 0 value
    mdaq_enc_init(con, enc, 0);
    
    // set initial state of DIO20, DIO20 and PWM module to 0 duty
    mdaq_dio_write(con, dio_enable, %T)
    mdaq_dio_write(con, dio_direction, %T);
    mdaq_pwm_write(con, pwm_module, 0, 0);
    
    // PID control loop
    for i=1:1000
        tic();
        
        // get position
        position = mdaq_enc_read(con, enc); 
        
        // calculate PID algorithm
        err = command - position; 
        err_diff = (err - prev_err) / dt;         
        int_err = int_err + (err * dt);
        
        p_term = err * Kp; 
        i_term = int_err * Ki;
        d_term = err_diff  * Kd;
        
        control = p_term + i_term + d_term;
        prev_err = err; 
        
        // depending on control value (negative/positive)
        // set DIO22 to %T (for positive) or %F (negative)
        if control > 0 then
            mdaq_dio_write(con, dio_direction, %T);
            if control > 100 then
                control = 100; 
            end
        else
            mdaq_dio_write(con, dio_direction, %F);
            if control < -100 then
                control = -100; 
            end
        end
        
        // set PWM value (0-100 range)
        mdaq_pwm_write(con, pwm_module, abs(control), abs(control));
        
        // store experiment data
        control_data = [control_data, control];
        response_data = [response_data, position];
        command_data = [command_data, command];
        
        // gather loop time for loop time statistics
        time = [time, toc()];
    end
    
    // calculate time base 
    loop_time = mean(time);
    t = 0:loop_time:loop_time*1000;

    mprintf("PID gains:\n\tKp: %f\n\tKi: %f\n\tKd: %f\n", Kp, Ki, Kd);
    mprintf("Loop time (dt) statistics: \n\tMean: %f\n\tMax: %f\n\tMin: %f\n", loop_time, max(time), min(time));

    // set PWM to 0 and close connection with MicroDAQ
    mdaq_pwm_write(con, pwm_module, 0,0)
    mdaq_close(con);
    
    data_color = data_color + 1;
    plot2d(t, response_data,data_color);    
    plot2d(t, control_data,data_color);    
    plot2d(t, command_data,1);
end
endfunction

// PID gains
Kp = 0.065;
Ki = 0.04;
Kd = 0.005;

// call dc_motor_controller with different Ki PID gain
dc_motor_controller(1, 3000, Kp, Ki-0.04, Kd)
dc_motor_controller(2, 3000, Kp, Ki-0.02, Kd)
dc_motor_controller(3, 3000, Kp, Ki,      Kd)
dc_motor_controller(4, 3000, Kp, Ki+0.02, Kd)
dc_motor_controller(5, 3000, Kp, Ki+0.04, Kd)




