function continueSimulation=pre_xcos_simulate(scs_m, needcompile)
    global %microdaq;
    
    %microdaq.private.has_mdaqBlock = %F;
    continueSimulation = %T;
    look_for_mdaqBlocks = %T; 

    for i = 1:size(scs_m.objs)
        curObj= scs_m.objs(i);

        if (typeof(curObj) == "Block" & curObj.gui == "CLKINV_f")
            messagebox("Starting simulation inside of a superblock is not possible", "Simulation problem", "error");
            continueSimulation = %F;
            return;
        end

        if (typeof(curObj) == "Block" & curObj.gui == "CLOCK_c")
            sTsamp=curObj.model.rpar.objs(2).graphics.exprs(1);
            %microdaq.private.model_tsamp=strtod(sci2exp(evstr(sTsamp)));
        end

        if (typeof(curObj) == "Block" & curObj.gui == "mdaq_setup")
            if scs_m.objs(i).model.rpar(1) == (-1) then
                scs_m.props.tf= 1.000D+12;
            else
                scs_m.props.tf=scs_m.objs(i).model.rpar(1);
            end

            // if model has microdaq block set real-time scaling to 1
            tmp = scs_m;
            perform_scan(tmp);

            if %microdaq.private.has_mdaqBlock then
                scs_m.props.tol(5) = 1;
            end

            if %microdaq.dsp_loaded == %T then
                look_for_mdaqBlocks = %F; 
                if %microdaq.private.mdaq_signal_id == [] then
                    scs_m.props.tol(5) = 1;
                else
                    scs_m.props.tol(5) = 0;
                end
                
                [mdaq_ip_addr, result] = mdaq_get_ip();
                if result < 0 then
                    messagebox("Can''t get MicroDAQ IP address - run microdaq_setup to configure toolbox!", "Configuration error", "error");
                    continueSimulation = %F;
                    %microdaq.dsp_loaded = %F;
                    break;
                end

                if mdaqIsExtMode() == %F then
                    res = messagebox("DSP runs in standalone mode. Do you want to stop DSP execution ?", "Error", "error", ["Yes" "No"], "modal");
                    
                    if res == 1 then
                        mdaqDSPStop()
                        %microdaq.dsp_loaded = %F;
                    end
                    continueSimulation = %F;
                    break;
                else
                    mdaqDSPStart();
                    load(TMPDIR + filesep() + "last_model");
                    [path, fname, extension] = fileparts(dspPath);
                    if dspDuration > 0 then 
                        durationStr = string(dspDuration) 
                    else
                        durationStr = "Inf"
                    end
                    msg = "(duration: " + durationStr + "s, rate: " + string(1/strtod(dspTsamp)) + "Hz)..." 
                    disp("### Starting "+ fname + " in Ext mode " + msg);    
                    continueSimulation = %T;
                end
                   
                perform_scan(tmp);
                if %microdaq.private.has_mdaq_param_sim then
                    result = mdaqOpen();
                    if result > -1 then
                        %microdaq.private.connection_id = result; 
                    else
                        message("ERROR: Unable to connect to MicroDAQ device!");
                        continueSimulation = %F;
                        %microdaq.private.connection_id = -1; 
                    end
                end
            end        
        end
    end

    if look_for_mdaqBlocks then
        tmp = scs_m;
        perform_scan(tmp);
        if %microdaq.private.has_mdaqBlock then
            close_last_connection();       
            result = mdaqOpen();
            if result > -1 then
                %microdaq.private.connection_id = result; 
            else
                message("ERROR: Unable to connect to MicroDAQ device!");
                continueSimulation = %F;
                %microdaq.private.connection_id = -1; 
            end
        end
        %microdaq.private.mdaq_signal_id = [];      
    end
    scs_m=resume(scs_m)
endfunction
