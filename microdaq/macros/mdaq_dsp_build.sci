function mdaq_dsp_build(diagram_file)
    
    // load Xcos libs if needed
    if isdef("c_pass1") == %F then
        loadXcosLibs();
    end
    
    if isfile(diagram_file) == %F then
        disp("ERROR: diagram file not found!");
        return;
    end
    
    importXcosDiagram(diagram_file);
    
    mdaq_code_gen(%F);
endfunction
