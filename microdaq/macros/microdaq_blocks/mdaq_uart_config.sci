function [x,y,typ] = mdaq_uart_config(job,arg1,arg2)
    uart_conf_desc = ["UART Config";
    "Configures the parameters of the MicroDAQ UART module for serial";
    "communication.";
    "";
    "MODULE:";
    "  0 - UART0";
    "  1 - UART1";
    "  2 - UART2";
    "";
    "Baud Rate:";
    "  0 - 2400";
    "  1 - 4800";
    "  2 - 9600";
    "  3 - 19200";
    "  4 - 38400";
    "  5 - 58600";
    "  6 - 115200";
    "";
    "Data bits: 5..8";
    "";
    "Parity:";
    "  0 - None";
    "  1 - Even";
    "  2 - Odd";
    "";
    "Stop Bits: 1 or 2";
    "";
    "Flow control:"
    "  0 - None";
    "  1 - Hardware";
    "";
    "Set UART Config block parameters:"];

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
                [ok,module,baud_rate,data_bits,parity,stop_bits,flow_control,exprs]=..
                scicos_getvalue(uart_conf_desc,..
                ['Module:';
                'Baud rate:';
                'Data bits:';
                'Parity:';
                'Stop bits:';
                'Flow control:'],..
                list('vec',1,'vec',1,'vec',1,'vec',1,'vec',1,'vec',1),exprs)
            catch
                [ok,module,baud_rate,data_bits,parity,stop_bits,flow_control,exprs]=..
                getvalue(uart_conf_desc,..
                ['Module:';
                'Baud rate:';
                'Data bits:';
                'Parity:';
                'Stop bits:';
                'Flow control:'],..
                list('vec',1,'vec',1,'vec',1,'vec',1,'vec',1,'vec',1),exprs)
            end;

            if ~ok then
                break
            end

            if module > 2 | module < 0 then
                ok = %f;
                message("Use values 0,1 or 2 to set UART module.")
            end

            if baud_rate > 6 | baud_rate < 0 then
                ok = %f;
                message("Use values 0,1,2,3,4,5 or 6 to set Baud rate.")
            end

            if data_bits > 8 | data_bits < 5 then
                ok = %f;
                message("Use values 5,6,7 or 8 to set Data bits.")
            end
           

            if parity > 2 | parity < 0 then
                ok = %f;
                message("Use values 0,1 or 2 to set Parity.")
            end

            if stop_bits > 2 | stop_bits < 1 then
                ok = %f;
                message("Use values 1 or 2 to set Stop bits.")
            end

            if flow_control > 1 | flow_control < 0 then
                ok = %f;
                message("Use values 0 or 1 to set Flow control.")
            end

            if ok then
                [model,graphics,ok] = check_io(model,graphics, [], [], [], []);
                graphics.exprs = exprs;
                model.rpar = [];
                model.ipar = [module, baud_rate+1, data_bits, parity, stop_bits, flow_control];
                model.dstate = [];
                x.graphics = graphics;
                x.model = model;
                break
            end
        end
    case 'define' then
        module = 0;
        baud_rate = 6;
        data_bits = 8;
        parity = 0;
        stop_bits = 1;
        flow_control = 0;

        model=scicos_model()
        model.sim=list('mdaq_uart_config_sci_sim',5);
        model.in =[];
        model.in2=[];
        model.intyp=[];
        model.out=[];
        model.evtin=[];
        model.rpar=[];
        model.ipar=[module, baud_rate+1, data_bits, parity, stop_bits, flow_control]
        model.dstate=[];
        model.blocktype='d'
        model.dep_ut=[%t %f]
        exprs=[sci2exp(module), sci2exp(baud_rate), sci2exp(data_bits), sci2exp(parity), sci2exp(stop_bits), sci2exp(flow_control)]
        gr_i=['xstringb(orig(1),orig(2),['''' ; ],sz(1),sz(2),''fill'');']
        x=standard_define([4 3],model,exprs,gr_i)
        x.graphics.in_implicit=[];
        x.graphics.exprs=exprs;
    end
endfunction
