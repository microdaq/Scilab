function [res] = build_mdaq_palette(tmp_dir)
    pal = xcosPal("MicroDAQ");
    root_tlbx = mdaq_toolbox_path();
    
    // Build MicroDAQ blocks
    microdaq_blocks = mgetl( root_tlbx + filesep() + "macros" +..
    filesep() + "microdaq_blocks" + filesep() + "names");

    microdaq_blocks = microdaq_blocks';

    blocks = [];
    for i=1:size(microdaq_blocks, "*")
        if strstr(microdaq_blocks(i), "_sim") == ""
            blocks = [blocks, microdaq_blocks(i)];
        end
    end

    for i=1:size(blocks, "*")
        h5  = ls(root_tlbx + "/images/h5/"  + blocks(i) + "." + ["sod" "h5"]);
        gif = ls(root_tlbx + "/images/gif/" + blocks(i) + "." + ["png" "jpg" "gif"]);
        svg = ls(root_tlbx + "/images/svg/" + blocks(i) + "." + ["png" "jpg" "gif" "svg"]);
        pal = xcosPalAddBlock(pal, h5(1), gif(1), svg(1));
    end

    if ~xcosPalAdd(pal,"MicroDAQ_tmp") then
        error(msprintf(gettext("%s: Unable to export %s.\n"), "microdaq.start", "pal"));
    end

    //Create complete mdaq palette
    if isdef("gen_palette") == %T then
        //load xcos library
        if isdef("c_pass1") == %F then
            loadXcosLibs();
        end
        gen_palette(tmp_dir);
        clear gen_palette;
    end

    xcosPalDelete("MicroDAQ_tmp");    
    res = 0;
endfunction
