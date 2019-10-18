function mdaqDSPBuild(diagram_file)
    if isfile(diagram_file) == %F then
        disp("ERROR: Xcos model file not found!");
        return;
    end

    // load Xcos libs if needed
    if isdef("c_pass1") == %F then
        loadXcosLibs();
    end

    importXcosDiagram(diagram_file);

    mdaq_code_gen(%F);
endfunction
