function continueSimulation=pre_xcos_simulate(scs_m, needcompile)
    global %microdaq;
    %microdaq.private.has_mdaq_block = %F;
    continueSimulation = %T;
    look_for_mdaq_blocks = %T; 
    runFromMainScheme = %F;

    for i = 1:size(scs_m.objs)
        curObj= scs_m.objs(i);
        if (typeof(curObj) == "Block" & curObj.gui == "mdaq_setup")
            runFromMainScheme = %T;

            if scs_m.objs(i).model.rpar(1) == (-1) then
                scs_m.props.tf= 1.000D+12;
            else
                scs_m.props.tf=scs_m.objs(i).model.rpar(1);
            end

            // if model has microdaq block set real-time scaling to 1
            tmp = scs_m;
            
            perform_scan(tmp);
            if %microdaq.private.has_mdaq_block then
                scs_m.props.tol(5) = 1;
            end

            if %microdaq.dsp_loaded == %T then
                look_for_mdaq_blocks = %F; 
                // if dsp is loaded set real-time scaling to 1
                scs_m.props.tol(5) = 1;

                [mdaq_ip_addr, result] = mdaq_get_ip();
                if result < 0 then
                    disp("Unable to get MicroDAQ IP address - run microdaq_setup!");
                    continueSimulation = %F;
                    %microdaq.dsp_loaded = %F;
                    break;
                end

                result = client_connect(mdaq_ip_addr, 4344);
                if result < 0 then
                    con = mdaq_open(); 
                    result = mlink_set_obj(con, "ext_mode", 1);
                    mdaq_close(con);
                    if result == -25 then
                        message("ERROR: Unable to connect - your are running model in Standalone mode!");
                    else
                        message("ERROR: Unable to connect to MicroDAQ device!")
                        %microdaq.dsp_loaded = %F;
                    end
                    continueSimulation = %F;
                    break;
                end
                disp('### Starting model in Ext mode...');
                   
                perform_scan(tmp);
                if %microdaq.private.has_mdaq_param_sim then
                    result = mdaq_open();
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
    
    if runFromMainScheme == %F then
        messagebox("Please start model from root diagram (the one which contains mdaq_setup block).");
        continueSimulation = %F;
        return;
    end

    if look_for_mdaq_blocks then
        tmp = scs_m;
        perform_scan(tmp);
        if %microdaq.private.has_mdaq_block then
            disp("### Running model in simulation mode... ")
            close_last_connection();       
            result = mdaq_open();
            if result > -1 then
                %microdaq.private.connection_id = result; 
            else
                message("ERROR: Unable to connect to MicroDAQ device!");
                continueSimulation = %F;
                %microdaq.private.connection_id = -1; 
            end
        end
       
        %microdaq.private.mdaq_signal_id = 0;      
    end

    scs_m=resume(scs_m)
endfunction
