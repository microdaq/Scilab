function [x,y,typ] = mdaq_dac(job,arg1,arg2)
    global %microdaq;
    if %microdaq.private.mdaq_hwid <> [] then
        dac_info = get_dac_info(%microdaq.private.mdaq_hwid);
        dac_converter = dac_info.id;
        channel_desc = dac_info.channel;
        resolution_desc = dac_info.resolution;
        range_desc = dac_info.c_params.c_range_desc;
        range_spec_opt = [];
        for i = 1:size(dac_info.c_params.c_range_desc, "r")
            range_spec_opt = [range_spec_opt; string(i) + ": " + dac_info.c_params.c_range_desc(i)];
        end
    else
        dac_converter = 1;
        channel_desc = "Unknown";
        resolution_desc = "Unknown";
        range_desc = "Unknown";
        range_spec_opt = "Unknown";
    end

    dac_desc = ["This block writes data to MicroDAQ analog output module (AO).";
    "Block detects MicroDAQ analog output type and allows";
    "setting output range, initial and termination voltage.";
    "The Range value can be a scalar or a vector that must ";
    "be the same length as the channel vector. If scalar value";
    "is specified, that setting is replicated over the channel vector."; 
    "Different ranges can be set for each channel if ADC supports ";
    "more then one output range.";
    "The Initial and Termination property can be a scalar or a vector"; 
    "";
    "Use Init/Term parameter allows to enable or disable setting";
    "initial or/and termination voltage values. User can provide";
    "scalar or vector with following values:";
    "0 - Initial and termination voltage value is ignored";
    "1 - Initial voltage value is used";
    "2 - Termination voltage value is used";
    "3 - Initial and termination voltage value is used";
    "";
    "input - value in volts"
    "";
    "Analog outputs parameters:";
    "Channels: "+channel_desc;
    "Resolution: "+resolution_desc;
    "";
    "Output rage:";
    range_spec_opt;
    "";
    "Set block parameters:"];

    x=[];y=[];typ=[];
    select job
    case 'set' then
        x=arg1
        model=arg1.model;
        graphics=arg1.graphics;
        exprs=graphics.exprs;
        while %t do
            try
                getversion('scilab');
                [ok,channel,dac_range,init_value,term_value,use_init_term,exprs]=..
                scicos_getvalue(dac_desc,..
                ['Channels:';
                'Range:';
                'Initial value:';
                'Termination value:';
                'Use Init/Term:'],..
                list('vec',-1,'vec',-1,'vec',-1,'vec',-1,'vec',-1),exprs)
            catch
                [ok,channel,dac_range,init_value,term_value,use_init_term,exprs]=..
                scicos_getvalue(dac_desc,..
                ['Channels:';
                'Range:';
                'Initial value:';
                'Termination value:';
                'Use Init/Term:'],..
                list('vec',-1,'vec',-1,'vec',-1,'vec',-1,'vec',-1),exprs)
            end;

            if ~ok then
                break
            end

            if %microdaq.private.mdaq_hwid <> [] then
                if find(dac_info.id == get_dac_list()) == [] then
                    ok = %f;
                    message("Configuration not detected - run mdaq_hwinfo and try again!");
                end

                dac_ch_count = strtod(dac_info.channel);

                // check Channel parameter
                if ok & (size(channel, 'r') > 1) then
                    ok = %f;
                    error_msg = 'Wrong channel vector - single row vector expected!';
                    message(error_msg);
                end

                n_channels = size(channel, 'c');
                if ok & (n_channels > dac_ch_count) then
                    ok = %f;
                    error_msg = 'Too many channels selected!';
                    message(error_msg);
                end

                if ok & (max(channel) > dac_ch_count) | (min(channel) < 1) then
                    ok = %f;
                    error_msg = 'Wrong channel number selected!';
                    message(error_msg);
                end

                // check Range parameter
                if ok & (size(dac_range, 'r') > 1) then
                    ok = %f;
                    error_msg = 'Wrong range vector - single row vector expected!';
                    message(error_msg);
                end

                dac_range_size = size(dac_range, 'c');
                if ok & (dac_range_size > 1) & (dac_range_size <> n_channels) then
                    ok = %f;
                    error_msg = 'Wrong range vector - size should be same as Channel vector!';
                    message(error_msg);
                end

                for i = 1:dac_range_size
                    if ok & (dac_range(i) > size(dac_info.c_params.c_range, 'c')) | (dac_range(i) < 1) then
                        ok = %f;
                        error_msg = 'Wrong range value!';
                        message(error_msg);
                    end
                end

                // check Init value parameter
                if ok & (size(init_value, 'r') > 1) then
                    ok = %f;
                    error_msg = 'Wrong Init value vector - single row vector expected!';
                    message(error_msg);
                end

                init_value_size = size(init_value, 'c');
                if ok & (init_value_size > 1) & (init_value_size <> n_channels) then
                    ok = %f;
                    error_msg = 'Wrong init value vector - scalar or vector for selected channels expected!';
                    message(error_msg);
                end

                // check Termination value parameter
                if ok & (size(term_value, 'r') > 1) then
                    ok = %f;
                    error_msg = 'Wrong termination value vector - single row vector expected!';
                    message(error_msg);
                end

                term_value_size = size(term_value, 'c');
                if ok & (term_value_size > 1) & (term_value_size <> n_channels) then
                    ok = %f;
                    error_msg = 'Wrong termination value vector - scalar or vector for selected channels expected!';
                    message(error_msg);
                end
                
                // check init term enable
                if ok & (find(use_init_term > 3) <> []) | (find(use_init_term < 0) <> []) then
                    ok = %f;
                    error_msg = 'Wrong Use init/term paremeter value!';
                    message(error_msg);
                end
                    
                if ok & (size(use_init_term, 'r') > 1) then
                    ok = %f;
                    error_msg = 'Wrong Use init/term paremeter vector - single row vector expected!';
                    message(error_msg);
                end

                use_init_term_size = size(use_init_term, 'c');
                if ok & (use_init_term_size > 1) & (use_init_term_size <> n_channels) then
                    ok = %f;
                    error_msg = 'Wrong Use init/term paremeter vector - scalar or vector for selected channels expected!';
                    message(error_msg);
                end
            else
                ok = %f;
                error_msg = 'Unable to detect MicroDAQ analog outputs - run mdaq_hwinfo and try again!';
                message(error_msg);
            end

            if ok then
                [model,graphics,ok] = check_io(model,graphics, n_channels, [], 1, []);
                graphics.exprs = exprs;

                // prepare block IPAR/RPAR data
                if dac_range_size == 1 then
                    dac_range_p = ones(n_channels, 1) * dac_info.c_params.c_range(dac_range);
                    dac_range_raw_p = ones(n_channels, 1) * dac_range;
                else
                    dac_range_p = ones(n_channels, 1);
                    dac_range_raw_p = ones(n_channels, 1);
                    for i = 1:n_channels
                        dac_range_p(i) = dac_info.c_params.c_range(dac_range(i));
                        dac_range_raw_p(i) = dac_range(i);
                    end
                end

                // init value
                if init_value_size == 1 then
                    init_value = ones(n_channels, 1) * init_value;
                else
                    init_value = init_value';
                end

                // termination value
                if term_value_size == 1 then
                    term_value = ones(n_channels, 1) * term_value;
                else 
                    term_value = term_value';
                end

                // init term enable value
                if use_init_term_size == 1 then
                    use_init_term = ones(n_channels, 1) * use_init_term;
                else 
                    use_init_term = use_init_term';
                end
                
                // set IPAR and RPAR
                model.ipar = [n_channels; channel'; dac_range_p; dac_range_raw_p; use_init_term];
                model.rpar = [init_value; term_value];

                model.dstate = [];
                x.graphics = graphics;
                x.model = model;
                break
            end
        end
    case 'define' then 
        channel=1
        dac_range = 1;
        dac_range_raw = 1;
        init_value = 0;
        term_value = 0;
        use_init_term = 2;
        n_channels = 1;
        model=scicos_model();
        model.sim=list('mdaq_dac_sim',5);
        model.in =1;
        model.in2=1;
        model.intyp=1;
        model.out=[];
        model.evtin=1;
        model.rpar = [init_value; term_value];
        // TODO: range hardcoded
        model.ipar = [n_channels; channel'; 3; dac_range_raw; use_init_term];
        model.dstate=[];
        model.blocktype='d';
        model.dep_ut=[%t %f];
        exprs=[sci2exp(channel);sci2exp(dac_range);sci2exp(init_value);sci2exp(term_value);sci2exp(use_init_term)];
        gr_i=['xstringb(orig(1),orig(2),[''CH:'' ; string(channel)],sz(1),sz(2),''fill'');'];
        x=standard_define([4 3],model,exprs,gr_i);
        x.graphics.in_implicit=[];
        x.graphics.exprs=exprs;
        x.graphics.style=["blockWithLabel;verticalLabelPosition=center;displayedLabel=CH:%1$s;fontColor=#5f5f5f"]
    end
endfunction
