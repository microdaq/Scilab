function [x,y,typ] = mdaq_to_file(job,arg1,arg2)
    x=[];y=[];typ=[];

    to_file_desc = [ "To File block";
    "";
    "This block writes data to file. Files are created on user disk in";
    "''dsp/data'' directory. Files can be downloaded with web browser or";
    "mass storage interface. ";
    "";
    "In order to import file data to Scilab mdaq_get_file_data script can be used.";
    "See mdaq_get_file_data help for more.";
    "";
    "Data can be written to file in text of binary format. Depending ";
    "on selected option data can appended to previous content of the file";
    "or data will be written to empty file (Create option)";
    "To avoid time time consuming wirte operation during every";
    "simulation step block can buffer data.";
    "";
    "Block parameter ''Vector buffer size'' indicates how many vectors will";
    "e buffered. For example sample rate of block is 0.001sec, when";
    "user sets buffer size to 100, efective write to file will be performed";
    "every 0.1sec.";
    "";
    "Rising edge on Trigger input(2) will create new file. To define sequential file";
    "name use ''%d'' e.g. data_%d.txt will produce files data_0.txt, data_1.txt,...";
    "If ''%d'' isn''t included in file name data will be written to one file.";
    "";
    "Data input(1) - input data"
    "Trigger input(2) - trigger new sequential file creation"
    "";
    "Filt type:";
    "   1 - Text";
    "   2 - Binary";
    "";
    "Mode:";
    "   1 - Create";
    "   2 - Append";
    "";
    "Enter To File block parameters:"];

    select job
    case 'set' then
        x=arg1
        model=arg1.model;graphics=arg1.graphics;
        exprs=graphics.exprs;
        while %t do
            try
                getversion('scilab');
                [ok,file_name, filt_type, file_mode, vec_buff_size, vec_size,exprs]=..
                scicos_getvalue(to_file_desc,..
                ['File name:';
                'File type:';
                'Mode:';
                'Vector buffer size:';
                'Vector size:'],..
                list('str',1,'vec',1,'vec',1,'vec',1,'vec',1),exprs)
            catch
                getversion('scilab');
                [ok,file_name, filt_type, file_mode, vec_buff_size, vec_size,exprs]=..
                scicos_getvalue(to_file_desc,..
                ['File name:';
                'File type:';
                'Mode:';
                'Vector buffer size:';
                'Vector size:'],..
                list('str',1,'vec',1,'vec',1,'vec',1,'vec',1),exprs)
            end;

            if ~ok then break,end

            if filt_type > 2 | filt_type < 1 then
                ok = %f;
                message("Wrong file type, use 1 or 2!");
            end

            if file_mode > 2 | file_mode < 1 then
                ok = %f;
                message("Wrong mode, select 1 or 2!");
            end

            if length(file_name) > 64 then
                ok = %f;
                message("File name too long - 64 character max!");
            end

            if vec_buff_size > 500 then
                ok = %f;
                message("Wrong vector buffer size - 500 max!");
            end

            if vec_size > 8 then
                ok = %f;
                message("Wrong vector size - 8 max!");
            end

            if ok then
                [model,graphics,ok]=check_io(model,graphics,[vec_size 1],[],1,[])
                graphics.exprs=exprs;
                model.rpar=[]
                model.ipar=[filt_type;file_mode;vec_buff_size;vec_size;0;ascii(file_name)';0];
                model.dstate=[];
                x.graphics=graphics;x.model=model
                break
            end
        end
    case 'define' then
        file_name='data.txt'
        filt_type = 1;
        file_mode = 1;
        vec_buff_size = 100;
        vec_size = 1;

        model=scicos_model()
        model.sim=list('mdaq_to_file_sim',5)
        model.in = [1; 1]
        model.in2=[1; 1]
        model.intyp=[1; 1]
        model.out=[]
        model.evtin=1
        model.rpar=[]
        model.ipar=[filt_type;file_mode;vec_buff_size;vec_size;0;ascii(file_name)';0]
        model.dstate=[];
        model.blocktype='d'
        model.dep_ut=[%t %f]
        exprs=[sci2exp(file_name);sci2exp(filt_type);sci2exp(file_mode);sci2exp(vec_buff_size);sci2exp(vec_size)]
        gr_i=['xstringb(orig(1),orig(2),['''';file_name],sz(1),sz(2),''fill'');']
        x=standard_define([4 3],model,exprs,gr_i)
        x.graphics.in_implicit=[];
        x.graphics.style=["blockWithLabel;verticalLabelPosition=center;displayedLabel=%1$s;fontColor=#5f5f5f"]
        x.graphics.exprs=exprs;
    end
endfunction
