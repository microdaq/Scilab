function xpal = tbx_build_pal(toolbox_dir, name, interfaces)
    h5_instances = toolbox_dir + "images/h5/" + interfaces + ".sod";
    pal_icons = toolbox_dir + "images/gif/" + interfaces + ".gif";
    graph_icons = toolbox_dir + "images/svg/" + interfaces + ".svg";


    xpal = xcosPal(name);

    for i=1:size(interfaces,1)
        try 
            xpal = xcosPalAddBlock(xpal, h5_instances(i), pal_icons(i), graph_icons(i));
        catch
            disp("Warning: Cannot add "+interfaces(i)+" block to MicroDAQ palette.")
        end
    end
endfunction
