function [x,y,typ] = mdaq_adc(job,arg1,arg2)
    global %microdaq;
    range_validation = [];

    if %microdaq.private.mdaq_hwid <> [] then
        adc_info = get_adc_info(%microdaq.private.mdaq_hwid);
        range_spec_opt = [];
        range_base_opt = [" 0: 0-5V"; " 1: 0-10V"; " 2: ±5V"; " 3: ±10V"];
        adc_polarity = 2; //Bipolar
        n = 1;

        for i=1:max(size(adc_info.range))
            for j=1:max(size(range_base_opt))
                if strindex(range_base_opt(j), adc_info.range(i)) <> [] then
                    range_spec_opt(n) = range_base_opt(j);
                    valid_num = range_base_opt(j);
                    valid_num = part(valid_num, 1:strindex(valid_num, ":"));
                    valid_num = strtod(valid_num);
                    range_validation(n) = valid_num;
                    n = n + 1;
                end
            end
        end

        adc_converter = adc_info.id;
        channel_desc = adc_info.channel;
        rate_desc = adc_info.rate;
        resolution_desc = adc_info.resolution;
        range_desc = adc_info.range_desc;
    else
        adc_converter = 1;
        channel_desc = "Unknown";
        rate_desc = "Unknown";
        resolution_desc = "Unknown";
        range_desc = "Unknown";
        range_spec_opt = "Unknown";
    end

    adc_desc = ["This block reads MicroDAQ analog inputs (AI).";
    "Select ADC type according to your hardware setup.";
    "";
    "output - measured value in volts";
    "";
    "Detected ADC parameters:";
    "channels: "+channel_desc;
    "rate: "+rate_desc;
    "resolution: "+resolution_desc;
    "range: "+range_desc;
    "";
    "ADC settings:"
    "Range:";
    range_spec_opt;
    "";
    "Mode:";
    "   0 - Single-ended";
    "   1 - Differential";
    "";
    "Oversampling:"
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
                'Mode:';
                'Oversampling:'],..
                list('vec',-1,'vec',1,'vec',1,'vec',1),exprs)
            catch
                [ok, adc_channels, adc_range,adc_mode,oversamp_count,exprs]=..
                scicos_getvalue(adc_desc,..
                ['Channels:';
                'Range:';
                'Mode:';
                'Oversampling:'],..
                list('vec',-1,'vec',1,'vec',1,'vec',1),exprs)
            end

            if ~ok then
                break
            end

            n_channels = size(adc_channels);

            //when hardware is detected check if parameters meet the requirements 
            if %microdaq.private.mdaq_hwid <> [] then
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

                if range_validation <> [] then
                    if find(range_validation == adc_range) == [] then
                        ok = %f;
                        error_msg = 'Wrong range selected for ADC0' + string(adc_id) + '!';
                        message(error_msg);
                    end
                end

                if adc_mode == 1 & adc_info.id <> 1 then
                    message("This converter dones''t support differential mode!")
                    of=%f;
                end
            end

            //translate new range definition to the old one 1,2,3,4 --> 5,10 V uni/bi
            if adc_range == 0 then
                adc_range = 5;   //0-5V
                adc_polarity = 1;//unipolar
            elseif adc_range == 1 then 
                adc_range = 10;  //0-10V
                adc_polarity = 1;//unipolar
            elseif adc_range == 2 then 
                adc_range = 5;   //±5V
                adc_polarity = 2;//bipolar
            elseif adc_range == 3 then 
                adc_range = 10;  //±10
                adc_polarity = 2;//bipolar
            end 

            if adc_mode <> 0 & adc_mode <> 1 then
                ok = %f;
                message("Wrong ADC mode selected - use 0 or 1 to set single-ended or differential mode!");
            end

            if oversamp_count < 1 | oversamp_count > 16 then
                message("Wrong oversampling sample count - use 1-16 value!")
                of=%f;
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
        adc_range = 10;   //±10V
        adc_converter = 1;//DAC01
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
        exprs=[sci2exp(adc_channels);sci2exp(3); sci2exp(adc_mode);sci2exp(oversamp_count) ]
        gr_i=['xstringb(orig(1),orig(2),[''CH: '' ; string(adc_channels)],sz(1),sz(2),''fill'');']
        x=standard_define([4 3],model,exprs,gr_i)
        x.graphics.in_implicit=[];
        x.graphics.exprs=exprs;
        x.graphics.style=["blockWithLabel;verticalLabelPosition=center;displayedLabel=CH:%1$s;fontColor=#5f5f5f"]
    end
endfunction
