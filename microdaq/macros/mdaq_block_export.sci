function mdaqBlock_export(export_dir, blocks)
    cur_dir = pwd();
    macros_path = mdaqToolboxPath() + "macros" + filesep() + "user_blocks" + filesep();
    userlib_path = mdaqToolboxPath()+'src'+filesep()+'c'+ filesep()+'userlib'+filesep();
    svg_path = mdaqToolboxPath() + "images" + filesep() + "svg" + filesep();
    gif_path = mdaqToolboxPath() + "images" + filesep() + "gif" + filesep();

    if argn(2) == 2 then
        for i=1:size(blocks,'*')
            if isfile(macros_path + "mdaq_" + blocks(i) + ".sci") == %F | isfile(macros_path + "mdaq_" + blocks(i) + "_sim.sci") == %F then
                mprintf("Unable to fine %s block macros!\n", blocks(i) );
                return; 
            end
        end

        if isdir(export_dir) == %F then
            mprintf("The ''%s'' directory not found", export_dir);
            return; 
        end

        for i=1:size(blocks,'*')
            copyfile(macros_path + "mdaq_" + blocks(i) + ".sci", export_dir);
            copyfile(macros_path + "mdaq_" + blocks(i) + "_sim.sci", export_dir);
            copyfile(svg_path + "mdaq_" + blocks(i) + ".svg", export_dir);
            copyfile(gif_path + "mdaq_" + blocks(i) + ".gif", export_dir);
        end
    else
        if isdir(export_dir) == %F then
            mprintf("The ''%s'' directory not found", export_dir);
            return; 
        end
        
        cur_dir = pwd(); 
        blocks = [];
        cd(macros_path);
        macros = ls("*_sim.sci")
        for i=1:size(macros,'*')
            blocks(i) = part(macros(i), 1:length(macros(i)) - 8);
        end
        cd(cur_dir);
        
        for i=1:size(blocks,'*')
            copyfile(macros_path + blocks(i) + ".sci", export_dir);
            copyfile(macros_path + blocks(i) + "_sim.sci", export_dir);
            copyfile(svg_path + blocks(i) + ".svg", export_dir);
            copyfile(gif_path + blocks(i) + ".gif", export_dir);
        end
    end
    
    cd(cur_dir);
endfunction
