function  mdaqAOIsDone(arg1)
	if argn(2) == 0 then
        mdaqIsDone("ao")
    elseif argn(2) == 1 then
        mdaqIsDone(arg1, "ao")
    else
        mdaqIsDone();
    end
endfunction
