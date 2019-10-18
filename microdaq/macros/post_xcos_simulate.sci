function []=post_xcos_simulate(%cpr, scs_m, needcompile)
    global %microdaq;

    for i = 1:size(scs_m.objs)
        curObj= scs_m.objs(i);
        if (typeof(curObj) == "Block" & curObj.gui == "mdaq_setup")
            if  %microdaq.dsp_loaded == %T then

                mdaqDSPStop();
                %microdaq.dsp_loaded = %F;

                // make scope nicer
                try
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
                catch
                end

                if curObj.model.ipar(3) == 1 then
                    connection_id = mdaqOpen();
                    //get number of records
                    [nr_records, result] = mlink_profile_data_get(connection_id, 1);
                    if nr_records > 0 & nr_records < 250000 & result > -1 then
                        [profile_data, result] = mlink_profile_data_get(connection_id, nr_records + 1);
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
                        disp('### Profiling data have been downloaded.');
                    end
                    mdaqClose(connection_id);
                end
            end
        end
    end
    
    if %microdaq.private.connection_id > -1 & (%microdaq.private.has_mdaq_param_sim | %microdaq.private.has_mdaqBlock) then
        mdaqClose(%microdaq.private.connection_id);
        %microdaq.private.connection_id = -1;
        %microdaq.private.has_mdaq_param_sim = %F;
    end

endfunction
