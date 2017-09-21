function [x,y,typ] = mdaq_adc(job,arg1,arg2)
    global %microdaq;
    adc_comment = "";
    if %microdaq.private.mdaq_hwid <> [] then
        adc_info = get_adc_info(%microdaq.private.mdaq_hwid);
        channel_desc = adc_info.channel;
        rate_desc = adc_info.rate;
        resolution_desc = adc_info.resolution;
        range_desc = adc_info.c_params.c_range_desc;
        range_spec_opt = [];
        range_desc = "";
        adc_comment = adc_info.comment;
        for i = 1:size(adc_info.c_params.c_range_desc, "r")
            range_spec_opt = [range_spec_opt; string(i) + ": " + adc_info.c_params.c_range_desc(i)];
        end
    else
        channel_desc = "Unknown";
        rate_desc = "Unknown";
        resolution_desc = "Unknown";
        range_desc = "Unknown";
        range_spec_opt = "Unknown";
    end

    adc_desc = ["This block reads MicroDAQ analog inputs (AI). Block detects";
    "MicroDAQ analog inputs type and allows channel, range";
    "and measurement type selection.";
    "In order to select analog input channels scalar or vector";
    "containing channel number have to be provided.";
    "Input range can be selected by providing scalar or vector";
    "with range identifiers. If single range provided it will";
    "be applied for all selected channels."
    "Single-ended or differential measurement type can be selected.";
    "Scalar or vector with 1 and 0 values can be provided to enable";
    "and disable differential mode.";
    "If scalar is provided it will be applied for all used channels";
    "";
    "Averaging allows to increase measurement accuracy by calculating";
    "average from 4-256 ADC samples. ";
    "Averaging factor: ";
    "0 - averaging disabled";
    "1 - 4 ADC reads per channel";
    "2 - 16 ADC reads per channel";
    "3 - 64 ADC reads per channel";
    "4 - 256 ADC reads per channel";
    "";
    "output - ADC value scaled to selected range";
    "";
    "Analog inputs parameters:";
    "Channels: "+channel_desc;
    "Max sample rate: "+rate_desc;
    "Resolution: "+resolution_desc;
    "";
    "Input range:";
    range_spec_opt;
    "";
    adc_comment;
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
                [ok, channel, adc_range, adc_mode, oversampling,exprs]=..
                scicos_getvalue(adc_desc,..
                ['Channels:';
                'Range:';
                'Differential:';
                'Averaging:'],..
                list('row',-1,'row',-1,'row',-1,'vec',1),exprs)
            catch
                [ok, channel, adc_range, adc_mode, oversampling,exprs]=..
                scicos_getvalue(adc_desc,..
                ['Channels:';
                'Range:';
                'Differential:';
                'Averaging:'],..
                list('row',-1,'row',-1,'row',-1,'vec',1),exprs)
            end

            if ~ok then
                break
            end

            n_channels = size(channel,"*");

            if %microdaq.private.mdaq_hwid <> [] then
                adc_id = %microdaq.private.mdaq_hwid(2);
                if ok & (find(adc_info.id == get_adc_list()) == []) then
                    ok = %f;
                    message("Configuration not detected - run mdaq_hwinfo and try again!");
                end

                // check Channel parameter
                adc_n_channels = strtod(adc_info.channel);

                if ok & (size(channel, 'r') > 1) then
                    ok = %f;
                    message('Wrong channel vector - single row vector expected!');
                end

                n_channels = size(channel, 'c');
                if ok & (n_channels > adc_n_channels) then
                    ok = %f;
                    message('Too many channels selected!');
                end

                adc_range_size = size(adc_range, 'c');
                if ok & (adc_range_size <> 1 & adc_range_size <> n_channels) then
                    ok = %f;
                    message("Range vector should match selected AI channels!");
                end
                
                adc_mode_size = size(adc_mode, 'c');
                if ok & (adc_mode_size <> 1 & adc_mode_size <> n_channels) then
                    ok = %f;
                    message("Mode vector should match selected AI channels!");
                end
                
                if ok & (max(channel) > adc_n_channels) | (min(channel) < 1) then
                    ok = %f;
                    message('Wrong channel number selected!');
                end

                // check Range parameter
                if ok & (size(adc_range, 'r') > 1) then
                    ok = %f;
                    message('Wrong range vector - single row vector expected!');
                end

                if adc_range_size > 1 then
                    for i=1:adc_range_size
                        if ok & (adc_range(i) > size(adc_info.c_params.c_range)) | (adc_range(i) == 0) then
                            ok = %f;
                            message("Wrong range selected!");
                            break;
                        end
                    end
                end
                
                if adc_mode_size > 1 then
                    for i=1:adc_mode_size

                        if ok & (adc_mode(i) == 1) & (adc_info.c_params.c_diff(1)) <> 1 then
                            ok = %f;
                            message("Converter does not support differential mode!");
                            break;
                        end
                 
                        if ok & (adc_mode(i) <> 0) & (adc_mode(i) <> 1) then
                            ok = %f;
                            message("Wrong mode selected - use 0 or 1 to set single-ended or differential mode!");
                            break;
                        end
                 
                    end
                end

                if ok & (oversampling < 0) | (oversampling > 4) then
                    ok = %f;
                    message("Wrong oversampling facator selected!");
                end
                
                adc_range_t = adc_range; 
                adc_range_param = adc_range; 
                adc_mode_t = adc_mode; 

                if adc_range_size == 1 then
                    adc_range = ones(n_channels,1) * adc_info.c_params.c_range(adc_range_t)';
                    adc_range_param = ones(n_channels,1) * adc_range_t;
                    adc_range_sim   = ones(n_channels,1) * adc_range_t
                else
                    adc_range = adc_info.c_params.c_range(adc_range_t);
                    adc_range_param = adc_range_t;
                    adc_range_sim = adc_range_t';
                end

                if adc_range_size == 1 then
                    adc_polarity = ones(n_channels,1) * adc_info.c_params.c_bipolar(adc_range_t)';
                else
                    adc_polarity = adc_info.c_params.c_bipolar(adc_range_t);
                end

                if adc_mode_size == 1 then
                    if adc_mode_t == 1 then
                        adc_mode = ones(n_channels,1) * 29;
                        adc_mode_sim = ones(n_channels,1);
                    else
                        adc_mode = ones(n_channels,1) * 28;
                        adc_mode_sim = zeros(n_channels,1);
                    end
                else
                    adc_mode = ones(n_channels,1);
                    for i = find(adc_mode_t == 1)
                        adc_mode(i) = 29;
                    end
                    for i = find(adc_mode_t == 0)
                        adc_mode(i) = 28;
                    end
                    adc_mode_sim = adc_mode_t';
                end

                if ~exists("%scicos_prob") then
                    result = adc_check_params(channel, adc_range_param', adc_mode_sim);
                    if result < 0 then
                        message(mdaq_error2(result));
                        ok = %f;
                        break;
                    end
                end

            else
                ok = %f;
                message('Unable to detect MicroDAQ confituration - run mdaq_hwinfo and try again!');
            end

            if ok then
                [model,graphics,ok] = check_io(model,graphics, [], n_channels, 1, []);
                graphics.exprs = exprs;

                model.ipar=[n_channels; channel'; adc_range; adc_polarity; adc_mode; adc_range_sim; adc_mode_sim; oversampling]
                model.dstate = [];
                x.graphics = graphics;
                x.model = model;
                break;
            end
        end
    case 'define' then
        adc_converter_str = [];
        adc_range = 1;
        adc_polarity = 1;
        adc_mode = 0;
        adc_range_sim = 1;
        adc_mode_sim = 0;
        oversampling= 0;
        n_channels = 1;
        channel = 1;
        model=scicos_model()
        model.sim=list('mdaq_adc_sim',5)
        model.out=[1]
        model.outtyp=[1]
        model.evtin=1
        model.rpar=[]
        model.ipar=[n_channels; channel; 0; 24; 28; adc_range_sim; adc_mode_sim; oversampling];
        model.dstate=[];
        model.blocktype='d'
        model.dep_ut=[%t %f]
        exprs=[sci2exp(channel); sci2exp(adc_range); sci2exp(adc_mode); sci2exp(oversampling)];
        gr_i=['xstringb(orig(1),orig(2),[''CH: '' ; string(channel)],sz(1),sz(2),''fill'');']
        x=standard_define([4 3],model,exprs,gr_i)
        x.graphics.in_implicit=[];
        x.graphics.exprs=exprs;
        x.graphics.style=["blockWithLabel;verticalLabelPosition=center;displayedLabel=CH:%1$s;fontColor=#5f5f5f"]
    end
endfunction
