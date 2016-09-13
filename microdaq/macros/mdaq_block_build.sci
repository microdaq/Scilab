function mdaq_block_build(debug_build)
    if  check_mdaq_compiler() == %F then
        disp("ERROR: Compiler not found - run microdaq_setup! ");
        return;
    end

    p_dir = pwd();
    mprintf(" ### Building user block macros...\n")
    macros_path = mdaq_toolbox_path() + "macros" + filesep() + "user_blocks" + filesep();
    tbx_build_macros("microdaq", macros_path);

    blocks = [];
    cd(macros_path);
    macros = ls("*_sim.sci")
    for i=1:size(macros,'*')
        blocks(i) = part(macros(i), 1:length(macros(i)) - 8);
    end

    cd(mdaq_toolbox_path());
    tbx_build_blocks(mdaq_toolbox_path(), blocks, "macros" + filesep() + "user_blocks");
    // TODO: load newly created block upon creation - avoid Scilab restart 
    //    root_tlbx = mdaq_toolbox_path();
    //    if isfile(root_tlbx + filesep() + "macros" + filesep() + "user_blocks" + filesep() + "names")  == %T then
    //        errcatch(999,"continue");
    //        xcosPalDelete("MicroDAQ User");
    //        pal = xcosPal("MicroDAQ User");
    //        microdaq_blocks = mgetl( root_tlbx + filesep() + "macros" + filesep() + "user_blocks" + filesep() + "names");
    //        microdaq_blocks = microdaq_blocks';
    //
    //        blocks = [];
    //        for i=1:size(microdaq_blocks, "*")
    //            if strstr(microdaq_blocks(i), "_sim") == ""
    //                blocks = [blocks, microdaq_blocks(i)];
    //            end
    //        end
    //
    //        for i=1:size(blocks, "*")
    //            h5  = ls(root_tlbx + "/images/h5/"  + blocks(i) + "." + ["sod" "h5"]);
    //            gif = ls(root_tlbx + "/images/gif/" + blocks(i) + "." + ["png" "jpg" "gif"]);
    //            svg = ls(root_tlbx + "/images/svg/" + blocks(i) + "." + ["png" "jpg" "gif" "svg"]);
    //            pal = xcosPalAddBlock(pal, h5(1), gif(1), svg(1));
    //        end
    //
    //        if ~xcosPalAdd(pal,"MicroDAQ User") then
    //            error(msprintf(gettext("%s: Unable to export %s.\n"), "microdaq.start", "pal"));
    //        end
    //    end 

    root_path = mdaq_toolbox_path();
    userlib_src_path = root_path + filesep() + "src" + filesep() + "c"+ filesep() + "userlib" + filesep();
    userlib_path = root_path + filesep() + "etc" + filesep() + "userlib" + filesep() + "lib" + filesep();
    userdll_path = root_path + filesep() + "etc" + filesep() + "userlib" + filesep() + "dll" + filesep();

    chdir(userlib_src_path);
    GMAKE = root_path + "\etc\bin\gmake.exe";
    mprintf(" ### Building userlib...\n")
    if getenv('WIN32','NO')=='OK' then
        if argn(2) > 0 & argn(2) < 2 then
            if debug_build then
                unix_w(GMAKE + ' -f Makefile' + ' OPT_FLAG=-g');
            else
                unix_w(GMAKE + ' -f Makefile' );
            end

        else
            unix_w(GMAKE + ' -f Makefile' );
        end

    else
        if argn(2) > 0 & argn(2) < 2 then
            if debug_build then
                unix_w('make' + ' OPT_FLAG=-g')
            else
                unix_w('make')
            end
        else
            unix_w('make')
        end

    end

    if isfile("userlib.lib") then
        copyfile("userlib.lib", userlib_path);
    end



    //Building userdll for host 
    if haveacompiler() then
        mprintf(" ### Building userdll...\n")

        c_files = ls("*.c");

        ldflags=['-lpthread -lstdc++ -lm '];
        cflags    = '-I scilab';
        scicos_libpath = SCI + filesep() + "bin" + filesep() + "scicos"
        libs=[scicos_libpath];

        tbx_build_src(blocks, c_files', 'c', userlib_src_path ,libs , "", cflags, "", "", "userdll", "userdll_loader.sce");

        if isfile("libuserdll.dll") then
            if isdir(userdll_path) == %F then
                mkdir(userdll_path);
            end

            copyfile("libuserdll.dll", userdll_path);
            copyfile("userdll_loader.sce", userdll_path);
            exec(userdll_path+"userdll_loader.sce");
        end
    else
        mprintf("Warning: No compiler detected, cannot build userdll.\n") 
    end

    chdir(p_dir);
endfunction


