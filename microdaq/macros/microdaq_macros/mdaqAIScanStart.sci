function mdaqAIScanStart(arg1, arg2)
    if argn(2) == 0 then
        mdaqAIScanRead(0,0)
    elseif argn(2) == 1 & type(arg1) == 1 then
        mdaqAIScan(arg1, 0, 0)
    elseif argn(2) == 1 & type(arg1) == 10 then
        mdaqAIScanTrigger(arg1)
        mdaqAIScanRead(0, 0)
    elseif argn(2) == 2 & type(arg1) == 1 & type(arg2) == 10 then
        mdaqAIScanTrigger(arg2)
        mdaqAIScanRead(arg1, 0, 0)
    else 
        error("Wrong number of imput arguments");
    end
endfunction
