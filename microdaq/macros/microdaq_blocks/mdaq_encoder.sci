function [x,y,typ] = mdaq_encoder(job,arg1,arg2)
    encoder_desc = ["This block reads MicroDAQ quadrature encoder inputs.";
    "";
    "R input - reset input";
    "";
    "P output- current encoder counter value";
    "D output - direction: 0 - no motion, 1 - CW, 2 - CCW";
    "";
    "Encoder module: ENC1, ENC2";
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
                [ok,encoder_module_str,encoder_init_value,exprs]=..
                scicos_getvalue(encoder_desc,..
                ['Encoder module:';..
                 'Encoder init position:'],..
                list('str',1,'vec',1),exprs)
            catch
                [ok,encoder_module_str,encoder_init_value,exprs]=..
                scicos_getvalue(encoder_desc,..
                ['Encoder module:';..
                 'Encoder init position:'],..
                list('str',1,'vec',1),exprs)
            end

            if ~ok then
                break
            end

            encoder_module_str = convstr(encoder_module_str, 'l');
            encoder_module = strtod(part(encoder_module_str, 4:5));
            if isnan(encoder_module) == %t | part(encoder_module_str, 1:3) <> "enc" then
                ok = %f;
                message("Wrong Encoder module selected!");
            end
            
            if encoder_module > 2 | encoder_module < 1 then
                ok = %f;
                message("Wrong Encoder module selected!");
            end

            if ok then
                [model,graphics,ok] = check_io(model,graphics, [1], [1,1], 1, []);
                graphics.exprs = exprs;
                model.rpar = [];
                model.ipar = [encoder_module; encoder_init_value];
                model.dstate = [];
                x.graphics = graphics;
                x.model = model;
                break;
            end
        end
       
    case 'define' then
        encoder_module = 1;
        encoder_module_str = [];
        encoder_init_value = 0; 
        model=scicos_model()
        model.sim=list('mdaq_encoder_sim',5);
        model.in =[1];
        model.in2=[1];
        model.intyp=[1];
        model.out=[1;1];
        model.out2=[1;1];
        model.outtyp=[1;1];
        model.evtin=1;
        model.rpar=[];
        model.ipar=[encoder_module; encoder_init_value];
        model.dstate=[];
        model.blocktype='d';
        model.dep_ut=[%t %f];
        exprs=["ENC1";sci2exp(encoder_init_value)];
        gr_i=['xstringb(orig(1),orig(2),[''CH:'' ; string(encoder_module)],sz(1),sz(2),''fill'');'];
        x=standard_define([4 3],model,exprs,gr_i);
        x.graphics.in_implicit=[];
        x.graphics.exprs=exprs;
        x.graphics.style=["blockWithLabel;verticalLabelPosition=center;displayedLabel=%1$s;fontColor=#5f5f5f"]
        x.graphics.out_label = ["P", "D"];
        x.graphics.in_label = ["R"];
    end
endfunction
