function result = mdaqDSPIsDone(arg1)
    if argn(2) == 0 then
        result = mdaqIsDone("dsp")
    elseif argn(2) == 1 then
        result = mdaqIsDone(arg1, "dsp")
    else
        result = mdaqIsDone();
    end
endfunction
