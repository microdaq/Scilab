function mdaq_code_gen(load_dsp_app)

    if  check_mdaq_compiler() == %F then
        messagebox("Can''t locate compiler for compiling generated code. To solve this problem run microdaq_setup() function", "Settings error", "error");
        return;
    end

    standalone = %f;
    debug_build = %t;
    profiling = %f;
    solver_type = 0;
    continue_code_gen = %f;

    scs_m; 

    // TODO: make general solution for scilab 5/6
    try 
        size(scs_m.objs)
    catch
        messagebox("Can''t generate code from inside of superblock.", "Code generation problem", "error")
        return
    end

    if argn(2)<2 then
        k=1;
        for i=1:(size(scs_m.objs)-1)
            sciVersion = getversion('scilab');
            if sciVersion(1) == 6 then 
                if typeof(scs_m.objs(i)) <> "Block" then
                    continue;
                end
            end
            
            // in case of superblock set k
            if scs_m.objs(i).model.sim(1)=="super" then
                k=i;
            end

            // in case of mdaq_setup get code gen parameters
            if scs_m.objs(i).model.sim(1)=="mdaq_setup" then

                // get build mode from model setup block
                if scs_m.objs(i).model.ipar(1) == 1 then
                    debug_build = %f;
                else
                    debug_build = %t;
                end

                // get build type from model setup block
                if scs_m.objs(i).model.ipar(2) == 1 then
                    standalone = %f;
                else
                    standalone = %t;
                end

                // check if profiling is enabled
                if scs_m.objs(i).model.ipar(3) == 1 then
                    profiling = %t;
                else
                    profiling = %f;
                end
                solver_type = scs_m.objs(i).model.ipar(4);

                // mdaq_setup block found so code gen can be executed
                continue_code_gen = %t;
            end
        end
    end

    if continue_code_gen == %f then
        messagebox("Can''t determine model settings - use SETUP block from MicroDAQ palette.", "SETUP missing", "error");
        return;
    end

    if scs_m.objs(k).model.sim(1)=="super" then
        XX = scs_m.objs(k); //** isolate the super block to use

        // Save format
        oldFormat = format();
        format('v',10);

        [ok, XX, alreadyran, flgcdgen, szclkINTemp, freof] =  do_compile_superblock_rt(XX, scs_m, k, %f, standalone, debug_build, profiling, solver_type, load_dsp_app);

        // Restore format
        format(oldFormat(2), oldFormat(1));
        if ok == %f then
            messagebox("Can''t generate code from model. Check model for errors", "Model error", "error");
        end
    else
        messagebox("Can''t find superblock for code generation",  "Model structure problem", "error");
    end

endfunction
