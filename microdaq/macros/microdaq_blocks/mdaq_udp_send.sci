function [x,y,typ] = mdaq_udp_send(job,arg1,arg2)
    tcp_recv_desc = [
    "The UDP Send block sends data from your model";
    "to the specified remote machine using the UDP protocol.";
    "Block allows data buffering. User has to provide input";
    "signal vector size. When buffer is enabled data will be";
    "stored in block buffer and send when defined";
    "buffer end is reached. Buffer size defines how many vectors";
    "will be buffered";
    "";
    "Set UDP Send block parameters:";
    ];

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
                [ok,ip_addr, udp_port, data_size, buf_size,exprs]=..
                scicos_getvalue(tcp_recv_desc,..
                                    ['Remote address:';
                                    'Port:';
                                    'Vector size:';
                                    'Buffer size:'],..
                                    list('str',1,'vec',1,'vec',1,'vec',1),exprs)
            catch

                [ok,ip_addr, udp_port, data_size, buf_size,exprs]=..
                scicos_getvalue(tcp_recv_desc,..
                                    ['Remote address:';
                                    'Port:';
                                    'Vector size:';
                                    'Buffer size:'],..
                                    list('str',1,'vec',1,'vec',1,'vec',1),exprs)
            end;

            if ~ok then
                break
            end

            if udp_port < 0 | udp_port > 65535 then
                ok = %f;
                message("Valid port values are 1 to 65535.");
            end         

            if data_size > 1024 | data_size < 1 then
                ok = %f;
                message("Incorrect data size (max 1024).");
            end

            if ok then
                [model,graphics,ok] = check_io(model,graphics, data_size, [], 1, []);          
                graphics.exprs = exprs;
                model.rpar = [];
                ip_addr = part(ip_addr, [2:length(ip_addr)-1]);
                model.ipar = [udp_port; data_size; buf_size; ascii(ip_addr)'];
                model.dstate = [];
                x.graphics = graphics;
                x.model = model;
                break
            end
        end

    case 'define' then
        ip_addr = '10.10.1.2';
        udp_port = 9090;
        data_size = 1;
        buf_size = 1;
        model=scicos_model()
        model.sim=list('mdaq_udp_send_sim',5)
        model.in =1;
        model.out=[];
        model.intyp=1;
        model.evtin=1
        model.rpar=[];
        model.ipar=[udp_port; data_size; buf_size; ascii(ip_addr)'];
        model.dstate=[];
        model.blocktype='d'
        model.dep_ut=[%t %f]
        exprs=[sci2exp(ip_addr); sci2exp(udp_port); sci2exp(data_size); sci2exp(buf_size)]
        gr_i=['xstringb(orig(1),orig(2),['''' ; ],sz(1),sz(2),''fill'');']
        x=standard_define([4 3],model,exprs,gr_i)
        x.graphics.in_implicit=[];
        x.graphics.exprs=exprs;

    end
endfunction
