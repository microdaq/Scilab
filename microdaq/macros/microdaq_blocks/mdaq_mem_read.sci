function [x,y,typ] = mdaq_mem_read(job,arg1,arg2)
    mem_write_desc = ["This block reads data from MicroDAQ memory.";
    "Block with mdaq_mem_set function can be used to"; 
    "change Standalone and Ext model parameters";
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
                [ok,start_idx, data_size, vec_size,init_value,do_increment,exprs]=..
                scicos_getvalue(mem_write_desc,..
                ['Start index:';
                'Size:';
                'Vector size:';
                'Init value:';
                'Cilcular:'],..
                list('vec',1,'vec',1,'vec',1,'vec',-1,'vec',1),exprs)
            catch
                [ok,start_idx, data_size,vec_size,init_value,do_increment,exprs]=..
                getvalue(mem_write_desc,..
                ['Start index:';
                'Size';
                'Vector size:';
                'Init value:';
                'Cilcular:'],..
                list('vec',1,'vec',1,'vec',1,'vec',-1,'vec',1),exprs)
            end;

            if ~ok then
                break
            end

            //~4MB = 1 000 000 floats
            max_index = 1000000;

            if  start_idx < 1 | start_idx > max_index then
                ok = %f;
                message("Incorrect memory start index - use index from 1 to "+string(max_index));
            end

            if vec_size > 10000 | vec_size < 1 then
                ok = %f;
                message("Wrong vector size - use 10000 max!");
            end

            size_mod = modulo(data_size, vec_size)
            if size_mod <> 0  then
                ok = %f;
                message("Incorrect size. Size is not multiple of array size!");
            end

            if data_size < 1 | data_size > (max_index-start_idx) then
                ok = %f;
                message("Incorrect size (max "+string(max_index-start_idx)+")");
            end


            if do_increment > 1 | do_increment < 0 then
                ok = %f;
                message("Use 0 or 1 to setup cilcular read option.");
            end

            if ok then
                init_data_size = size(init_value, '*');
                if  init_data_size > 1 then
                    if  init_data_size <> vec_size  then
                        message('Initial values don''t mach vector data!')
                        ok = %f;
                    end
                    init_value = init_value';
                end
            end

            if ok then
                [model,graphics,ok] = check_io(model,graphics, [], vec_size, 1, []);
                graphics.exprs = exprs;
                model.rpar = init_value;
                model.ipar = [(start_idx-1);vec_size;do_increment;data_size;0;init_data_size];
                model.dstate = [];
                x.graphics = graphics;
                x.model = model;
                break
            end
        end

case 'define' then
        start_idx = 1;
        vec_size = 1;
        init_value = 0; 
        data_size = 1;
        do_increment = 1;
        init_data_size = 1; 
        model=scicos_model()
        model.sim=list('mdaq_mem_read_sim',5)
        model.in =[]
        model.out=vec_size
        model.out2=1
        model.outtyp=1
        model.evtin=1
        model.rpar=[];
        model.ipar=[(start_idx-1);vec_size;do_increment;data_size;0;init_data_size]
        model.dstate=[];
        model.blocktype='d'
        model.dep_ut=[%t %f]
        exprs=[sci2exp(start_idx);sci2exp(data_size);sci2exp(vec_size);sci2exp(init_value);sci2exp(do_increment)]
        gr_i=['xstringb(orig(1),orig(2),['''' ; ],sz(1),sz(2),''fill'');']
        x=standard_define([4 3],model,exprs,gr_i)
        x.graphics.in_implicit=[];
        x.graphics.exprs=exprs;
    end
endfunction
