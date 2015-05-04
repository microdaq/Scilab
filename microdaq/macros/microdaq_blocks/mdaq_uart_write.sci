function [x,y,typ] =mdaq_uart_write(job,arg1,arg2)
    uart_send_desc = ["UART write";
    "This block sends data using MicroDAQ UART interface.";
    "";
    "Max data size is 512 bytes.";
    "";
    "MODULE:";
    "  0 - UART0";
    "  1 - UART1";
    "  2 - UART2";
    "";
    "Set UART Send block parameters:"];

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
                [ok,module, data_size,exprs]=..
                scicos_getvalue(uart_send_desc,..
                ['Module:';
                 'Data Size:'],..
                list('vec',1,'vec',1),exprs)
            catch
                [ok,module,data_size,exprs]=..
                getvalue(uart_send_desc,..
                ['Module:';
                 'Data Size:'],..
                 list('vec',1,'vec',1),exprs)
            end;

            if ~ok then
                break
            end

            if module > 2 | module < 0 then
                ok = %f;
                message("Use values 0,1 or 2 to set UART module.");
            end
            
            if data_size > 512 | data_size < 0 then
                ok = %f;
                message("Incorrect Data size. (max 512)");
            end

            if ok then
                [model,graphics,ok] = check_io(model,graphics, data_size, [], 1, []);
                graphics.exprs = exprs;
                model.rpar = [];
                model.ipar = [module;data_size];
                model.dstate = [];
                x.graphics = graphics;
                x.model = model;
                break
            end
        end

    case 'define' then
        module = 0;
        data_size = 16;
        model=scicos_model()
        model.sim=list('mdaq_uart_write_sim',5)
        model.in = data_size;
        //intyp  8 - uint8
        model.intyp=8
        model.out=[]
        model.evtin=1
        model.rpar=[];
        model.ipar=[module; data_size]
        model.dstate=[];
        model.blocktype='d'
        model.dep_ut=[%t %f]
        exprs=[sci2exp(module);sci2exp(data_size)]
        gr_i=['xstringb(orig(1),orig(2),['''' ; ],sz(1),sz(2),''fill'');']
        x=standard_define([4 3],model,exprs,gr_i)
        x.graphics.in_implicit=[];
        x.graphics.exprs=exprs;
    end
endfunction
