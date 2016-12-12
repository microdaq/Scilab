function [x,y,typ] = mdaq_adc(job,arg1,arg2)
    global %microdaq;
    if %microdaq.private.mdaq_hwid <> [] then
        adc_info = get_adc_info(%microdaq.private.mdaq_hwid);
        adc_converter = adc_info.id;
        channel_desc = adc_info.channel;
        rate_desc = adc_info.rate;
        resolution_desc = adc_info.resolution;
        range_desc = adc_info.c_params.c_range_desc;
        range_spec_opt = [];
        range_desc = "";
        for i = 1:size(adc_info.c_params.c_range_desc, "r")
            range_spec_opt = [range_spec_opt; string(i) + ": " + adc_info.c_params.c_range_desc(i)];
        end
    else
        adc_converter = 1;
        channel_desc = "Unknown";
        rate_desc = "Unknown";
        resolution_desc = "Unknown";
        range_desc = "Unknown";
        range_spec_opt = "Unknown";
    end

    adc_desc = ["This block reads MicroDAQ analog inputs (AI).";
    "Block detects MicroDAQ analog inputs type and allows";
    "channel, input range and measurement type selection.";
    "Single or multiply channels can be selected by providing";
    "vector with channel numbers. Input range can be selected";
    "and will be applied for all selected channels."
    "Single-ended or differential measurement type can be selected.";
    "In order to select differential mode ''Differential'' parameter";
    "has to be set to 1.";
    "";
    "output - value in volts";
    "";
    "Analog inputs parameters:";
    "Channels: "+channel_desc;
    "Max sample rate: "+rate_desc;
    "Resolution: "+resolution_desc;
    "";
    "Input range:";
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
                [ok, adc_channels, adc_range, adc_mode,exprs]=..
                scicos_getvalue(adc_desc,..
                ['Channels:';
                'Input range:';
                'Differential:'],..
                list('vec',-1,'vec',1,'vec',1),exprs)
            catch
                [ok, adc_channels, adc_range,adc_mode,exprs]=..
                scicos_getvalue(adc_desc,..
                ['Channels:';
                'Input range:';
                'Differential:'],..
                list('vec',-1,'vec',1,'vec',1),exprs)
            end

            oversamp_count = 1;
            
            if ~ok then
                break
            end

            no_selected_ch = size(adc_channels,"*");
            
            if %microdaq.private.mdaq_hwid <> [] then
                adc_id = %microdaq.private.mdaq_hwid(2);


                if adc_range > size(adc_info.c_params.c_range) | adc_range == 0 then
                    ok = %f;
                    message("Wrong range selected");
                else
                    if adc_mode == 1 & adc_info.c_params.c_diff(adc_range) <> 1 then
                        ok = %f;
                        message("Converter does not support differential mode!");
                    end
                end

                if adc_mode <> 0 & adc_mode <> 1 then
                    ok = %f;
                    message("Wrong mode selected - use 0 or 1 to set single-ended or differential mode!");
                end

                adc_ch_count = strtod(adc_info.channel);
                if adc_mode == 1 then
                    adc_ch_count = adc_ch_count / 2;
                end

                if no_selected_ch > adc_ch_count then
                    ok = %f;
                    message("Too many selected channels!");
                end

                if max(adc_channels) > adc_ch_count | min(adc_channels) < 1  then
                    ok = %f;
                    message("Wrong channel number selected");
                end

            else
                ok = %f;
                message('Unable to detect MicroDAQ confituration - run mdaq_hwinfo and try again!');
            end

            if ok then
                adc_polarity_sim = adc_range;
                adc_polarity = adc_info.c_params.c_bipolar(adc_range);
                adc_range = adc_info.c_params.c_range(adc_range);
                if adc_mode == 1 then
                    adc_mode = 29;
                else
                    adc_mode = 28;
                end
                [model,graphics,ok] = check_io(model,graphics, [], no_selected_ch, 1, []);
                graphics.exprs = exprs;
                model.rpar = [];
                model.ipar = [adc_converter;adc_range;adc_polarity;adc_mode;adc_polarity_sim;no_selected_ch;adc_channels'];
                model.dstate = [];
                x.graphics = graphics;
                x.model = model;
                break;
            end
        end
    case 'define' then
        adc_converter_str = [];
        adc_channels = 1;
        n_channels = 1;
        adc_polarity = 1;
        adc_polarity_sim = 1;
        adc_range = 1;
        adc_converter = 1;
        adc_mode = 0;
        oversamp_count=1;
        model=scicos_model()
        model.sim=list('mdaq_adc_sim',5)
        model.out=[1]
        model.outtyp=[1]
        model.evtin=1
        model.rpar=[]
        model.ipar=[adc_converter; adc_range;adc_polarity;adc_mode;adc_polarity_sim;1;adc_channels]
        model.dstate=[];
        model.blocktype='d'
        model.dep_ut=[%t %f]
        exprs=[sci2exp(adc_channels);sci2exp(1); sci2exp(adc_mode)]
        gr_i=['xstringb(orig(1),orig(2),[''CH: '' ; string(adc_channels)],sz(1),sz(2),''fill'');']
        x=standard_define([4 3],model,exprs,gr_i)
        x.graphics.in_implicit=[];
        x.graphics.exprs=exprs;
        x.graphics.style=["blockWithLabel;verticalLabelPosition=center;displayedLabel=CH:%1$s;fontColor=#5f5f5f"]
    end
endfunction
