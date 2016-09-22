function [x,y,typ] = mdaq_pwm(job,arg1,arg2)
    pwm_desc = ["This block sets MicroDAQ PWM outputs.";
    "Block controls PWM module module which contains A and B channels.";
    "PWM period is defined in microseconds. Polarity allows to generate";
    "inverted PWM waveform. Block input data should be in range 0-100.";
    "";
    "A input - PWM A channel waveform duty"
    "B input - PWM B channel waveform duty"
    "";
    "PWM module: PWM1...PWM3";
    "";
    "Period: 2-500000 microseconds"
    "";
    "Polarity:";
    "  0 - Active HIGH";
    "  1 - Active LOW";
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
                [ok,pwm_module_str,pwm_period,pwm_polarity,exprs]=..
                scicos_getvalue(pwm_desc,..
                ['Module:';
                'Period [us]:';
                'Polarity:'],..
                list('str',1,'vec',1,'vec',1),exprs)
            catch
                [ok,pwm_module_str,pwm_period,pwm_polarity,exprs]=..
                scicos_getvalue(pwm_desc,..
                ['Module:';
                'Period [us]:';
                'Polarity:'],..
                list('str',1,'vec',1,'vec',1),exprs)
            end

            if ~ok then
                break
            end

            pwm_module_str = convstr(pwm_module_str, 'l');
            pwm_module = strtod(part(pwm_module_str, 4:5));
            if isnan(pwm_module) == %t | part(pwm_module_str, 1:3) <> "pwm" then
                ok = %f;
                message("Wrong PWM module selected!");
            end
            
            if pwm_module > 3 | pwm_module < 1 then
                ok = %f;
                message("Select module 1,2 or 3");
            end

            if pwm_period < 2 | pwm_period > 500000 then
                ok = %f;
                message("Wrong PWM period value! (2-500000)");
            end

            if pwm_polarity > 1 | pwm_polarity < 0 then
                ok = %f;
                message("Select polarity 0 or 1");
            end

            if ok then
                [model,graphics,ok] = check_io(model,graphics, [1,1], [], 1, []);
                graphics.exprs = exprs;
                model.ipar = [pwm_module; pwm_period; pwm_polarity];
                model.dstate = [];
                x.graphics = graphics;
                x.model = model;
                break;
            end
        end

    case 'define' then
        pwm_module = 1;
        pwm_module_str = [];
        pwm_period = 1000;
        pwm_polarity = 0;
        model=scicos_model()
        model.sim=list('mdaq_pwm_sim',5)
        model.in =[1;1]
        model.in2=[1;1]
        model.intyp=[1;1]
        model.out=[]
        model.evtin=1
        model.rpar=[]
        model.ipar=[pwm_module;pwm_period;pwm_polarity]
        model.dstate=[];
        model.blocktype='d'
        model.dep_ut=[%t %f]
        exprs=["PWM1";sci2exp(pwm_period);sci2exp(pwm_polarity)]
        gr_i=['xstringb(orig(1),orig(2),[''PWM:'' ; string(pwm_module)],sz(1),sz(2),''fill'');']
        x=standard_define([4 3],model,exprs,gr_i)
        x.graphics.in_implicit=[];
        x.graphics.exprs=exprs;
        x.graphics.style=["blockWithLabel;verticalLabelPosition=center;displayedLabel=%1$s;fontColor=#5f5f5f"]
        x.graphics.in_label = ["A", "B"];
    end
endfunction
