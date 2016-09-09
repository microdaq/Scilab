function []=post_xcos_simulate(%cpr, scs_m, needcompile)
    global %microdaq;

    for i = 1:size(scs_m.objs)
        curObj= scs_m.objs(i);
        if (typeof(curObj) == "Block" & curObj.gui == "mdaq_setup")
            if  %microdaq.dsp_loaded == %T then
                client_disconnect(1);
                %microdaq.dsp_loaded = %F;

                connection_id = mdaq_open();
                if connection_id < 0 then
                    return;
                end

                if connection_id > -1 then
                    mlink_set_obj(connection_id, 'model_stop_flag', 1 );
                    mlink_set_obj(connection_id, 'terminate_signal_task', 1 );

                    // save dsp profiling data
                    if curObj.model.ipar(3) == 1 then
                        //get number of records
                        [nr_records, result] = mlink_profile_data_get(connection_id, 1);
                        if nr_records > 0 & nr_records < 250000 & result > -1 then
                            [profile_data, result] = mlink_profile_data_get(connection_id, nr_records + 1);
                            if result > -1 then
                                if %microdaq.private.mdaq_hwid(4) == 0 then
                                    cpu_clock = 300000000;
                                else
                                    cpu_clock = 456000000;
                                end
                                profile_data = profile_data / (cpu_clock / 1000000);
                                dsp_exec_profile = tlist(["listtype","init","step","end"], [], []);
                                dsp_exec_profile.init = profile_data(3);
                                dsp_exec_profile.step = profile_data(4:nr_records);
                            dsp_exec_profile.end = profile_data(2);
                            save(TMPDIR + filesep() + "profiling_data", "dsp_exec_profile");
                            clear dsp_exec_profile;
                        end
                    end
                    
                    // make scope nicer
                    list_fig=winsid();
                    for i=1:length(list_fig)
                        h=get_figure_handle(list_fig(i));
                        if h.children.type == "Axes" then
                            axes = h.children;
                            axes.grid = [1,1];
                            axes.grid_style = [9,10];
                            poliline = axes.children;
                            if isempty(poliline.children) then
                                poliline.polyline_style = 2;
                            end
                        end
                    end
                end
                mdaq_close(connection_id);
            end
        end
    end
end

if %microdaq.private.connection_id > -1 & %microdaq.private.has_mdaq_param_sim then
    mdaq_close(%microdaq.private.connection_id);
    %microdaq.private.connection_id = -1;
    %microdaq.private.has_mdaq_param_sim = %F;
end

if %microdaq.private.connection_id > -1 & %microdaq.private.has_mdaq_block then
    mdaq_close(%microdaq.private.connection_id);
    %microdaq.private.connection_id = -1;
    %microdaq.private.has_mdaq_block = %f
end

endfunction
