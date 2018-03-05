function [x,y,typ] = mdaq_mem_write(job,arg1,arg2)
    mem_write_desc = ["This block writes data to MicroDAQ memory.";
    "Data written by this block must be accessed with ";
    "mdaqMemRead function. It can be used in Ext and";
    "Standalone mode to access DSP data. Up to 250000";
    "values can be stored with this block. Memory used";
    "by this block can be calculated with the formula: "; 
    "Number of vectors * Vector Size ";  
    "";
    "Start index:";
    "points to beginning of memory area, range 1-250000";
    "";
    "Number of vectors:";
    "size of memory area, range 1-(250000/vector size)";
    "";
    "Vector size:";
    "size of input vector.";
    "";
    "Rewind:";
    "0 - do not write data when when end of";
    "    used memory area reached";
    "1 - when the end of used memory area reached,";
    "    write from the start index";
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
                [ok,start_idx,vec_num,vec_size,overwrite,exprs]=..
                scicos_getvalue(mem_write_desc,..
                ['Start index:';
                'Number of vectors:';
                'Vector size:';
                'Rewind:'],..
                list('vec',1,'vec',1,'vec',1,'vec',1),exprs)
            catch
                [ok,start_idx,vec_num,vec_size,overwrite,exprs]=..
                getvalue(mem_write_desc,..
                ['Start index:';
                'Size:';
                'Vector size:';
                'Rewind:'],..
                list('vec',1,'vec',1,'vec',1,'vec',1),exprs)
            end;

            if ~ok then
                break
            end

            //1MB = 1 000 000B = 250 000  floats
            MEM_MAX_DATA_SIZE = 250000; 
            max_data_size = MEM_MAX_DATA_SIZE-start_idx+1;
            data_size = vec_size*vec_num;

            if vec_num == -1 then
                vec_num = max_index - start_idx;
            end

            if  start_idx < 1 | start_idx > MEM_MAX_DATA_SIZE then
                ok = %f;
                message("Incorrect memory start index - use index from 1 to "+string(MEM_MAX_DATA_SIZE));
            end
            
            if data_size < 1 | data_size > max_data_size then
                ok = %f;
                message("Incorrect data size (min 1 / max "+string(max_data_size)+")");
            end
            
            if overwrite > 1 | overwrite < 0 then
                ok = %f;
                message("Use values 0 or 1 to set increment option.");
            end

            if ok then
                [model,graphics,ok] = check_io(model,graphics, vec_size, [], 1, []);
                graphics.exprs = exprs;
                model.rpar = [];
                model.ipar = [(start_idx-1);(data_size);vec_size;overwrite];
                model.dstate = [];
                x.graphics = graphics;
                x.model = model;
                break
            end
        end

    case 'define' then
        vec_size = 1;
        start_idx = 1;
        vec_num = 100;
        overwrite = 0;
        model=scicos_model()
        model.sim=list('mdaq_mem_write_sim',5)
        model.in=-1
        model.in2=-2
        model.out=[]
        model.evtin=1
        model.rpar=[];
        model.ipar = [(start_idx-1);vec_num;vec_size;overwrite];
        model.dstate=[];
        model.blocktype='d'
        model.dep_ut=[%t %f]
        exprs=[sci2exp(start_idx);sci2exp(vec_num);sci2exp(vec_size);sci2exp(overwrite)]
        gr_i=['xstringb(orig(1),orig(2),['''' ; ],sz(1),sz(2),''fill'');']
        x=standard_define([4 3],model,exprs,gr_i)
        x.graphics.in_implicit=[];
        x.graphics.exprs=exprs;
    end
endfunction
