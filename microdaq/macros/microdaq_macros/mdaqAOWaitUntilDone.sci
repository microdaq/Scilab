function  mdaqAOWaitUntilDone(arg1, arg2)
    if argn(2) == 1 then
        mdaqWaitUntilDone("ao", arg1)
    elseif argn(2) == 2 then
        mdaqWaitUntilDone(arg1, "ao", arg2)
    else
        mdaqWaitUntilDone();
    end
endfunction
