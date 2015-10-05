function [x,y,typ] = mdaq_adc(job,arg1,arg2)
    adc_desc = ["This block reads MicroDAQ analog inputs (AI).";
    "Select ADC type according to your hardware setup.";
    "";
    "output(1) - 16bit raw ADC value";
    "output(2) - measured value in volts";
    "";
    "Converter:";
    "   ADC01 - 8 channel, 166ksps, 12-bit, ±10V range";
    "   ADC02 - 8 channel, 166ksps, 16-bit, ±10V range";
    "   ADC03 - 8 channel, 600ksps, 12-bit, ±10V range";
    "   ADC04 - 16 channel, 600ksps, 12-bit, ±10V range";
    "   ADC05 - 16 channel, 500ksps, 16-bit, ±10V range";
    "";
    "Range: 5, 10";
    "";
    "Polarity:";
    "   1 - Unipolar";
    "   2 - Bipolar";
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
                [ok,adc_converter_str,adc_channels, adc_range, adc_polarity,exprs]=..
                scicos_getvalue(adc_desc,..
                ['Converter:';
                'Channels:';
                'Range:';
                'Polarity:'],..
                list('str',1,'vec',-1,'vec',1,'vec',1),exprs)
            catch
                [ok,adc_converter_str,adc_channels, adc_range, adc_polarity,exprs]=..
                scicos_getvalue(adc_desc,..
                ['Converter:';
                'Channels:';
                'Range:';
                'Polarity:'],..
                list('str',1,'vec',-1,'vec',1,'vec',1),exprs)
            end
            
            if ~ok then
                break
            end

            adc_converter_str = convstr(adc_converter_str, 'l');
            adc_converter = strtod(part(adc_converter_str, 4:5));
            if isnan(adc_converter) == %t | part(adc_converter_str, 1:3) <> "adc" then
                ok = %f;
                message("Wrong converter selected!");
            end

            if adc_converter > 5 | adc_converter < 1 then
                ok = %f;
                message("Wrong ADC converter selected!");
            end

            global %microdaq; 
            if adc_converter <> %microdaq.private.mdaq_hwid(2) then 
                message("Selected ADC converter is different than detected - run mdaq_hwinfo() for more details!");
            end


            n_channels = size(adc_channels);
            if (adc_converter < 4 & n_channels(2) > 8) | (adc_converter > 3 & n_channels(2) > 16) then
                ok = %f;
                error_msg = 'Too many channels selected for ADC0' + string(adc_converter) + '!';
                message(error_msg);
            end

            if (adc_converter < 4 & max(adc_channels) > 8) | (adc_converter > 3 & max(adc_channels) > 16) then
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
                message("Wrong ADC range selected - use 5 or 10!");
            else
                if adc_converter > 2 & adc_polarity == 1 then
                    ok = %f;
                    message("This converter doesn''t support unipolar mode!");
                end
            end
            
            if ok then
                //Differential mode is not supported, only one option is available
                adc_mode = 0;
                [model,graphics,ok] = check_io(model,graphics, [], [n_channels(2),n_channels(2)], 1, []);
                graphics.exprs = exprs;
                model.rpar = []; 
                model.ipar = [adc_converter;adc_range;adc_polarity;adc_mode;n_channels(2);adc_channels'];
                model.dstate = [];
                x.graphics = graphics;
                x.model = model;
                break;
            end
        end

    case 'define' then
        adc_converter_str = [];
        adc_converter = 1;
        adc_channels = 1;
        n_channels = 1;
        adc_range = 10;
        adc_polarity = 2;
        adc_mode = 1;
        model=scicos_model()
        model.sim=list('mdaq_adc_sim',5)
        model.in =[]
        model.out=[1;1]
        model.out2=[7;1]
        model.outtyp=[1;1]
        model.evtin=1
        model.rpar=[]
        model.ipar=[adc_converter;adc_range;adc_polarity;adc_mode;1;adc_channels]
        model.dstate=[];
        model.blocktype='d'
        model.dep_ut=[%t %f]
        exprs=["ADC01";sci2exp(adc_channels);sci2exp(adc_range);sci2exp(adc_polarity)]
        gr_i=['xstringb(orig(1),orig(2),[''CH: '' ; string(adc_channels)],sz(1),sz(2),''fill'');']
        x=standard_define([4 3],model,exprs,gr_i)
        x.graphics.in_implicit=[];
        x.graphics.exprs=exprs;
        x.graphics.style=["blockWithLabel;verticalLabelPosition=center;displayedLabel=CH:%2$s;fontColor=#5f5f5f"]
    end
endfunction
