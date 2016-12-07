function [x,y,typ] = mdaq_adc(job,arg1,arg2)
    global %microdaq;
    range_validation = [];

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
        //range_spec_opt = "TODO";
    else
        adc_converter = 1;
        channel_desc = "Unknown";
        rate_desc = "Unknown";
        resolution_desc = "Unknown";
        range_desc = "Unknown";
        range_spec_opt = "Unknown";
    end

    adc_desc = ["This block reads MicroDAQ analog inputs (AI).";
    "Blocks supports single-ended and differential ";
    "measurements. In order to select differential mode ";
    "set ''Differential'' property to 1.";
    "Block supports oversampling which allows reading "; 
    "more then one ADC sample to achieve higher accuracy. ";
    "User can select up to 16 samples to read.";
    "";
    "output - measured value in volts";
    "";
    "Detected ADC parameters:";
    "Number of channels: "+channel_desc;
    "Max sample rate: "+rate_desc;
    "Resolution: "+resolution_desc;
    "";
    "Avaliable input ranges:";
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
                [ok, adc_channels, adc_range, adc_mode,oversamp_count,exprs]=..
                scicos_getvalue(adc_desc,..
                ['Channels:';
                'Range:';
                'Differential:';
                'Oversampling:'],..
                list('vec',-1,'vec',1,'vec',1,'vec',1),exprs)
            catch
                [ok, adc_channels, adc_range,adc_mode,oversamp_count,exprs]=..
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

            n_channels = size(adc_channels);

            //when hardware is detected check if parameters meet the requirements 
            if %microdaq.private.mdaq_hwid <> [] then
                adc_id = %microdaq.private.mdaq_hwid(2);
                if n_channels(2) > strtod(adc_info.channel) then
                    ok = %f;
                    error_msg = 'Too many channels selected for ADC0' + string(adc_id) + '!';
                    message(error_msg);
                end

                if max(adc_channels) > strtod(adc_info.channel) then
                    ok = %f;
                    error_msg = 'Wrong channel number selected for ADC0' + string(adc_id) + '!';
                    message(error_msg);
                end

                if min(adc_channels) < 1 then
                    ok = %f;
                    error_msg = 'Wrong channel number selected for ADC0' + string(adc_id) + '!';
                    message(error_msg);
                end

                if adc_range > size(adc_info.c_params.c_range) then 
                        ok = %f;
                        error_msg = 'Wrong range selected for ADC0' + string(adc_id) + '!';
                        message(error_msg);
                end
                 
                if adc_mode == 1 & adc_info.c_params.c_diff(adc_range) <> 1 then
                    ok = %f;
                    message("This converter does not support differential mode!");
                end
            end

            if adc_mode <> 0 & adc_mode <> 1 then
                ok = %f;
                message("Wrong ADC mode selected - use 0 or 1 to set single-ended or differential mode!");
            end

            if oversamp_count < 1 | oversamp_count > 16 then
                message("Wrong oversampling sample count - use 1-16 value!")
                of=%f;
            end

            adc_polarity = adc_info.c_params.c_bipolar(adc_range);
            adc_range = adc_info.c_params.c_range(adc_range);
            if adc_mode == 1 then
                adc_mode = 29;
            else
                adc_mode = 28;
            end
            

            if ok then
                [model,graphics,ok] = check_io(model,graphics, [], n_channels(2), 1, []);
                graphics.exprs = exprs;
                model.rpar = [];
                model.ipar = [adc_converter;adc_range;adc_polarity;adc_mode;oversamp_count;n_channels(2);adc_channels'];
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
        adc_polarity = 2; //bipolar
        adc_range = 1;   //±10V
        adc_converter = 1;//ADC01
        adc_mode = 0;
        oversamp_count=1;
        model=scicos_model()
        model.sim=list('mdaq_adc_sim',5)
        model.out=[1]
        model.outtyp=[1]
        model.evtin=1
        model.rpar=[]
        model.ipar=[adc_converter; adc_range;adc_polarity;adc_mode;oversamp_count;1;adc_channels]
        model.dstate=[];
        model.blocktype='d'
        model.dep_ut=[%t %f]
        exprs=[sci2exp(adc_channels);sci2exp(1); sci2exp(adc_mode);sci2exp(oversamp_count) ]
        gr_i=['xstringb(orig(1),orig(2),[''CH: '' ; string(adc_channels)],sz(1),sz(2),''fill'');']
        x=standard_define([4 3],model,exprs,gr_i)
        x.graphics.in_implicit=[];
        x.graphics.exprs=exprs;
        x.graphics.style=["blockWithLabel;verticalLabelPosition=center;displayedLabel=CH:%1$s;fontColor=#5f5f5f"]
    end
endfunction
