function block=mdaq_mem_read_sim(block,flag)
    global %microdaq;
    if %microdaq.dsp_loaded == %F then
        select flag
        case 4 // Initialization
            disp("WARNING: mdaq_mem_read block isn''t supported in host simulation mode!")
        end
    else
        // if DSP loaded we can init memory with data file if provided
        select flag
        case 4 // Initialization
            if block.ipar(3) == 3 then
                if block.label <> "" then
                    if strindex(block.label,'file=') == 1 then
                        filename = msscanf(block.label, "file=%s");
                        try
                            data = csvRead(filename); 
                        catch
                            warning("Unable load local file " + filename + " to MicroDAQ memory"); 
                            return; 
                        end
                        if size(data, "*") <>  block.ipar(4) then
                            warning("File data do not match MEM Read block data size"); 
                            return; 
                        end
                        mprintf(" ### Loading %s at %d memory index\n", filename, block.ipar(1) + 1);
                        mdaqClose();
                        mdaqDSPWrite(block.rpar(1) + 1, data); 
                        
                        return;
                    end
                    warning("Unable to load file data"); 
                    return; 
                end
            end
        end
    end
endfunction
