function [x,y,typ] = mdaq_mem_read(job,arg1,arg2)
    mem_write_desc = ["This block reads data from MicroDAQ memory.";
    "Block with mdaqMemWrite function can be used to"; 
    "change Standalone and Ext model parameters. ";
    "Mode parameter sets block read behaviour.";
    "If Trigger input is enabled, rising";
    "edge on trigger input will reset data ";
    "index to defined start index.";  
    "Block can read up to 250000 values. Block "; 
    "memory read size can be calculated by:";  
    "Number of vectors * Vector Size ";  
    "";
    "Init value:";
    "Initializes memory with provided value";
    "";
    "Mode:";
    "0 - single read, ignore init value";
    "1 - circular read, use init value";
    "2 - signle read, use init value";
    "3 - circular read, ignore init value";
    "";
    "Trigger input:";
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

                [ok,start_idx, vec_num, vec_size,init_value,read_mode,trigger_input,exprs]=..
                                scicos_getvalue(mem_write_desc,..
                                ['Start index:';
                                'Number of vectors:';
                                'Vector size:';
                                'Init value:';
                                'Mode:';
                                'Trigger input:'],..
                                list('vec',1,'vec',1,'vec',1,'vec',-1,'vec',1,'vec',1),exprs)
            catch
                [ok,start_idx, vec_num, vec_size,init_value,read_mode,trigger_input,exprs]=..
                scicos_getvalue(mem_write_desc,..
                                ['Start index:';
                                'Number of vectors:';
                                'Vector size:';
                                'Init value:';
                                'Mode:';
                                'Trigger input:'],..
                                list('vec',1,'vec',1,'vec',1,'vec',-1,'vec',1,'vec',1),exprs)
            end;

            if ~ok then
                break
            end

            //~1MB = 1 000 000B = 250 000  floats
            MEM_MAX_DATA_SIZE = 250000; 
            max_data_size = MEM_MAX_DATA_SIZE-start_idx+1;
            data_size = vec_size*vec_num;

            if  start_idx < 1 | start_idx > MEM_MAX_DATA_SIZE then
                ok = %f;
                message("Incorrect memory start index - use index from 1 to "+string(MEM_MAX_DATA_SIZE));
            end

            if vec_size > 10000 | vec_size < 1 then
                ok = %f;
                message("Wrong vector size - use 10000 max!");
            end

            if data_size < 1 | data_size > max_data_size then
                ok = %f;
                message("Incorrect data size (min 1 / max "+string(max_data_size)+")");
            end

            if read_mode > 3 | read_mode < 0 then
                ok = %f;
                message("Use 0-3 to setup read mode.");
            end

            if ok then
                init_data_size = size(init_value, '*');
                if  init_data_size > 1 then
                    if  init_data_size <> data_size then
                        message('Initial values don''t mach vector data size (vector number * vector size)!')
                        ok = %f;
                    end
                    init_value = init_value';
                end
            end

            if size(init_value, '*') > 1 then
                if read_mode <> 1 then
                    ok = %f;
                    message("To use Init Value as a vec type change mode paramter to 1.");
                end
            end 
            
            trigger_input_size = 1;
            if trigger_input <> 1 then
                trigger_input_size = []; 
                trigger_input = 0
            end
            
            if ok then
                [model,graphics,ok] = check_io(model,graphics, trigger_input_size, vec_size, 1, []);
                graphics.exprs = exprs;
                model.rpar = init_value;
                model.ipar = [(start_idx-1);vec_size;read_mode;data_size;0;init_data_size;trigger_input];
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
        vec_num = 1;
        read_mode = 1;
        init_data_size = 1; 
        trigger_input = 0;
        model=scicos_model()
        model.sim=list('mdaq_mem_read_sim',5)
        model.in =[]
        model.out=vec_size
        model.out2=1
        model.outtyp=1
        model.evtin=1
        model.rpar=[];
        model.ipar=[(start_idx-1);vec_size;read_mode;vec_num;0;init_data_size;0]
        model.dstate=[];
        model.blocktype='d'
        model.dep_ut=[%t %f]
        exprs=[sci2exp(start_idx);sci2exp(vec_num);sci2exp(vec_size);sci2exp(init_value);sci2exp(read_mode);sci2exp(trigger_input)]
        gr_i=['xstringb(orig(1),orig(2),['''' ; ],sz(1),sz(2),''fill'');']
        x=standard_define([4 3],model,exprs,gr_i)
        x.graphics.in_implicit=[];
        x.graphics.exprs=exprs;
    end
endfunction
