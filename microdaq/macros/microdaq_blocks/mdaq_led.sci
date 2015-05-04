function [x,y,typ] = mdaq_led(job,arg1,arg2)
    led_desc = ["This block sets MicroDAQ LED state.";
    "";
    "LED number: 1 or 2";
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
                [ok,led_num,exprs]=..
                scicos_getvalue(led_desc,..
                ['Led:'],..
                list('vec',-1),exprs)
            catch
                [ok,led_num,exprs]=..
                scicos_getvalue('Enter LED block parameters',..
                ['Led:'],..
                list('vec',-1),exprs)
            end;

            err_message = [];

            if ~ok then
                break
            end

            if led_num > 2 | led_num < 1 then
                err_message=[err_message ;gettext("Wrong LED selected - use 1 or 2!")];
                ok=%f;
            end

            if exists('inport') then in=ones(1,1), out=[], else in=1, out=[], end
            [model,graphics,ok]=check_io(model,graphics,in,out,1,[])
            if ok then
                graphics.exprs=exprs;
                model.rpar=[]
                model.ipar=[led_num];
                model.dstate=[];
                x.graphics=graphics;
                x.model=model
                break
            else
                message(err_message);
            end
        end
    case 'define' then
        led_num=1
        model=scicos_model()
        model.sim=list('mdaq_led_sim',5)
        if exists('inport') then model.in=ones(1,1), model.out=[], else model.in=1, model.out=[], end
        model.evtin=1
        model.ipar=[led_num];
        model.dstate=[];
        model.blocktype='d'
        model.dep_ut=[%t %f]
        exprs=[sci2exp(led_num)]
        gr_i=['xstringb(orig(1),orig(2),[''D'';led_num],sz(1),sz(2),''fill'');']
        x=standard_define([4 3],model,exprs,gr_i)
        x.graphics.in_implicit=[];
        x.graphics.style=["blockWithLabel;verticalLabelPosition=center;displayedLabel=D%s;fontColor=#616161"]
        x.graphics.exprs=[string(led_num)];
    end
endfunction
