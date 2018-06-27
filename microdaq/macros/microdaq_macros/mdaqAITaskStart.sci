function mdaqAITaskStart(arg1)
    if argn(2) == 0 then
        mdaqAITaskRead(0,0)
        mdaqAITaskRead(arg1, 0, 0)
    else 
        error("Wrong number of arguments");
    end
endfunction
