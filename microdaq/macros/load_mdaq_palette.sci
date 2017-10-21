function [res] = load_mdaq_palette()
    is_generated = %F;
    config_path = mdaqToolboxPath() + "etc"+filesep()+"mblockstmpdir";
    tbx_tmp_path = mdaqToolboxPath() + "etc"+filesep()+"tmp";

    //check if sod files were generated
    try
        load(config_path);
    catch
        is_generated = %F;
    end

    if exists('tmp_dir') == 1 then
        if isdir(tbx_tmp_path+filesep()+basename(tmp_dir)) then
            is_generated = %T;
        else
            is_generated = %F;
        end
    end

    
    
    if is_generated == %F then
        //Generete palette sod files
        tmp_dir = TMPDIR;
        palette_path = tmp_dir + filesep() + "palette";
        mkdir(palette_path);

        //generate & load    
        build_mdaq_palette(palette_path);
        save(config_path, 'tmp_dir');

        //Bugfix 
        //replace mdaq .svg files in TMPDIR
        svg_path = mdaqToolboxPath() + filesep() + "images" +..
        filesep() + "svg" + filesep();
        copyfile(svg_path, TMPDIR+filesep());

        if isdir(tbx_tmp_path) == %F then
            mkdir(tbx_tmp_path)
        end

        mkdir(tbx_tmp_path+filesep()+basename(TMPDIR));
        copyfile(TMPDIR, tbx_tmp_path+filesep()+basename(TMPDIR));
    else
        palette_path = tmp_dir + filesep() + "palette";
        
        //Load generated sod files
        if isdir(tmp_dir) == %F then 
            mkdir(dirname(TMPDIR)+filesep()+basename(tmp_dir));
            copyfile(tbx_tmp_path+filesep()+basename(tmp_dir), dirname(TMPDIR)+filesep()+basename(tmp_dir));
        end

        load_saved_palette(palette_path);
    end

    res = 0;
endfunction

function [res] = load_saved_palette(palette_path)  
    palette_files = ls(palette_path);
    palette_files = gsort(palette_files, 'lr', 'i');
    palette_files_index = grep(palette_files, ".sod");

    if palette_files_index <> [] then
        pal_size = size(palette_files_index, '*');
        for i = 1:pal_size
            xcosPalAdd(palette_path + filesep() + palette_files(palette_files_index(i)),'MicroDAQ')
        end
    end
    res = 0;
endfunction
