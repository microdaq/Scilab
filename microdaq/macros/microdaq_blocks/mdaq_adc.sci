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
    "Oversampling can be used to increase measurement resolution.";
    "Oversampling factor: ";
    "0 - disabled";
    "1 - 4 ADC readings   - 1 bit accuracy ";
    "2 - 16 ADC readings  - 2 bits accuracy";
    "3 - 64 ADC readings  - 3 bits accuracy";
    "4 - 256 ADC readings - 4 bits accuracy";
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
                [ok, channel, adc_range, differential, oversamp_count,exprs]=..
                scicos_getvalue(adc_desc,..
                ['Channels:';
                'Range:';
                'Differential:';
                'Oversampling:'],..
                list('vec',-1,'vec',1,'vec',1,'vec',1),exprs)
            catch
                [ok, channel, adc_range, differential, oversamp_count,exprs]=..
                scicos_getvalue(adc_desc,..
                ['Channels:';
                'Range:';
                'Differential:';
                'Oversampling:'],..
                list('vec',-1,'vec',1,'vec',1,'vec',1),exprs)
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
                adc_ch_count = strtod(adc_info.channel);

                if differential == 1 then
                    adc_ch_count = adc_ch_count / 2;
                end

                if ok & (size(channel, 'r') > 1) then
                    ok = %f;
                    error_msg = 'Wrong channel vector - single row vector expected!';
                    message(error_msg);
                end

                n_channels = size(channel, 'c');
                if ok & (n_channels > adc_ch_count) then
                    ok = %f;
                    error_msg = 'Too many channels selected!';
                    message(error_msg);
                end

                if ok & (max(channel) > adc_ch_count) | (min(channel) < 1) then
                    ok = %f;
                    error_msg = 'Wrong channel number selected!';
                    message(error_msg);
                end

                // check Range parameter
                if ok & (size(adc_range, 'r') > 1) then
                    ok = %f;
                    error_msg = 'Wrong range vector - single row vector expected!';
                    message(error_msg);
                end

                adc_range_size = size(adc_range, 'c');
                if ok & (adc_range_size > 1) & (adc_range_size <> n_channels) then
                    ok = %f;
                    error_msg = 'Wrong range vector - size should be same as Channel vector!';
                    message(error_msg);
                end

                if ok & (adc_range > size(adc_info.c_params.c_range)) | (adc_range == 0) then
                    ok = %f;
                    message("Wrong range selected");
                else
                    if ok & (differential == 1) & (adc_info.c_params.c_diff(adc_range) <> 1) then
                        ok = %f;
                        message("Converter does not support differential mode!");
                    end
                end

                if ok & (differential <> 0) & (differential <> 1) then
                    ok = %f;
                    message("Wrong mode selected - use 0 or 1 to set single-ended or differential mode!");
                end
                
                if ok & (oversamp_count < 0) | (oversamp_count > 4) then
                    ok = %f;
                    message("Wrong oversampling facator selected!");
                end
            else
                ok = %f;
                message('Unable to detect MicroDAQ confituration - run mdaq_hwinfo and try again!');
            end

            if ok then
                [model,graphics,ok] = check_io(model,graphics, [], n_channels, 1, []);
                graphics.exprs = exprs;

                adc_range_sim = adc_range;
                adc_range = adc_info.c_params.c_range(adc_range_sim);
                adc_polarity = adc_info.c_params.c_bipolar(adc_range_sim);
                
                if differential == 1 then
                    differential = 29;
                else
                    differential = 28;
                end
             
                model.ipar = [adc_range; adc_polarity; adc_range_sim; differential; oversamp_count; n_channels; channel'];

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
        adc_range_sim = 1;
        differential = 0;
        oversamp_count= 0;
        n_channels = 1;
        channel = 1;
        model=scicos_model()
        model.sim=list('mdaq_adc_sim',5)
        model.out=[1]
        model.outtyp=[1]
        model.evtin=1
        model.rpar=[]
        model.ipar=[ 0; 24; 1; 28; oversamp_count; n_channels; channel];
        model.dstate=[];
        model.blocktype='d'
        model.dep_ut=[%t %f]
        exprs=[sci2exp(channel); sci2exp(adc_range); sci2exp(differential); sci2exp(oversamp_count)];
        gr_i=['xstringb(orig(1),orig(2),[''CH: '' ; string(channel)],sz(1),sz(2),''fill'');']
        x=standard_define([4 3],model,exprs,gr_i)
        x.graphics.in_implicit=[];
        x.graphics.exprs=exprs;
        x.graphics.style=["blockWithLabel;verticalLabelPosition=center;displayedLabel=CH:%1$s;fontColor=#5f5f5f"]
    end
endfunction
