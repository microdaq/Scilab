function [x,y,typ] = mdaq_to_file(job,arg1,arg2)
    x=[];y=[];typ=[];

    to_file_desc = [ "To File block";
    "";
    "This block writes data to file. Files are stored on user disk in";
    "''dsp/data'' directory. Function mdaqFileData can be used to load";
    "data into Scilab workspace from file created with ''To file'' block.";
    "";
    "Block supports text and binary files. Text (CSV) files can be viewed";
    "with file browser from MicroDAQ web interface without download.";
    "";
    "Depending on the selected option data can appended to previous content";
    "of the file or data will be written to empty file (Create option)";
    "To avoid time time consuming wirte operation during every";
    "simulation step block can buffer data.";
    "";
    "Block allows sequential file creation for large data sets or events.";
    "Rising edge on Trigger input(2) will create new file. To define"; 
    "sequential file name use ''%d'' in the file name  e.g. data_%d.txt";
    "will create files data_0.csv, data_1.csv. If ''%d'' isn''t included"
    "in file name single file will be used.";
    "";
    "Trigger input has to be connected with a signal, if a sequential file is ";
    "not used, the constant block with value 1 shall be connected."; 
    "";
    "D input - data input"
    "T input - trigger new sequential file creation"
    "";
    "File type:";
    "   1 - CSV";
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
                [ok,file_name, filt_type, file_mode, vec_size,exprs]=..
                scicos_getvalue(to_file_desc,..
                ['File name:';
                'File type:';
                'Mode:';
                'Vector size:'],..
                list('str',1,'vec',1,'vec',1,'vec',1),exprs)
            catch
                getversion('scilab');
                [ok,file_name, filt_type, file_mode, vec_size,exprs]=..
                scicos_getvalue(to_file_desc,..
                ['File name:';
                'File type:';
                'Mode:';
                'Vector size:'],..
                list('str',1,'vec',1,'vec',1,'vec',1),exprs)
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

            if vec_size > 8 then
                ok = %f;
                message("Wrong vector size - 8 max!");
            end

            if ok then
                [model,graphics,ok]=check_io(model,graphics,[vec_size 1],[],1,[])
                graphics.exprs=exprs;
                model.rpar=[]
                model.ipar=[filt_type;file_mode;0;vec_size;0;ascii(file_name)';0];
                model.dstate=[];
                x.graphics=graphics;x.model=model
                break
            end
        end
    case 'define' then
        file_name='data.csv'
        filt_type = 1;
        file_mode = 1;
        vec_size = 1;
        model=scicos_model()
        model.sim=list('mdaq_to_file_sim',5)
        model.in = [1; 1]
        model.in2=[1; 1]
        model.intyp=[1; 1]
        model.out=[]
        model.evtin=1
        model.rpar=[]
        model.ipar=[filt_type;file_mode;0;vec_size;0;ascii(file_name)';0]
        model.dstate=[];
        model.blocktype='d'
        model.dep_ut=[%t %f]
        exprs=[sci2exp(file_name);sci2exp(filt_type);sci2exp(file_mode);sci2exp(vec_size)]
        gr_i=['xstringb(orig(1),orig(2),['''';file_name],sz(1),sz(2),''fill'');']
        x=standard_define([4 3],model,exprs,gr_i)
        x.graphics.in_implicit=[];
        x.graphics.style=["blockWithLabel;verticalLabelPosition=center;displayedLabel=%1$s;fontColor=#5f5f5f"]
        x.graphics.in_label = ["D"; "T"];
        x.graphics.exprs=exprs;
    end
endfunction
