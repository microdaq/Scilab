function [x,y,typ] = mdaq_adc(job,arg1,arg2)
   
    adc_desc = ["This block reads MicroDAQ analog inputs (AI).";
    "Select ADC type according to your hardware setup.";
    "";
    "output - measured value in volts";
    "";
    "Range: 5, 10";
    "";
    "Polarity:";
    "   1 - Unipolar";
    "   2 - Bipolar";
    "";
    "Mode:";
    "   0 - Single-ended";
    "   1 - Differential";
    "";
    "Set block parameters:"];

    adc_ch_lookup_table = [8,8,16,8,16];

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
                [ok, adc_channels, adc_range,adc_polarity,adc_mode,oversamp_count,exprs]=..
                scicos_getvalue(adc_desc,..
                            ['Channels:';
                            'Range:';
                            'Polarity:';
                            'Mode:';
                            'Oversampling:'],..
                            list('vec',-1,'vec',1,'vec',1,'vec',1,'vec',1),exprs)
            catch
                [ok, adc_channels, adc_range,adc_polarity,adc_mode,oversamp_count,exprs]=..
                scicos_getvalue(adc_desc,..
                            ['Channels:';
                            'Range:';
                            'Polarity:';
                            'Mode:';
                            'Oversampling:'],..
                            list('vec',-1,'vec',1,'vec',1,'vec',1,'vec',1),exprs)
            end

            if ~ok then
                break
            end

            global %microdaq;
            adc_converter =  %microdaq.private.mdaq_hwid(2);
            if adc_converter < 1 then
                message("Selected ADC converter is different than detected - run mdaq_hwinfo() for more details!");
                ok = %f;
            end

            n_channels = size(adc_channels);
            if n_channels(2) > adc_ch_lookup_table(adc_converter) then
                ok = %f;
                error_msg = 'Too many channels selected for ADC0' + string(adc_converter) + '!';
                message(error_msg);
            end

            if max(adc_channels) > adc_ch_lookup_table(adc_converter) then
                ok = %f;
                error_msg = 'Wrong channel number selected for ADC0' + string(adc_converter) + '!';
                message(error_msg);
            end

            if min(adc_channels) < 1 then
                ok = %f;
                error_msg = 'Wrong channel number selected for ADC0' + string(adc_converter) + '!';
                message(error_msg);
            end

            if adc_range <> 5 & adc_range <> 10 then
                ok = %f;
                message("Wrong ADC range selected - use 5 or 10!");
            end

            if adc_polarity < 1 | adc_polarity > 2 then
                ok = %f;
                message("Wrong polarity selected - use 1 or 2!");
            else
                if adc_converter > 1 & adc_polarity == 1 then
                    ok = %f;
                    message("This converter doesn''t support unipolar mode!");
                end
            end

            if adc_mode <> 0 & adc_mode <> 1 then
                ok = %f;
                message("Wrong ADC mode selected - use 0 or 1 to set single-ended or differential mode!");
            end

            if adc_mode == 1 & adc_converter <> 1 then
                message("This converter dones''t support differential mode!")
                of=%f;
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
        adc_converter = 0;
        adc_channels = 1;
        n_channels = 1;
        adc_range = 10;
        adc_polarity = 2;
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
        exprs=[sci2exp(adc_channels);sci2exp(adc_range);sci2exp(adc_polarity); sci2exp(adc_mode);sci2exp(oversamp_count) ]
        gr_i=['xstringb(orig(1),orig(2),[''CH: '' ; string(adc_channels)],sz(1),sz(2),''fill'');']
        x=standard_define([4 3],model,exprs,gr_i)
        x.graphics.in_implicit=[];
        x.graphics.exprs=exprs;
        x.graphics.style=["blockWithLabel;verticalLabelPosition=center;displayedLabel=CH:%1$s;fontColor=#5f5f5f"]
    end
endfunction
