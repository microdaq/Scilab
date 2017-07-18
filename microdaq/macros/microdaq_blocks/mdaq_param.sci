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
                [ok,param_id,exprs]=..
                scicos_getvalue('Set Param block parameters',..
                ['Param id (1-16):'],..
                list('vec',1),exprs)
            catch
                [ok,param_id,exprs]=..
                scicos_getvalue('Set Param block parameters',..
                ['Param id (1-16):'],..
                list('vec',1),exprs)
            end;

            err_message = [];

            if ~ok then break,end
            
            if ((param_id - int(param_id)) <> 0.0) | (param_id > 16) | (param_id < 1) then
                ok = %f;
                message("Wrong param id, use integer value from 1 to 16!");
            end 
           
            if ok then
                graphics.exprs=exprs;
                model.ipar=[param_id-1];
                model.dstate=[];
                x.graphics=graphics;x.model=model
                break
            else
                message(err_message);
            end
        end

    case "define" then
        param_id = 1;
        model=scicos_model()
        model.sim=list("mdaq_param_sim",5)
        model.in=-1
        model.out=-1
        model.in2=-2
        model.out2=-2
        model.intyp=1;
        model.outtyp=1;
        model.ipar = [param_id-1];
        model.blocktype="c"
        model.dep_ut=[%t %f]
        exprs=[sci2exp(param_id)];
        gr_i=[]
        x=standard_define([2.5 1],model,exprs,gr_i);
        x.graphics.style=["blockWithLabel;verticalLabelPosition=center;displayedLabel=PARAM;fontColor=#0000CD"]
    end
endfunction






