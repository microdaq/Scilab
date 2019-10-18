function load_mdaq_palette()
    palette_path = mdaqToolboxPath() + "etc" + filesep() + "palette";
    palette_sod_path = palette_path + filesep() + "sod";

    // load generated sod files
    palette_files = ls(palette_sod_path);
    palette_files = gsort(palette_files, 'lr', 'i');
    palette_files_index = grep(palette_files, ".sod");

    if palette_files_index <> [] then
        pal_size = size(palette_files_index, '*');
        for i = 1:pal_size
            xcosPalAdd(palette_sod_path + filesep() + palette_files(palette_files_index(i)),'MicroDAQ')
        end
    end
endfunction

