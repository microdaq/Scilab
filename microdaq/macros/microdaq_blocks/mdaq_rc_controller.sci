function [x,y,typ] =mdaq_rc_controller(job,arg1,arg2)
    rc_controller_desc = ["This block converts PWM signals from RC controller receiver";
	"to number. Block supports up to 4 PWM channels. In order to";
	"use block DIO25...DIO28 needs to be configured as an input.";
	"Channels: 1 - DIO25, 2 - DIO26, 3 - DIO27, 4 - DIO28";
    "";
    "Run on PRU: 0 or 1 ";
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
                [ok,pru,exprs]=..
                scicos_getvalue(rc_controller_desc,..
                ['Run on:'],..
                list('vec',1),exprs)
            catch
                [ok,pru,exprs]=..
                getvalue(rc_controller_desc,..
                ['Run on:'],..
                list('vec',1),exprs)
            end;

            if ~ok then
                break
            end

            if pru > 1 | pru < 0 then
                ok = %f;
                message("Use values 0 or 1 to set PRU.");
            end

            if ok then
                [model,graphics,ok] = check_io(model,graphics, [], [1,1,1,1], 1, []);
                graphics.exprs = exprs;
                model.rpar = [];
                model.ipar = [pru];
                model.dstate = [];
                x.graphics = graphics;
                x.model = model;
                break
            end

        end

    case 'define' then
        pru = 0;
        model=scicos_model()
        model.sim=list('mdaq_rc_controller_sim',5)
        model.in = []
        //intyp  8 - uint8
        model.out=[1;1;1;1]
        model.outtyp=[1;1;1;1]
        model.evtin=1
        model.rpar=[];
        model.ipar=[pru]
        model.dstate=[];
        model.blocktype='d'
        model.dep_ut=[%t %f]
        exprs=[sci2exp(pru)]
        gr_i=['xstringb(orig(1),orig(2),['''' ; ],sz(1),sz(2),''fill'');']
        x=standard_define([4 3],model,exprs,gr_i)
        x.graphics.in_implicit=[];
        x.graphics.exprs=exprs;
    end
endfunction
