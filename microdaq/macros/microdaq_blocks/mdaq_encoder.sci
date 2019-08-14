function [x,y,typ] = mdaq_encoder(job,arg1,arg2)
    encoder_desc = ["This block reads MicroDAQ encoder module counter.";
    "By default module is configured to work as quadrature encoder,";
    "it uses x4 mode to decode quadrature signal. Enhanced ENC1/ENC2 modules";
    "can decode signals with frequency up to 20Mhz. Block allows mode";
    "selection and defining initialization value which will be used at the";
    "start and when on Reset input value of 1 is applied.";
    "";
    "ENC3/ENC4 modules shall be used only if AO scanning is not used.";
    "The maximum frequency of applied signal is 100kHz. ENC3/ENC4 supports"; 
    "only quadrature couter mode, initialization value and reset input are";
    "not supported";
    "";
    "In quadreture mode ENCx_A and ENCx_B are used to decode two square";
    "waveform signals, depending on signal phrase counter is incremented";
    "or decremented. In direction count mode based on ENCx_B state counter"; 
    "counts down(0) or up(1). Module captures rising edges of the signal";
    "applied on ENCx_A. Up and down count mode captures rising edges on ENCx_A ";
    "increments or decrement module counter";
    "";
    "Encoder ENC1/ENC2(only) mode:";
    "0 - quadrature (ENC1_A - signal, ENCx_B - signal)";    
    "1 - direction count (ENC1_A - signal, ENCx_B - direction input)";    
    "2 - up count (ENC1_A - signal, ENCx_B - not used)";    
    "3 - down count (ENC1_A - signal, ENCx_B - not used)";    
    "";
    "In order to use ENC1/2/3/4 configure DIO lines as following:";
    "ENC1 - DIO1/2 - function: DIO, direction: input";
    "ENC2 - DIO3/4 - function: DIO, direction: input";
    "ENC3 - DIO5/6 - function: DIO, direction: input (quadrature only)";
    "ENC4 - DIO7/8 - function: DIO, direction: input (quadrature only)";
    "";
    "Reset (R) input reset counter to initialization value when";
    "value of 1 is applied"
    "";
    "P output- encoder counter value";
    "D output - direction: 0 - no change, 1 - increment, 2 - decrement";
    "";
    "Encoder module: ENC1, ENC2, ENC3, ENC4";
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
                [ok,encoder_module_str, encoder_mode, encoder_init_value,exprs]=..
                scicos_getvalue(encoder_desc,..
                ['Encoder module:';..
                 'Mode:';..
                 'Initialization value:'],..
                list('str',1,'vec',1,'vec',1),exprs)
            catch
                [ok,encoder_module_str, encoder_mode, encoder_init_value,exprs]=..
                scicos_getvalue(encoder_desc,..
                ['Encoder module:';..
                 'Mode:';..
                 'Initialization value:'],..
                list('str',1,'vec',1,'vec',1),exprs)
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
            
            if encoder_module > 4 | encoder_module < 1 then
                ok = %f;
                message("Wrong Encoder module selected!");
            end

            if encoder_mode > 3 | encoder_mode < 0 then
                ok = %f;
                message("Wrong Encoder mode!");
            end

            if ok then
                [model,graphics,ok] = check_io(model,graphics, [1], [1,1], 1, []);
                graphics.exprs = exprs;
                model.rpar = [];
                model.ipar = [encoder_module; encoder_init_value; encoder_mode];
                model.dstate = [];
                x.graphics = graphics;
                x.model = model;
                x.graphics.style=["mdaq_encoder;blockWithLabel;verticalLabelPosition=center;displayedLabel=%1$s;fontColor=#5f5f5f"]
                break;
            end
        end
    case 'define' then
        encoder_module = 1;
        encoder_mode = 0;
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
        model.ipar=[encoder_module; encoder_init_value; encoder_mode];
        model.dstate=[];
        model.blocktype='d';
        model.dep_ut=[%t %f];
        exprs=["ENC1";sci2exp(encoder_init_value);sci2exp(encoder_mode)];
        gr_i=['xstringb(orig(1),orig(2),[''CH:'' ; string(encoder_module)],sz(1),sz(2),''fill'');'];
        x=standard_define([4 3],model,exprs,gr_i);
        x.graphics.in_implicit=[];
        x.graphics.exprs=exprs;
        x.graphics.style=["blockWithLabel;verticalLabelPosition=center;displayedLabel=%1$s;fontColor=#5f5f5f"]
        x.graphics.out_label = ["P", "D"];
        x.graphics.in_label = ["R"];
    end
endfunction
