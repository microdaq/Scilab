// Change vector to string like: x = [1;2;3;4] => "[1;2;3;4]"
// if opt=%T then logic %T/%F will be translated to 0/1, otherwise 
// no change 
function out = vec2str(in, opt)
    boolMark = [];
    out = "";
    
    if size(in, "*") > 1 then
        out = "[";
    end
    
    for i=1:size(in, "r")
         if i > 1
            out = out + ";";
        end
        
        for j=1:size(in, "c")
            if type(in(i, j)) == 1
                item = string(in(i, j));
            end
            
            if type(in(i, j)) == 4
                if opt == %T
                    if in(i, j) == %T
                        item = "1";
                    else
                        item = "0";
                    end
                else
                    if in(i, j) == %T
                        item = "%T";
                    else
                        item = "%F";
                    end
                end 
            end
            
            if j == 1 
                out = out + item;
            else
                out = out + " " + item;
            end
        end
    end
    
    if size(in, "*") <> 1 then
        out = out + "]"
    end
endfunction

function out = mdaq_ai_test(channels, ranges, aiMode, testMode)
    xcosTestModel = mdaqToolboxPath() + "tests\AIO_COMPLEX_TEST\ADC_test.zcos";
    tolerance = 0.1;
    out = [];
    
    //load_diagram(xcosTestModel);   
    if isfile(xcosTestModel) == %F then
        disp("ERROR: Xcos model file not found!");
        return;
    end
    // load Xcos libs if needed
    if isdef("c_pass1") == %F then
    loadXcosLibs();
    end
    
    importXcosDiagram(xcosTestModel);
    
    channels_str = vec2str(channels, %T);
    ranges_str = vec2str(ranges, %T);
    aiMode_str = vec2str(aiMode, %T);
    scs_m.props.context = ["AI_RANGE="+ranges_str+";"; "AI_MODE="+aiMode_str+";"; "AI_CH="+channels_str+";"];
    //disp(scs_m.props.context);
    
    select testMode
        case 0 // script 
            out = mdaqAIRead(channels, ranges, aiMode);
        case 1 // simulation 
            xcos_simulate(scs_m, 4);
            // TOLERANCE 
            for i=2:size(OUT_TEST.values, "r")
                high = find( OUT_TEST.values(1, 1:size(channels, "*")) > OUT_TEST.values(i, 1:size(channels, "*")) + tolerance);
                low = find( OUT_TEST.values(1, 1:size(channels, "*")) < OUT_TEST.values(i, 1:size(channels, "*")) - tolerance);
                if size(low, '*') > 0 | size(high, '*') > 0 then
                    error("mdaq_ai_test: Simulation data is incoherent!")
                end 
            end
            out = OUT_TEST.values(1, 1:size(channels, "*"));
        case 2 // dsp 
            // Propagate context through all blocks
            %state0     = list();
            needcompile = 4;
            curwin      = 1000;
            %cpr        = struct();
            %tcur       = 0;
            %cpr.state  = %state0;
            alreadyran = %f;
            %scicos_context = struct();
            context = scs_m.props.context;
            //** context eval here
            [%scicos_context, ierr] = script2var(context, %scicos_context);
        
            // For backward compatibility for scifunc
            if ierr==0 then
                %mm = getfield(1,%scicos_context)
                for %mi=%mm(3:$)
                    ierr = execstr(%mi+"=%scicos_context(%mi)","errcatch")
                    if ierr<>0 then
                        break; //** in case of error exit
                    end
                end
            end
            // End of for backward compatibility for scifuncpagate context values
        
            [scs_m,%cpr,needcompile,ok] = do_eval(scs_m, %cpr, %scicos_context);
            if ~ok then
                msg = msprintf(gettext("%s: Error during block parameters evaluation.\n"), "Xcos");
                messagebox(msg, "Xcos", "error");
                error(msprintf(gettext("%s: Error during block parameters evaluation.\n"), "xcos_simulate"));
            end
        
            //** update parameters or compilation results
            [%cpr,%state0_n,needcompile,alreadyran,ok] = do_update(%cpr,%state0,needcompile)
            if ~ok then
                error(msprintf(gettext("%s: Error during block parameters update.\n"), "xcos_simulate"));
            end
            mdaq_code_gen(%T);
            xcos_simulate(scs_m, 4);
            
            // TOLERANCE 
            for i=2:size(OUT_TEST.values, "r")
                high = find( OUT_TEST.values(1, 1:size(channels, "*")) > OUT_TEST.values(i, 1:size(channels, "*")) + tolerance);
                low = find( OUT_TEST.values(1, 1:size(channels, "*")) < OUT_TEST.values(i, 1:size(channels, "*")) - tolerance);
                if size(low, '*') > 0 | size(high, '*') > 0 then
                    error("mdaq_ai_test: DSP data is incoherent!")
                end 
            end
            
            
            out = OUT_TEST.values(1, 1:size(channels, "*")); 
    end
endfunction

