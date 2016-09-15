function xpal = tbx_compose_pal(name, interfaces)
    xpal = xcosPal(name);
    for i=1:size(interfaces,1)
        try
            xpal = xcosPalAddBlock(xpal, interfaces(i));
        catch
            disp("Warning: Cannot add "+interfaces(i)+" block to MicroDAQ palette.")
        end
    end
endfunction
