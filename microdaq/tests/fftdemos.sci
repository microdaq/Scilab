// Script execution duration in seconds
TIME = 200;

// build DSP binary from Xcos model 
mdaq_dsp_build(mdaq_toolbox_path() + filesep() + "examples" + filesep() +"fft_demo.zcos");

// Start DSP application
result = mdaq_dsp_start('fft_demo_scig\fft_demo.out', -1); 
if result < 0 then
    abort;
end

// Register signal ID and signal size
result = mdaq_dsp_signal(123, 1); 
if result < 0 then
    disp("ERROR: unable to register signal"); 
    abort;
end

first_time = 1; 
a = [];
// Process data from DSP 
sample_count = 500;
for i=1:(10 * TIME)
    [result, s] = mdaq_dsp_signal_read(sample_count);
    if result < 0 then
        disp("ERROR: unable to read signal data!"); 
        abort;
    end

    t = 0:1/sample_count:1;
    N=size(t,'*'); //number of samples
    y=fft(s');

    f=sample_count*(0:(N/2))/N; //associated frequency vector
    n=size(f,'*');
    if first_time == 1 then
        clf()
        plot(f,abs(y(1:n)))
        first_time = 0;
        a = gca();
    else
        a.children.children.data(:,2) = abs(y(1:n))';
    end
end

// Stop DSP execution
mdaq_dsp_stop();
