function result = mdaqAOScanIsDone(arg1)
    if argn(2) == 0 then
        result = mdaqIsDone("ao")
    elseif argn(2) == 1 then
        result = mdaqIsDone(arg1, "ao")
    else
        result = mdaqIsDone();
    end
endfunction
