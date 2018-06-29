function  mdaqDSPWaitUntilDone(arg1, arg2)
    if argn(2) == 1 then
        mdaqWaitUntilDone("dsp", arg1)
    elseif argn(2) == 2 then
        mdaqWaitUntilDone(arg1, "dsp", arg2)
    else
        mdaqWaitUntilDone();
    end
endfunction
