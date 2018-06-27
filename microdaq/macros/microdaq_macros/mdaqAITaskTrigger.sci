function mdaqAITaskTrigger(varargin)
    if argn(2) == 0 then
        cmd = "scanTrigger(1"; 
    else
        cmd = "scanTrigger(1, "; 
    end
    
    for i = 1:argn(2)
        if type(varargin(i)) == 10 then
            cmd = cmd + """" + varargin(i) + """";
            if i <> argn(2) then 
                cmd = cmd + ", "; 
            end
        end
        if type(varargin(i)) == 1 then
            cmd = cmd + string(varargin(i));
            if i <> argn(2) then 
                cmd = cmd + ", "; 
            end
        end
    end
    cmd = cmd + ");";
    execstr(cmd);
endfunction
