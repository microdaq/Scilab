function mdaqAOScanStart(arg1, arg2)
    if argn(2) == 0 then
        mdaqAOScan()
    elseif argn(2) == 1 & type(arg1) == 1 then
        mdaqAOScan(arg1)
    elseif argn(2) == 1 & type(arg1) == 10 then
        mdaqAOScanTrigger(arg1)
        mdaqAOScan()
    elseif argn(2) == 2 & type(arg1) == 1 & type(arg2) == 10 then
        mdaqAOScanTrigger(arg2)
        mdaqAOScan(arg1)
    else 
        error("Wrong imput argument");
    end
endfunction
