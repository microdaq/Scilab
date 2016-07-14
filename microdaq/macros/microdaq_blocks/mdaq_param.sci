function [x,y,typ]=mdaq_param(job,arg1,arg2)
    x=[];
    y=[];
    typ=[]
    select job
    case "set" then
        x=arg1
        model=arg1.model;graphics=arg1.graphics;
        exprs=graphics.exprs;
        while %t do
            try
                getversion('scilab');
                [ok,signal_id,exprs]=..
                scicos_getvalue('Set Signal block parameters',..
                ['Signal ID:'],..
                list('vec',-1),exprs)
            catch
                [ok,signal_id,exprs]=..
                scicos_getvalue('Set Signal block parameters',..
                ['Signal ID:'],..
                list('vec',-1),exprs)
            end;

            err_message = [];

            if ~ok then break,end

            if ok then
                graphics.exprs=exprs;
                model.ipar=[signal_id];
                model.dstate=[];
                x.graphics=graphics;x.model=model
                break
            else
                message(err_message);
            end
        end

    case "define" then
        signal_id = 1;
        model=scicos_model()
        model.sim=list("mdaq_param_sim",5)
        model.in=-1
        model.out=-1
        model.in2=-2
        model.out2=-2
        model.intyp=1;
        model.outtyp=1;
        model.ipar = [(100-1);5;1;1];
        model.blocktype="c"
        model.dep_ut=[%t %f]
        exprs=[sci2exp(signal_id)];
        gr_i=[]
        x=standard_define([2.5 1],model,exprs,gr_i);
        x.graphics.style=["blockWithLabel;verticalLabelPosition=center;displayedLabel=PARAM;fontColor=#0000CD"]
    end
endfunction






