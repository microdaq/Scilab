function [x,y,typ] =mdaq_uart_read(job,arg1,arg2)
    uart_recv_desc = ["UART read";
    "This block receives data from MicroDAQ UART port. Block supports";
    "blocking and non-blocking mode. Block allows data sync with";
    "transmiter by 32bit data containing user defined value. If ''Use sync";
    "data'' is enabled data output will return data stream after 32bit sync";
    "blocking and non-blocking mode. Block allows data sync with";
    "value.";
    "";
    "Max data size is 512 bytes.";
    "";
    "MODULE:";
    "  0 - UART0";
    "  1 - UART1";
    "  2 - UART2";
    "";
    "Use sync data:";
    "  0 - false";
    "  1 - true";
    "";
    "Enable blocking mode:";
    "  0 - false";
    "  1 - true";
    "";
    "Set UART recv block parameters:"];

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
                [ok,module, data_size, use_sync,sync_data,enable_blocking,timeout,exprs]=..
                scicos_getvalue(uart_recv_desc,..
                ['Module:';
                'Data size:';
                'Use sync data:';
                'Sync data (32bit hex):';
                'Enable blocking mode';
                'Timeout (miliseconds):'],..
                list('vec',1,'vec',1,'vec',1,'str',1,'vec',1,'vec',1),exprs)
            catch
                [ok,module, data_size, use_sync,sync_data,enable_blocking,timeout,exprs]=..
                getvalue(uart_recv_desc,..
                ['Module:';
                'Data size:';
                'Use sync data:';
                'Sync data (32bit hex):';
                'Enable blocking mode';
                'Timeout (miliseconds):'],..
                list('vec',1,'vec',1,'vec',1,'str',1,'vec',1,'vec',1),exprs)
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
            
            if use_sync > 1 | use_sync < 0 then
                ok = %f;
                message("Use values 0 or 1 to set ''Use sync data''.");
            end
            
            if enable_blocking > 1 | enable_blocking < 0 then
                ok = %f;
                message("Use values 0 or 1 to set ''Enable blocking mode''.");
            end
            
            if timeout < 0 then
                timeout = 100;
            end

            if ok then
                [model,graphics,ok] = check_io(model,graphics, [], [data_size,1], 1, []);
                graphics.exprs = exprs;
                model.rpar = [];
                model.ipar = [module;data_size;use_sync;hex2dec(sync_data);enable_blocking;timeout];
                model.dstate = [];
                x.graphics = graphics;
                x.model = model;
                break
            end

        end

    case 'define' then
        module = 0;
        data_size = 16;
        use_sync = 0;
        sync_data = "7161646d";
        enable_blocking = 0;
        timeout = 100;
        model=scicos_model()
        model.sim=list('mdaq_uart_read_sim',5)
        model.in = []
        //intyp  8 - uint8
        model.out=[data_size;1]
        model.outtyp=[8;3]
        model.evtin=1
        model.rpar=[];
        model.ipar=[module;data_size;use_sync;hex2dec(sync_data);enable_blocking;timeout]
        model.dstate=[];
        model.blocktype='d'
        model.dep_ut=[%t %f]
        exprs=[sci2exp(module);sci2exp(data_size);sci2exp(use_sync);sync_data;sci2exp(enable_blocking);sci2exp(timeout)]
        gr_i=['xstringb(orig(1),orig(2),['''' ; ],sz(1),sz(2),''fill'');']
        x=standard_define([4 3],model,exprs,gr_i)
        x.graphics.in_implicit=[];
        x.graphics.exprs=exprs;
    end
endfunction
