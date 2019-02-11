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
                    disp("Unable to get MicroDAQ IP address - run microdaq_setup!");
                    continueSimulation = %F;
                    %microdaq.dsp_loaded = %F;
                    break;
                end

                result = client_connect(mdaq_ip_addr, 4344);
                if result < 0 then
                    con = mdaqOpen(); 
                    result = mlink_set_obj(con, "ext_mode", 1);
                    mdaqClose(con);
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
            disp("### Running model in simulation mode... ")
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
