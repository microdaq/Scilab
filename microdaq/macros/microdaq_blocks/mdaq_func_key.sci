function [x,y,typ] = mdaq_func_key(job,arg1,arg2)
    func_key_desc = ["This block reads MicroDAQ function key state (F1/F2).";
    "";
    "Function key: F1, F2";
     "";   
    "Set block parameters:"];

    x=[];y=[];typ=[];
    select job
    case 'set' then
        x=arg1
        model=arg1.model;graphics=arg1.graphics;
        exprs=graphics.exprs;
        while %t do
            try
                getversion('scilab');
                [ok,func_key,exprs]=..
                scicos_getvalue(func_key_desc,..
                ['Function key:'],..
                list('vec',1),exprs)
            catch
                [ok,func_key,exprs]=..
                scicos_getvalue(func_key_desc,..
                ['Function key:'],..
                list('vec',1),exprs)
            end;

            if ~ok then
                break
            end

            if func_key > 2 | func_key < 1 then
                ok = %f;
                message("Wrong function key number, use 1 or 2!");
            end

            if ok then
                [model,graphics,ok]=check_io(model,graphics,[],1,1,[])
                graphics.exprs=exprs;
                model.rpar=[];
                model.ipar=[func_key];
                model.dstate=[];
                x.graphics=graphics;x.model=model
                x.graphics.style=["mdaq_func_key;blockWithLabel;verticalLabelPosition=center;displayedLabel=F%1$s;fontColor=#5f5f5f"]
                break
            end
        end

    case 'define' then
        func_key = 1;
        model=scicos_model()
        model.sim=list('mdaq_func_key_sim',5)
        model.in =[]
        model.out=[1]
        model.out2=[1]
        model.outtyp=[1]
        model.evtin=1
        model.rpar=[]
        model.ipar=[func_key]
        model.dstate=[];
        model.blocktype='d'
        model.dep_ut=[%t %f]
        exprs=[sci2exp(func_key)];
        gr_i=['xstringb(orig(1),orig(2),[''F'';string(func_key)],sz(1),sz(2),''fill'');']
        x=standard_define([4 3],model,exprs,gr_i)
        x.graphics.in_implicit=[];
        x.graphics.exprs=exprs;
        x.graphics.style=["blockWithLabel;verticalLabelPosition=center;displayedLabel=F%1$s;fontColor=#5f5f5f"]
    end
endfunction
