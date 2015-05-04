function obj=scan_mdaq_blocks(scs_m)
    global %microdaq;
    obj = [];
    
    mdaq_sim_blocks = ["mdaq_adc_sim","mdaq_dac_sim","mdaq_dio_config_sim",..
    "mdaq_dio_get_sim","mdaq_dio_set_sim","mdaq_encoder_sim",..
    "mdaq_func_key_sim","mdaq_led_sim","mdaq_pru_reg_get_sim",..
    "mdaq_pru_reg_set_sim","mdaq_pwm_sim"];


    for i=1:(size(scs_m.objs)-1)
        if typeof(scs_m.objs(i))=="Block" then
            if scs_m.objs(i).model.sim=="super"|scs_m.objs(i).model.sim=="csuper" then

                // if we have superblock make a recurrence call
                scs_m.objs(i).model.rpar = scan_mdaq_blocks(scs_m.objs(i).model.rpar);
            else

                // check if we have MicroDAQ block if so change type from 5 to 4
                if(grep(scs_m.objs(i).model.sim(1), 'mdaq_') == 1) then
                    if(grep(scs_m.objs(i).model.sim(1), '_sim') == 1) then
                        if scs_m.objs(i).model.sim(2) == 5 then
                            scs_m.objs(i).model.sim(2) = 4;
                            if find(mdaq_sim_blocks == scs_m.objs(i).model.sim(1)) ~= [] then
                                %microdaq.private.has_mdaq_block = %T; 
                            end
                        end
                    end
                end

                // in case of mdaq_signal_sim block save Signal ID param
                if scs_m.objs(i).model.sim(1) == "mdaq_signal_sim"
                    %microdaq.private.mdaq_signal_id = [%microdaq.private.mdaq_signal_id, scs_m.objs(i).model.ipar(1)];
                end

                if scs_m.objs(i).model.sim(1) == "mdaq_mem_write_sim"
                    scs_m.objs(i).model.ipar(5) = %microdaq.private.mem_write_idx;
                    %microdaq.private.mem_write_idx = %microdaq.private.mem_write_idx + 1;
                end

                if scs_m.objs(i).model.sim(1) == "mdaq_mem_read_sim"
                    scs_m.objs(i).model.ipar(5) = %microdaq.private.mem_read_idx;
                    %microdaq.private.mem_read_idx = %microdaq.private.mem_read_idx + 1;
                end
            end
        end
    end
    obj = scs_m;
endfunction
