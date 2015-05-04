function mdaq_exec_profile_show()
    if isfile(TMPDIR + filesep() + "profiling_data") then
        load(TMPDIR + filesep() + "profiling_data");
        if isdef("dsp_exec_profile")
            f=scf(4444);
            f.figure_name= "MicroDAQ execution profile";
            plot2d2(dsp_exec_profile.step);
            xtitle("MicroDAQ execution profile");

            if f.children.type == "Axes" then
                axes = f.children;
                axes.grid = [1,1];
                axes.grid_style = [9,10];
                axes.x_label.text = "Sample"
                axes.y_label.text = "Time [us]"
                poliline = axes.children.children;
                poliline.foreground = 2; 
                hl=legend(['Model step function execution time']);
            end
            clear dsp_exec_profile;
        end
    else
        message("WARNING: Unable to get profiling data - enable profiling in SETUP block and rebuild model!")
        return;
    end
endfunction
