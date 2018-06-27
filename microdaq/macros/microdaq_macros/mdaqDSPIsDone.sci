function  mdaqDSPIsDone(arg1, arg2)
	if argn(2) == 1 then
        mdaqIsDone("dsp", arg1)
    elseif argn(2) == 2 then
        mdaqIsDone(arg1, "dsp", arg2)
    else
        mdaqIsDone();
    end
endfunction
