function str2table(str,param,spacing)
    
    param_col = size(param, "c");
    if size(param, "r") > 1 then
        disp("Wrong prama size - single row expected")
        return;
    end

    str_col = size(str, "c");
    if param_col <> str_col then
        disp("Wrong input!")
        return;
    end

    text = [param;str]
    c_size = size(text, "c");
    r_size = size(text, "r");
    c_sizes = ones(r_size, c_size)

    for c=1:c_size
        for r=1:r_size
            c_sizes(r,c) = length(text(r,c));
        end
    end


    max_c_size = ones(1,c_size);
    for i=1:param_col
        max_c_size(i) = max(c_sizes(:,i))
    end


    sstr = ''
    f_str = []
    for r = 1:r_size
        for c = 1:c_size
            sstr = sstr + text(r,c) + char(ones(1,max_c_size(c) - length(text(r,c)) + spacing) * 32) ;
        end
        f_str(r) =sstr;
        mprintf("\t%s\n",sstr )
    sstr = ''
    end

endfunction

