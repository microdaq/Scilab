function [x,y,typ] =mdaq_pru_reg_set(job,arg1,arg2)
    pru_reg_desc = ["This block sets MicroDAQ PRU real-time";
    "execution unit register.";
    "";
    "input(1) - PRU register value (uint32)";
    "";
    "PRU register: 0...15";
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
                [ok,pru_core,pru_reg,exprs]=..
                scicos_getvalue(pru_reg_desc,..
                ['PRU core:';..
                 'PRU register:'],..
                list('vec',1,'vec',1),exprs)
            catch
                [ok,pru_core,pru_reg,exprs]=..
                scicos_getvalue(pru_reg_desc,..
                ['PRU core:';..
                 'PRU register:'],..
                list('vec',1,'vec',1),exprs)
            end;

            if ~ok then
                break
            end

            if pru_reg > 15 | pru_reg < 0 then
                ok = %f;
                message("Wrong PRU register - select converter from 0 to 15!");
            end

            if pru_core > 1 | pru_core < 0 then
                ok = %f;
                message("Wrong PRU core selected - use 0 or 1!");
            end

            if ok then
                [model,graphics,ok] = check_io(model,graphics, 1, [], 1, []);
                graphics.exprs = exprs;
                model.rpar = [];
                model.ipar = [pru_core; pru_reg];
                model.dstate = [];
                x.graphics = graphics;
                x.model = model;
                break
            end
        end
    case 'define' then
        pru_reg = 0;
        pru_core = 0;
        model=scicos_model()
        model.sim=list('mdaq_pru_reg_set_sim',5)
        model.in =1
        model.in2=1
        model.intyp=1
        model.out=[]
        model.evtin=1
        model.rpar=[];
        model.ipar=[pru_core; pru_reg]
        model.dstate=[];
        model.blocktype='d'
        model.dep_ut=[%t %f]
        exprs=[sci2exp(pru_core);sci2exp(pru_reg)]
        gr_i=['xstringb(orig(1),orig(2),['''' ; ],sz(1),sz(2),''fill'');']
        x=standard_define([4 3],model,exprs,gr_i)
        x.graphics.in_implicit=[];
        x.graphics.exprs=exprs;
        x.graphics.style=["blockWithLabel;verticalLabelPosition=center;displayedLabel=R%1$s;fontColor=#5f5f5f"]
    end
endfunction
