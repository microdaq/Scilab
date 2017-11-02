function mdaqBlockAdd(block_def)
    // Check version compatibility 
    [is_supp vers] = mdaq_is_working('mdaqBlockAdd');
    if is_supp == %F then
        error('ERROR: ' + vers)
        return;
    end
    
    if type(block_def) <> 17 then
        disp("ERROR: Wrong type of input argument!");
        if type(block_def) == 13 then
            disp("Input argument type is function - use ''block = mdaqBlock()'' instead of ''block = mdaqBlock''")
        else
            disp("Use mdaqBlock() function to create initialized block sctructure!")
        end
        return;
    end

    if size(block_def.in, 'r' ) > 1 then
        if size(block_def.in, 'c' ) > 1 then
            disp("ERROR: Wrong block ''in'' parameter - one dimentional array expected!");
            return;
        end
        block_def.in = block_def.in';
    end

    if size(block_def.out, 'r' ) > 1 then
        if size(block_def.out, 'c' ) > 1 then
            disp("ERROR: Wrong block ''out'' parameter - one dimentional array expected!")
            return;
        end
        block_def.out = block_def.out';
    end

    if length(block_def.name) > 20 then
        disp("ERROR: Block name too long!");
        return;
    end
    
    FORCE_SIM = %F;
    if haveacompiler() == %F & block_def.use_sim_script == %F then 
        warning("Compiler not found.");
        warning("This block will use simulation script instead of C code during simulation mode.");
        FORCE_SIM = %T;
    end

    path = dirname(get_function_path('mdaqBlockAdd')) + filesep();
    module_path = part(path,1:length(path)-length("macros") - 1 );
    SCRIPT_FILE_ROOT = path + 'user_blocks' + filesep();
    C_FILE_ROOT = module_path+'src'+filesep()+'c'+ filesep()+'userlib'+filesep();
    IMAGE_FILE_ROOT = module_path + filesep() + 'images' + filesep();

    // =============================PREPARE INPUT=====================================
    params_size = max(size(block_def.param_name));
    params_size_size = max(size(block_def.param_size));
    params_def_val_size = max(size(block_def.param_def_val));
    in_size = max(size(block_def.in));
    out_size = max(size(block_def.out));

    if block_def.in(1) < 1 then
        in_size = 0;
    end

    if block_def.out(1) < 1 then
        out_size = 0;
    end

    //If user did not enter enough information about size of parameters then
    //we set it to default 1.
    if params_size > params_size_size then
        sizes = ones(1:params_size)';
        sizes(1:params_size_size) = block_def.param_size;
        block_def.param_size = sizes;
    end

    //If user did not enter enough information about default parameters value then
    //we set it to default 0.
    def_val = list();
    for i=1:params_size
        def_val(i) = zeros(1:block_def.param_size(i))';

        if i <= params_def_val_size then
            i_params_def_val_size = max(size(block_def.param_def_val(i)));
            def_val(i)(1:i_params_def_val_size) = block_def.param_def_val(i);
        end
    end

    block_def.param_def_val = def_val;

    // if block name changed without desc - change block name in desc
    if block_def.desc == "Set new_block parameters" then
        block_def.desc = strsubst(block_def.desc, "new_block", block_def.name);
    end

    // =============================GENERATE STRINGS=====================================
    // converted params
    params_converted = '';

    // script file
    params_string1 = '';
    params_string2 = '';
    params_string3 = '';
    params_string4 = '';
    params_string5 = '';

    //default values string
    params_string6 = '';

    // C file
    in_ports_string = '';
    out_ports_string = '';
    params_c_string = '';
    params_sci_string = '';

    name_converted = convstr(block_def.name,'l');
    name_converted = strsubst(name_converted, ' ', '_');
    if name_converted == 'sim' then
        name_converted = name_converted + '1';
        error("Block name '"sim'" is reserved.");
    end
    name_converted = 'mdaq_' + name_converted;

    for i = 1:params_size
        // Remove spaces and convert to lower case
        params_converted(i) = convstr(block_def.param_name(i),'l')
        params_converted(i) = strsubst(params_converted(i), ' ', '_')
        params_converted(i) = strsubst(params_converted(i), ';', '_')
        params_converted(i) = strsubst(params_converted(i), ':', '_')
        params_converted(i) = strsubst(params_converted(i), ',', '_')
        params_converted(i) = strsubst(params_converted(i), '.', '_')

        params_string1 = params_string1 + params_converted(i)+',';
        params_string2 = params_string2 + ''''+block_def.param_name(i)+':'';';
        disp(params_string2)
        params_string3 = params_string3 + '''vec'','+ string(block_def.param_size(i)) + ',';
        params_string4 = params_string4 + 'sci2exp(' + params_converted(i) + ');';
        params_string5 = params_string5 + params_converted(i)+';';

        i_def_param_size = max(size(block_def.param_def_val(i)));
        i_param_def_string = '';

        for j = 1:block_def.param_size(i)
            i_param_def_string = i_param_def_string + string(block_def.param_def_val(i)(j))+';';
        end

        //default values string
        params_string6(i) = '       '+params_converted(i)+' = ['+i_param_def_string+'];';

    end

    //delete last character ','
    params_string3 = part(params_string3, 1:(length(params_string3)-1) );

    in_string = '';
    out_string = '';

    if  in_size > 0 then 
        for i = 1:(in_size-1)
            in_string = in_string + string(block_def.in(i)) + ';';
        end
        in_string = in_string + string(block_def.in(in_size));
    end

    if  out_size > 0 then 
        for i = 1:(out_size-1)
            out_string = out_string + string(block_def.out(i)) + ';';
        end
        out_string = out_string + string(block_def.out(out_size));
    end 


    block_v_size = 3;
    if max([out_size in_size]) > 2 then
        block_v_size = block_v_size + (max([out_size in_size]) - 2); 
    end

    block_h_size = 4;
    if length(block_def.name) > 8 then
        block_h_size = block_h_size + ((length(block_def.name) - 8) * 0.2);
    end

    // =============================GENERATE SCRIPT=====================================
    // TODO define default params value
    //  (block_def.name).sci script generator
    block_script = [
    '// Generated with MicroDAQ toolbox ver: ' + mdaq_version() + '';
    'function [x,y,typ] = '+ name_converted + '(job,arg1,arg2)';
    '   block_desc = [''' + block_def.desc + ''';';
    '   '''';]';
    '';
    '   x=[];y=[];typ=[];';
    '   select job';
    '   case ''set'' then';
    '       x=arg1;';];
  
    if params_size > 0 then
        block_script = [block_script; 
        '       model=arg1.model;';
        '       graphics=arg1.graphics;';
        '       exprs=graphics.exprs;';
        '';
        '       while %t do';
        '           try';
        '               getversion(''scilab'');';
        '               [ok,'+params_string1+'exprs]=..'
        '               scicos_getvalue( block_desc,..';
        '               ['+params_string2+'],..';
        '               list('+params_string3+'), exprs)';
        '           catch';
        '               [ok,'+params_string1+'exprs]=..'
        '               getvalue(block_desc,..';
        '               ['+params_string2+'],..';
        '               list('+params_string3+'), exprs);';
        '           end;';
        '';
        '       if ~ok then';
        '              break';
        '       end';
        '';
        '       if ok then';
        '           [model,graphics,ok] = check_io(model,graphics, ['+in_string+'], ['+out_string+'], 1, []);';
        '           graphics.exprs = exprs;';
        '           model.rpar = ['+params_string5+'];';
        '           model.ipar = [];';
        '           model.dstate = [];';
        '           x.graphics = graphics;';

        '           x.model = model;';
        '           break';
        '       end';
        '';
        '   end'];
    end
    
     use_sim_string = [
            '       if c_link('''+name_converted+''') then';
            '           model.sim=list('''+name_converted+''',4);';
            '       else';
            '           model.sim=list('''+name_converted+'_sim'',5);';
            '           warning(''Cannot link '''''+name_converted+''''' C function. Script '''''+name_converted+'_sim.sci'''' will be used instead.'');';
            '       end';
    ];
    
    if block_def.use_sim_script == %T then
       use_sim_string = '       model.sim=list('''+name_converted+'_sim'',5);';  
    end
    
    block_script = [block_script; '   case ''define'' then';
    params_string6;
    '       model=scicos_model();';
    use_sim_string;
    '       model.in=['+in_string+'];';
    '       model.in2=1;';
    '       model.out=['+out_string+'];';
    '       model.out2=1;';
    '       model.outtyp=1;';
    '       model.intyp=1;';
    '       model.evtin=1;';
    '       model.rpar=['+params_string5+'];';
    '       model.ipar=[];';
    '       model.dstate=[];';
    '       model.blocktype=''d'';';
    '       model.dep_ut=[%t %f];';
    '       exprs=['+params_string4+'];';
    '       gr_i=[''xstringb(orig(1),orig(2),['''''''' ; ],sz(1),sz(2),''''fill'''');''];';
    '       x=standard_define([' + string(block_h_size) + ' '+string(block_v_size)+'],model,exprs,gr_i);';
    '       x.graphics.in_implicit=[];';
    '       x.graphics.exprs=exprs;';
    '       x.graphics.style=[""blockWithLabel;verticalLabelPosition=center;displayedLabel=' + block_def.name + '""]';
    '   end';
    'endfunction';
    ];

    // =============================GENERATE SIM SCRIPT=====================================
    
    index = 0;
    n_lines = 1;
    l = 1;
    for i = 1:n_lines:(params_size*n_lines)
        params_sci_string(i+1) =  '    '+params_converted(l)+' = block.rpar('+string(index + 1)+');';
        index = index + block_def.param_size(l);
        l = l + 1;
    end
    //  (block_def.name)_sim.sci script generator
    init_string = '';
    if FORCE_SIM == %T then
        init_string = [
'           mprintf('"\nWARNING: The '''''+name_converted+''''' block uses '''''+name_converted+'_sim.sci'''' script instead of C code during\n\t simulation mode. '');';
'           mprintf('"Make sure that the valid compiler is installed. More information is available at:\n'');';
'           mprintf('"\t https://help.scilab.org/doc/5.5.2/en_US/supported_compilers.html'');';
        ];
    end
    
    block_script_sim = [
    '// Generated with MicroDAQ toolbox ver: ' + mdaq_version() + '';
    'function block='+name_converted+'_sim(block,flag)';
    '';
    '    global %microdaq';
    '    if %microdaq.dsp_loaded == %F then';
    params_sci_string;
    '    select flag';
    '       case -5 // Error';
    '       case 0 // Derivative State Update';
    '       case 1 // Output Update';
    '       case 2 // State Update';
    '       case 3 // OutputEventTiming';
    '       case 4 // Initialization';
    init_string;
    '       case 5 // Ending';
    '       case 6 // Re-Initialisation';
    '       case 9 // ZeroCrossing';
    '       else // Unknown flag';
    '       break';
    '    end';
    'end';
    'endfunction';
    ];

    // save scripts
    file_name = SCRIPT_FILE_ROOT+name_converted+'.sci';
    save_string(file_name, block_script);

    file_name = SCRIPT_FILE_ROOT+name_converted+'_sim.sci';
    save_string(file_name, block_script_sim);

    // =============================GENERATE C FILE =====================================
    l = 1;
    n_lines = 3;
    index = 0; 

    if in_size > 0 then
        in_ports_string(1) = '    /* Block input ports */';
        for i = 2:n_lines:(in_size*n_lines+1)
            in_ports_string(i) = '    double *u'+string(l)+' = GetRealInPortPtrs(block,'+string(l)+');';
            in_ports_string(i+1) = '    int u' +string(l)+ '_size = GetInPortRows(block,'+ string(l)+');'+...
            '    /* u' + string(l)+ '_size = '+string(block_def.in(l))+' */';
            in_ports_string(i+2) = '';
            l = l + 1;
        end
    end

    l = 1;

    if out_size > 0 then
        out_ports_string(1) = '    /* Block output ports */';
        for i = 2:n_lines:(out_size*n_lines+1)
            out_ports_string(i) = '    double *y'+string(l)+' = GetRealOutPortPtrs(block,'+string(l)+');';
            out_ports_string(i+1) = '    int y'+string(l)+'_size = GetOutPortRows(block,'+string(l)+');'+....
            '    /* y' + string(l)+ '_size = '+string(block_def.out(l))+' */';
            out_ports_string(i+2) = '';
            l = l + 1;
        end
    end

    index = 0;
    n_lines = 2;
    l = 1;
    for i = 1:n_lines:(params_size*n_lines)
        if  block_def.param_size(l) == 1 then
            params_c_string(i) = '    /* param size = 1 */';
            params_c_string(i+1) =  '    double '+params_converted(l)+' = params['+string(index)+'];';
        else
            params_c_string(i) = '    int '+params_converted(l)+'_size = '+string(block_def.param_size(l))+';';
            params_c_string(i+1) =  '    double *'+params_converted(l)+' = &params['+string(index)+'];';
        end

        index = index + block_def.param_size(l);
        l = l + 1;
    end




    block_c_file = [
    '/* Generated with MicroDAQ toolbox ver: ' + mdaq_version() + ' */';
    '#include '"scicos_block4.h'"';
    '';
    '';
    'extern double get_scicos_time( void );';
    '';
    '/* This function will executed once at the beginning of model execution */'
    'static void init(scicos_block *block)';
    '{';
    '    /* Block parameters */';
    '    double *params = GetRparPtrs(block);';
    '';
    params_c_string;
    '';
    '    /* Add block init code here */';
    '}';
    '';
    '/* This function will be executed on every model step */';
    'static void inout(scicos_block *block)';
    '{';
    '    /* Block parameters */';
    '    double *params = GetRparPtrs(block);';
    params_c_string;
    '';
    in_ports_string;
    out_ports_string;
    '';
    '    /* Add block code here (executed every model step) */';
    '';
    '}';
    '';
    '/* This function will be executed once at the end of model execution (only in Ext mode) */'
    'static void end(scicos_block *block)';
    '{';
    '    /* Prameters */';
    '    double *params = GetRparPtrs(block);';
    '';
    params_c_string;
    '';
    '    /* Add block end code here */';
    '}';
    '';
    'void '+name_converted+'(scicos_block *block,int flag)';
    '{';
    '    if (flag == 1){            /* set output */';
    '        inout(block);';
    '    }';
    '    else if (flag == 5){       /* termination */';
    '        end(block);';
    '    }';
    '    else if (flag == 4){       /* initialisation */';
    '        init(block);';
    '    }';
    '}';
    ]

    file_name = C_FILE_ROOT+name_converted+'.c';
    save_string(file_name, block_c_file);

    svg_path = IMAGE_FILE_ROOT + 'svg' + filesep();
    gen_svg(svg_path, name_converted, block_def.name);

    // build macros and compile C code
    mdaqBlockBuild(%F, ~block_def.use_sim_script);
    mprintf("\tRestart Scilab to use new block\n");
endfunction

function res = save_string(filename, content)
    [f,res] = mopen(filename,'w');
    if res == 0 then
        mprintf(" ### Generating %s\n", filename);
        mputl(content,f)
        mclose(f)
    end
endfunction

function gen_svg(path,filename,label);
    doc = xmlRead(path+'mdaq_template.svg');

    // Label handle
    node = doc.root.children(13).children(1);
    node.content = "";
    xmlDump(node);
    xmlWrite(doc,path+filename+'.svg');
    xmlDelete(doc);
endfunction



