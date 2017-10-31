function [x,y,typ] = mdaq_mem_read(job,arg1,arg2)
    mem_write_desc = ["This block reads data from MicroDAQ memory.";
    "Block with mdaqMemWrite function can be used to"; 
    "change Standalone and Ext model parameters. ";
    "Mode parameter sets block read behaviour.";
    "If Trigger input is enabled, rising";
    "edge on trigger input will reset data ";
    "index to defined start index.";  
    "";
    "Start index:";
    " points to beginning of memory area, range 1-(500000/vector size)";
    "";
    "Size:";
    "size of memory area, range 1-(500000/vector size)";
    "";
    "Vector size:";
    "size of input vector.";
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

                [ok,start_idx, data_size, vec_size,init_value,read_mode,trigger_input,exprs]=..
                                scicos_getvalue(mem_write_desc,..
                                ['Start index:';
                                'Size:';
                                'Vector size:';
                                'Init value:';
                                'Mode:';
                                'Trigger input:'],..
                                list('vec',1,'vec',1,'vec',1,'vec',-1,'vec',1,'vec',1),exprs)
            catch
                [ok,start_idx, data_size, vec_size,init_value,read_mode,trigger_input,exprs]=..
                scicos_getvalue(mem_write_desc,..
                                ['Start index:';
                                'Size:';
                                'Vector size:';
                                'Init value:';
                                'Mode:';
                                'Trigger input:'],..
                                list('vec',1,'vec',1,'vec',1,'vec',-1,'vec',1,'vec',1),exprs)
            end;

            if ~ok then
                break
            end

            //~2MB = 2 000 000B = 500 000  floats
            max_index = 500000/vec_size;

            if  start_idx < 1 | start_idx > max_index then
                ok = %f;
                message("Incorrect memory start index - use index from 1 to "+string(max_index));
            end

            if vec_size > 10000 | vec_size < 1 then
                ok = %f;
                message("Wrong vector size - use 10000 max!");
            end

            if data_size < 1 | data_size > (max_index-start_idx) then
                ok = %f;
                message("Incorrect size (max "+string(max_index-(start_idx-1))+")");
            end


            if read_mode > 3 | read_mode < 0 then
                ok = %f;
                message("Use 0-3 to setup read mode.");
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

            if size(init_value, '*') > 1 then
                if read_mode <> 1 then
                    ok = %f;
                    message("To use Init Value as a vec type change mode paramter to 1.");
                end
                
                if data_size <> vec_size then
                    ok = %f;
                    message("Size and Vector size have to be equal to use Init Value as a vec type.");
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
                model.ipar = [(start_idx-1);vec_size;read_mode;(data_size*vec_size);0;init_data_size;trigger_input];
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
        model.ipar=[(start_idx-1);vec_size;read_mode;data_size;0;init_data_size;0]
        model.dstate=[];
        model.blocktype='d'
        model.dep_ut=[%t %f]
        exprs=[sci2exp(start_idx);sci2exp(data_size);sci2exp(vec_size);sci2exp(init_value);sci2exp(read_mode);sci2exp(trigger_input)]
        gr_i=['xstringb(orig(1),orig(2),['''' ; ],sz(1),sz(2),''fill'');']
        x=standard_define([4 3],model,exprs,gr_i)
        x.graphics.in_implicit=[];
        x.graphics.exprs=exprs;
    end
endfunction
