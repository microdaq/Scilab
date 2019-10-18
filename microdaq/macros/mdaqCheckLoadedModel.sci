function res = mdaqIsExtMode()
    res = []
    con = mdaqOpen(); 
    result = mlink_set_obj(con, "ext_mode", 1);
    mdaqClose(con);
    if result == -25 then
        res = %F
    else
        res = %T
    end
endfunction