function mdaq_ao_test(channels, ranges, data, testMode)
    xcosTestModel = mdaqToolboxPath() + "tests\AIO_COMPLEX_TEST\DAC_test.zcos";
    FREQ = 100;
    
    //load_diagram(xcosTestModel);   
    if isfile(xcosTestModel) == %F then
        disp("ERROR: Xcos model file not found!");
        return;
    end
    // load Xcos libs if needed
    if isdef("c_pass1") == %F then
    loadXcosLibs();
    end

    importXcosDiagram(xcosTestModel);
    
    channels_str = vec2str(channels, %T);
    ranges_str = vec2str(ranges, %T);
    data_str = vec2str(data, %T);

    scs_m.props.context = ["AO_CH="+channels_str+";"; "AO_RANGE="+ranges_str+";"; "AO_DATA="+data_str+";"];
    //disp(scs_m.props.context);
    
    select testMode
        case 0 // script 
            mdaqAOWrite(channels, ranges, data);
        case 1 // simulation 
            xcos_simulate(scs_m, 4);
        case 2 // dsp 
             // Propagate context through all blocks
            %state0     = list();
            needcompile = 4;
            curwin      = 1000;
            %cpr        = struct();
            %tcur       = 0;
            %cpr.state  = %state0;
            alreadyran = %f;
            %scicos_context = struct();
            context = scs_m.props.context;
            //** context eval here
            [%scicos_context, ierr] = script2var(context, %scicos_context);
        
            // For backward compatibility for scifunc
            if ierr==0 then
                %mm = getfield(1,%scicos_context)
                for %mi=%mm(3:$)
                    ierr = execstr(%mi+"=%scicos_context(%mi)","errcatch")
                    if ierr<>0 then
                        break; //** in case of error exit
                    end
                end
            end
            // End of for backward compatibility for scifuncpagate context values
        
            [scs_m,%cpr,needcompile,ok] = do_eval(scs_m, %cpr, %scicos_context);
            if ~ok then
                msg = msprintf(gettext("%s: Error during block parameters evaluation.\n"), "Xcos");
                messagebox(msg, "Xcos", "error");
                error(msprintf(gettext("%s: Error during block parameters evaluation.\n"), "xcos_simulate"));
            end
        
            //** update parameters or compilation results
            [%cpr,%state0_n,needcompile,alreadyran,ok] = do_update(%cpr,%state0,needcompile)
            if ~ok then
                error(msprintf(gettext("%s: Error during block parameters update.\n"), "xcos_simulate"));
            end
            mdaq_code_gen(%T);
            xcos_simulate(scs_m, 4);    
    end
endfunction

function load_diagram(fileName)
    if isfile(fileName) == %F then
    disp("ERROR: Xcos model file not found!");
    return;
    end
    
    // load Xcos libs if needed
    if isdef("c_pass1") == %F then
        loadXcosLibs();
    end

    importXcosDiagram(fileName);
endfunction

// Compare 2 vectors by value arg1 - in measurement, arg2 - ref measurement, arg3 - tolerance 
function [out, maxErr, idxErr, errOut, expectedOut] = compare_vec_err(v1, v2, tolerance)
    out = %F;
    errors = [];
    errOut = [];
    expectedOut = [];
    idxErr = [];
    
    if size(v1, "*") <> size(v2, "*")
        error("compare_vec_err: vectors have different sizes!");
    end
    
    low = find( v1 < v2 - tolerance );
    high = find( v1 > v2 + tolerance );
    
    errors = v2 - v1;
    [maxErr idxErr] = max(abs(errors));
    errOut = v1(idxErr);
    expectedOut = v2(idxErr);
    
    if size(low, '*') > 0 | size(high, '*') > 0 then
        out = %F;
    else
        out = %T;
    end
endfunction 

function [report] = validate_test_val(out, expected_out, tolerance, testTitle)
    report = "";
    [ok maxErr idxErr errOut expectedOut] = compare_vec_err(out, expected_out, tolerance);
    errRaport = "Max err value: "+string(maxErr)+" on index "+string(idxErr)+" | Value: "+ string(errOut) +" | Expected value: "+string(expectedOut)+" (± "+string(tolerance)+")\n";
    
    if ok == %T then
        report = "\n"+testTitle + " - PASS\n"+ errRaport;
        mprintf(testTitle + " - pass\n");
        mprintf(errRaport);
    else
        report = "\n"+testTitle + " - FAILED\n"+ errRaport;
        mprintf(testTitle + " - FAILED\n");
        mprintf(errRaport);
        error("------------- !TEST FAILED! --------------");
    end   
endfunction


function mdaq_test(name, channels, aoRange, aoData, aiRange, aiMode, refData)
    mode(-1)
    treshold = 0.1;
    mdaq_ao_test(channels, aoRange, aoData', 0);
    r1 = validate_test_val(mdaq_ai_test(channels, aiRange, aiMode, 0), refData, treshold, "macro test");

    mdaq_ao_test(channels, aoRange, aoData', 1);
    r2 = validate_test_val(mdaq_ai_test(channels, aiRange, aiMode, 1), refData, treshold, "sim test");

    mdaq_ao_test(channels, aoRange, aoData', 2);
    r3 = validate_test_val(mdaq_ai_test(channels, aiRange, aiMode, 2), refData, treshold, "DSP test");
    mprintf("\n\n---------- REPORT: "+name+" ----------")
    mprintf(r1); mprintf(r2); mprintf(r3);
    mprintf("----------------------------------------------\n\n")
endfunction
