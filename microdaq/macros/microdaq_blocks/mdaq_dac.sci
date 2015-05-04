function [x,y,typ] = mdaq_dac(job,arg1,arg2)
    dac_desc = ["This block sets MicroDAQ analog outputs (AO).";
    "DAC block allows to set terminate voltage which will be set at";
    "the end of simulation in Ext mode.";
    "";
    "User can use option Terminate all DACs with voltage to set";
    "same voltage at all DAC channels. Without selecting this option";
    "user can define different terminate voltages for DAC channel.";
    "";
    "input(1) - input value in volts"
    "";
    "Converter:";
    "  DAC01 - 8 channel, 12-bit, 0-5V range";
    "  DAC02 - 8 channel, 12-bit, ±10V range";
    "  DAC03 - 8 channel, 16-bit, ±10V range";
    "";
    "Mode:";
    "  1 - Sequential";
    "  2 - Simultaneous";
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
                [ok,converter_str,channel,dac_mode,term_value,exprs]=..
                scicos_getvalue(dac_desc,..
                ['Converter:';
                'Channels:';
                'Mode:';
                'Termination value:'],..
                list('str',1,'vec',-1,'vec',1,'vec',-1),exprs)
            catch
                [ok,converter_str,channel,dac_mode,term_value,exprs]=..
                scicos_getvalue(dac_desc,..
                ['Converter:';
                'Channels:';
                'Mode:';
                'Termination value:'],..
                list('str',1,'vec',-1,'vec',1,'vec',-1),exprs)
            end;

            if ~ok then
                break
            end

            converter_str = convstr(converter_str, 'l');
            converter = strtod(part(converter_str, 4:5));
            if isnan(converter) == %t | part(converter_str, 1:3) <> "dac" then
                ok = %f;
                message("Wrong DAC converter selected!");
            end

            if converter > 3 | converter < 1 then
                ok = %f;
                message("Wrong DAC converter selected!");
            end

            n_channels = size(channel);
            if n_channels(2) > 8 then
                ok = %f;
                error_msg = 'Too many channels selected for DAC0' + string(converter) + '!';
                message(error_msg);
            end

            if max(channel) > 8 | min(channel) < 1 then
                ok = %f;
                error_msg = 'Wrong channel number selected for DAC0' + string(converter) + '!';
                message(error_msg);
            end

            if dac_mode > 2 | dac_mode < 1 then
                ok = %f;
                message("Wrong mode selected, use 1 or 2!");
            end

            if ok then
                n_channels = size(channel);
                n_term_value = size(term_value);
                if  n_term_value(2) > 1 then
                    if  n_term_value(2) <> n_channels(2) then
                        message('Set termination value for selected channels or set one value which will be used for all channels!')
                        ok = %f;
                    end
                    term_value = term_value';
                else
                    term_value(1:8) = term_value;
                end
            end

            if ok then
                [model,graphics,ok] = check_io(model,graphics, n_channels(2), [], 1, []);
                graphics.exprs = exprs;
                model.rpar = [8; term_value];
                model.ipar = [converter;dac_mode;n_channels(2);channel'];
                model.dstate = [];
                x.graphics = graphics;
                x.model = model;
                break
            end
        end
    case 'define' then
        converter=1
        converter_str = [];
        channel=1
        term_value=0
        dac_mode=1
        model=scicos_model()
        model.sim=list('mdaq_dac_sim',5)
        model.in =1
        model.in2=1
        model.intyp=1
        model.out=[]
        model.evtin=1
        model.rpar = [1; term_value];
        model.ipar = [converter;dac_mode;1;channel'];
        model.dstate=[];
        model.blocktype='d'
        model.dep_ut=[%t %f]
        exprs=["DAC01";sci2exp(channel);sci2exp(dac_mode);sci2exp(term_value)]
        gr_i=['xstringb(orig(1),orig(2),[''CH:'' ; string(channel)],sz(1),sz(2),''fill'');']
        x=standard_define([4 3],model,exprs,gr_i)
        x.graphics.in_implicit=[];
        x.graphics.exprs=exprs;
        x.graphics.style=["blockWithLabel;verticalLabelPosition=center;displayedLabel=CH:%2$s;fontColor=#5f5f5f"]
    end
endfunction
