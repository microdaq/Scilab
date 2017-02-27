function mdaq_code_gen(loadDSP)

    if  check_mdaq_compiler() == %F then
        message("ERROR: Unable to find compiler - run microdaq_setup! ");
        return;
    end

    standalone = %f;
    debug_build = %t;
    profiling = %f;
    solver_type = 0;
    continue_code_gen = %f;

    scs_m;
    
    if typeof(scs_m) == "Block" then
        message("Error: Code generation works only for top model!")
        return; 
    end

    if argn(2)<2 then
        k=1;
        for i=1:(size(scs_m.objs))
            if typeof(scs_m.objs(i))=="Block" then
                
                // in case of superblock set k
                if scs_m.objs(i).model.sim(1) =="super" then
                    k=i;
                end

                // in case of mdaq_setup get code gen parameters
                if scs_m.objs(i).model.sim(1) == "mdaq_setup" then

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
    end

    if continue_code_gen == %f then
        message('In order to run MicroDAQ Code Gen scheme must contains ''mdaq_setup'' block from MicroDAQ palette');
        return;
    end

    if scs_m.objs(k).model.sim(1)=="super" then
        XX = scs_m.objs(k); //** isolate the super block to use

        // Save format
        oldFormat = format();
        format('v',10);

        [ok, XX, alreadyran, flgcdgen, szclkINTemp, freof] =  do_compile_superblock_rt(XX, scs_m, k, %f, standalone, debug_build, profiling, solver_type, loadDSP);

        // Restore format
        format(oldFormat(2), oldFormat(1));
        if ok == %f then
            disp("### ERROR: Correct scheme and run code generation again!");
        end
    else
        message("Generation Code only work for a Super Block!")
    end

endfunction
