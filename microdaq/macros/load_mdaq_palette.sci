function [res] = load_mdaq_palette()
    is_generated = %F;
    config_path = mdaq_toolbox_path() + "etc"+filesep()+"mblockstmpdir";

    //check if sod files were generated
    try
        load(config_path);
        if fileinfo(tmp_dir+filesep()+"01.sod") <> [] then
            is_generated = %T;
        else
            is_generated = %F;
        end
    catch
        is_generated = %F;
    end

    if is_generated == %F then
        //Generete palette sod files
        tmp_dir = TMPDIR+filesep()+"palette";
        mkdir(tmp_dir);
        
        //generate & load    
        build_mdaq_palette(tmp_dir);
        save(config_path, 'tmp_dir');
    
    else
        //Load generated sod files
        load_saved_palette(tmp_dir);
    end
    
    res = 0;
endfunction

function [res] = load_saved_palette(mdaq_tmp_dir)
palette_files = ls(mdaq_tmp_dir);
palette_files_index = grep(palette_files, ".sod");

if palette_files_index <> [] then
    pal_size = size(palette_files_index, '*');
    for i = 1:pal_size
        xcosPalAdd(mdaq_tmp_dir + filesep() + palette_files(palette_files_index(pal_size-i+1)),'MicroDAQ')
    end
end
res = 0;
endfunction
