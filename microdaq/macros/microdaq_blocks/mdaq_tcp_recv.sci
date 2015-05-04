function [x,y,typ] = mdaq_tcp_recv(job,arg1,arg2)
    tcp_recv_desc = ["TCP/IP Receive block";
    "Receive data over TCP/IP network. ";
    "Remote address: ip address of remote machine";
    "Port:  port of the remote machine. Valid port values are 1 to 65535";
    "Data size: up to 1024 bytes";
    "Blocking mode:";
    "   0 - non-blocking";
    "   1 - blocking";
    "Timeout: amount of time that the model will wait for the data";
    "";
    "Set TCP/IP Receive block parameters:";
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
                [ok,ip_addr, tcp_port, data_size,data_type,blocking_mode,tcp_timeout,exprs]=..
                scicos_getvalue(tcp_recv_desc,..
                ['Remote address:';
                'Port:';
                'Data size:';
                'Data type:';
                'Blocking mode:';
                'Timeout'],..
                list('str',1,'vec',1,'vec',1,'vec',1,'vec',1,'vec',1),exprs)
            catch
                [ok,ip_addr, tcp_port, data_size,data_type,blocking_mode,tcp_timeout,exprs]=..
                getvalue(tcp_recv_desc,..
                ['Remote address:';
                'Port:';
                'Data size:';
                'Data type:';
                'Blocking mode:';
                'Timeout'],..
                list('str',1,'vec',1,'vec',1,'vec',1,'vec',1,'vec',1),exprs)
            end;

            if ~ok then
                break
            end

            if tcp_port < 0 | tcp_port > 65535 then
                ok = %f;
                message("Valid port values are 1 to 65535.");
            end  
                 
            if data_size > 1024 | data_size < 1 then
                ok = %f;
                message("Incorrect data size (max 1024).");
            end
            
            if blocking_mode > 1 | blocking_mode < 0 then
                ok = %f;
                message("Use values 0 or 1 to set blocking mode.");
            end
            
            if tcp_timeout < 0 then
                ok = %f;
                message("Incorrect timeout (neagtive value).");
            end
            
            if ok then
                [model,graphics,ok] = check_io(model,graphics, [], data_size, 1, []);          
                graphics.exprs = exprs;
                model.rpar = [];
                ip_addr = part(ip_addr, [2:length(ip_addr)-1]);
                model.ipar = [blocking_mode;tcp_timeout;data_size;tcp_port;ascii(ip_addr)'];
                model.dstate = [];
                x.graphics = graphics;
                x.model = model;
                break
            end
        end

    case 'define' then
        ip_addr = '192.168.1.1';
        tcp_port = 80;
        data_size = 1;
        data_type = 1;
        blocking_mode = 1;
        tcp_timeout = 10;
        model=scicos_model()
        model.sim=list('mdaq_tcp_recv_sim',5)
        model.in =[]
        model.out=data_size;
        model.out2=1;
        model.outtyp=data_type;
        model.evtin=1
        model.rpar=[];
        model.ipar=[blocking_mode;tcp_timeout;data_size;tcp_port;ascii(ip_addr)']
        model.dstate=[];
        model.blocktype='d'
        model.dep_ut=[%t %f]
        exprs=[sci2exp(ip_addr);sci2exp(tcp_port);sci2exp(data_size);sci2exp(data_type);sci2exp(blocking_mode);sci2exp(tcp_timeout)]
        gr_i=['xstringb(orig(1),orig(2),['''' ; ],sz(1),sz(2),''fill'');']
        x=standard_define([4 3],model,exprs,gr_i)
        x.graphics.in_implicit=[];
        x.graphics.exprs=exprs;

    end
endfunction
