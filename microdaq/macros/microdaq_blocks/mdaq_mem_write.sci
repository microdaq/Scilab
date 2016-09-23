function [x,y,typ] = mdaq_mem_write(job,arg1,arg2)
    mem_write_desc = ["This block writes data to MicroDAQ memory.";
    "Block with mdaq_mem_get function can be used ";
    "to get data from Standalone and Ext model.";
    "";
    "Start index:";
    "points to beginning of memory area, range 0-4000000";
    "";
    "Size:";
    "size of memory area, range 0-4000000";
    "";
    "Vector size:";
    "size of input vector.";
    "";
    "FIFO:";
    "0 - disabled";
    "1 - enabled";
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
                [ok,start_idx,data_size,vec_size,overwrite,exprs]=..
                scicos_getvalue(mem_write_desc,..
                ['Start index:';
                'Size';
                'Vector size:';
                'FIFO:'],..
                list('vec',1,'vec',1,'vec',1,'vec',1),exprs)
            catch
                [ok,start_idx,data_size,vec_size,overwrite,exprs]=..
                getvalue(mem_write_desc,..
                ['Start index:';
                'Size:';
                'Vector size:';
                'FIFO:'],..
                list('vec',1,'vec',1,'vec',1,'vec',1),exprs)
            end;

            if ~ok then
                break
            end

            //~16MB = 16 000 000B = 4 000 000 floats
            max_index = 4000000;

            if data_size == -1 then
                data_size = max_index - start_idx;
            end

            if  start_idx < 1 | start_idx > max_index then
                ok = %f;
                message("Incorrect start index. Shared memory is idexing from 1 to "+string(max_index));
            end


            if data_size < 1 | data_size > (max_index-start_idx) then
                ok = %f;
                message("Incorrect size (max "+string(max_index-start_idx)+")");
            end
            
            size_mod = modulo(data_size, vec_size)
            if size_mod <> 0  then
                ok = %f;
                message("Incorrect size. Size is not multiple of array size!");
            end


            if overwrite > 1 | overwrite < 0 then
                ok = %f;
                message("Use values 0 or 1 to set increment option.");
            end

            if ok then
                [model,graphics,ok] = check_io(model,graphics, vec_size, [], 1, []);
                graphics.exprs = exprs;
                model.rpar = [];
                model.ipar = [(start_idx-1);data_size;vec_size;overwrite];
                model.dstate = [];
                x.graphics = graphics;
                x.model = model;
                break
            end
        end

    case 'define' then
        vec_size = 1;
        start_idx = 1;
        data_size = 100;
        overwrite = 0;
        model=scicos_model()
        model.sim=list('mdaq_mem_write_sim',5)
        model.in=-1
        model.in2=-2
        model.out=[]
        model.evtin=1
        model.rpar=[];
        model.ipar = [(start_idx-1);data_size;vec_size;overwrite];
        model.dstate=[];
        model.blocktype='d'
        model.dep_ut=[%t %f]
        exprs=[sci2exp(start_idx);sci2exp(data_size);sci2exp(vec_size);sci2exp(overwrite)]
        gr_i=['xstringb(orig(1),orig(2),['''' ; ],sz(1),sz(2),''fill'');']
        x=standard_define([4 3],model,exprs,gr_i)
        x.graphics.in_implicit=[];
        x.graphics.exprs=exprs;
    end
endfunction
