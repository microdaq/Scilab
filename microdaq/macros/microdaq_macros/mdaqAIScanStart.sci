function mdaqAIScanStart(arg1)
    if argn(2) == 0 then
        mdaqAIScan(0,0)
    elseif argn(2) == 1 then
        mdaqAIScan(arg1, 0, 0)
    else 
        error("Wrong number of arguments");
    end
endfunction
