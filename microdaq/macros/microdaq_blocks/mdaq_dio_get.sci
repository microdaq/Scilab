function [x,y,typ] = mdaq_dio_get(job,arg1,arg2)
    dio_get_desc = ["This block reads MicroDAQ DIO input state.";
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
                getversion('scilab');
                [ok,dio_pin,exprs]=..
                scicos_getvalue(dio_get_desc,..
                ['DIO pin:'],..
                list('vec',1),exprs)
            catch
                [ok,dio_pin,exprs]=..
                scicos_getvalue(dio_get_desc,..
                ['DIO pin:'],..
                list('vec',1),exprs)
            end;

            if ~ok then
                break
            end

            if dio_pin > 32 | dio_pin < 1 then
                ok = %f;
                message("Wrong DIO pin selected, use value from 1 to 32!");
            end

            if ok then
                [model,graphics,ok] = check_io(model,graphics, [], 1, 1, []);
                graphics.exprs = exprs;
                model.rpar = [];
                model.ipar = [dio_pin];
                model.dstate = [];
                x.graphics = graphics;
                x.model = model;
                break
            end
        end
    case 'define' then
        dio_pin = 1;
        model=scicos_model()
        model.sim=list('mdaq_dio_get_sim',5)
        model.in =[]
        model.outtyp=1
        model.out=1
        model.out2=1
        model.evtin=1
        model.rpar=[];
        model.ipar=[dio_pin]
        model.dstate=[];
        model.blocktype='d'
        model.dep_ut=[%t %f]
        exprs=[sci2exp(dio_pin)]
        gr_i=['xstringb(orig(1),orig(2),[''DIO'' ; string(dio_pin)],sz(1),sz(2),''fill'');']
        x=standard_define([4 3],model,exprs,gr_i)
        x.graphics.in_implicit=[];
        x.graphics.exprs=exprs;
        x.graphics.style=["blockWithLabel;verticalLabelPosition=center;displayedLabel=DIO%1$s;fontColor=#5f5f5f"]

    end
endfunction
