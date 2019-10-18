function load_last_dsp_image()
    global %microdaq;
    
    // TODO add verification if binary name is same as model 
    
    if isfile(TMPDIR + filesep() + "last_model") == %t then
        
        // read dspPath, dspTsamp, dspDuration from file 
        load(TMPDIR + filesep() + "last_model");
        [path, fname, extension] = fileparts(dspPath);
        try 
            mdaqDSPInit(dspPath, -1, dspDuration);
            disp("### Loading DSP executable " + fname + extension + " on MicroDAQ...")
        catch
            %microdaq.dsp_loaded = %T            
            messagebox(lasterror(), "Error", "error")
        end
        
        %microdaq.dsp_loaded = %T

        if mdaqIsExtMode() == %F then
            mdaqDSPStart();
            if dspDuration > 0 then 
                durationStr = string(dspDuration) 
            else
                durationStr = "Inf"
            end
            msg = "(duration: " + durationStr + "s, rate: " + string(1/strtod(dspTsamp)) + "Hz)..." 
            disp("### Starting "+ fname + " in Ext mode " + msg);    
        end
    else
        messagebox("Can''t find DSP application. Build model first", "Error", "error")
    end
endfunction
