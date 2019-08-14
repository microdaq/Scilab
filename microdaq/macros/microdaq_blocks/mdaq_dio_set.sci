function [x,y,typ] = mdaq_dio_set(job,arg1,arg2)
    dio_set_desc = ["This block sets MicroDAQ DIO output state.";
    "";
    "DIO pin: 1...32";
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
                [ok,dio_pin,dio_init,dio_term,exprs]=..
                scicos_getvalue(dio_set_desc,..
                ['DIO pin:';
                'DIO init state:';
                'DIO end state:'],..
                list('vec',1,'vec',1,'vec',1),exprs)
            catch
                [ok,dio_pin,dio_init,dio_term,exprs]=..
                scicos_getvalue(dio_set_desc,..
                ['DIO pin number:';
                'DIO init state:';
                'DIO end state:'],..
                list('vec',1,'vec',1,'vec',1),exprs)
            end;

            if ~ok then
                break
            end

            if dio_pin > 32 | dio_pin < 1 then
                ok = %f;
                message("Wrong DIO pin selected - use value from 1 to 32!");
            end

            if dio_init > 1 | dio_init < 0 then
                ok = %f;
                message("Wrong DIO init value, use 0 or 1!");
            end

            if dio_term > 1 | dio_term < 0 then
                ok = %f;
                message("Wrong DIO end value - use 0 or 1!");
            end

            if ok then
                [model,graphics,ok] = check_io(model,graphics, 1, [], 1, []);
                graphics.exprs = exprs;
                model.rpar = [];
                model.ipar = [dio_pin;dio_init;dio_term];
                model.dstate = [];
                x.graphics = graphics;
                x.model = model;
                x.graphics.style=["mdaq_dio_set;blockWithLabel;verticalLabelPosition=center;displayedLabel=DIO%1$s;fontColor=#5f5f5f"]
                break
            end
        end
    case 'define' then
        dio_pin = 1;
        dio_init = 0;
        dio_term = 0;
        model=scicos_model()
        model.sim=list('mdaq_dio_set_sim',5)
        model.in =1
        model.in2=1
        model.intyp=1
        model.out=[]
        model.evtin=1
        model.rpar=[];
        model.ipar=[dio_pin;dio_init;dio_term]
        model.dstate=[];
        model.blocktype='d'
        model.dep_ut=[%t %f]
        exprs=[sci2exp(dio_pin);sci2exp(dio_init);sci2exp(dio_term)]
        gr_i=['xstringb(orig(1),orig(2),[''DIO'' ; string(dio_pin)],sz(1),sz(2),''fill'');']
        x=standard_define([4 3],model,exprs,gr_i)
        x.graphics.in_implicit=[];
        x.graphics.exprs=exprs;
        x.graphics.style=["blockWithLabel;verticalLabelPosition=center;displayedLabel=DIO%1$s;fontColor=#5f5f5f"]

    end
endfunction
