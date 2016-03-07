function mdaq_block_build(debug_build)
    if  check_mdaq_compiler() == %F then
        disp("ERROR: Compiler not found - run microdaq_setup! ");
        return;
    end
    
    mprintf(" ### Building user block macros...\n")
    macros_path = mdaq_toolbox_path() + "macros" + filesep() + "user_blocks" + filesep();
    tbx_build_macros("microdaq", macros_path);

    blocks = [];
    cd(macros_path);
    macros = ls("*_sim.sci")
    for i=1:size(macros,'*')
        blocks(i) = part(macros(i), 1:length(macros(i)) - 8);
    end

    p_dir = pwd();
    cd(mdaq_toolbox_path());
    tbx_build_blocks(mdaq_toolbox_path(), blocks, "macros" + filesep() + "user_blocks");
    
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

    wd = pwd();
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
    chdir(p_dir);
endfunction


