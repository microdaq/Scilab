function mdaqDSPBuild(diagram_file)
    // Check version compatibility 
    [is_supp vers] = mdaq_is_working('mdaqDSPBuild');
    if is_supp == %F then
        error('ERROR: ' + vers)
        return;
    end

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
