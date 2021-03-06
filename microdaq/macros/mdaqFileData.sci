function result = mdaqFileData(filename, filetype, rows, cols)
    result = [];

    if (argn(2) > 4 | argn(2) < 2) | (filetype == 2 & argn(2) <> 4) then
        mprintf("Description:\n");
        mprintf("\tReads data from file created with MicroDAQ ''To File'' block\n");
        mprintf("Usage:\n");
        mprintf("\tmdaqFileData(name, type, rows, cols);\n")
        mprintf("\tname - file name \n");
        mprintf("\ttype - file type to read data from (1 - text (csv) | 2 - binary)\n");
        mprintf("\trows - number of rows (optinal for text filetype)\n");
        mprintf("\tcols - number of columns (optinal for text filetype)\n");
        return;
    end

    [mdaq_ip_address, res] = mdaq_get_ip();
    if res < 0 then
        disp("ERROR: Unable to get IP address!")
        return;
    end
    [tmp_file res] = getURL('http://' + mdaq_ip_address + '/user-disk/dsp/data/' + filename, TMPDIR);

    if isfile(tmp_file) & (strindex(res,'404 - Not Found') == []) then
        if filetype == 1 then
            result = fscanfMat(tmp_file);
            if argn(2) == 4 then
                nrows = rows;
                if nrows > size(result, 1) then
                    nrows = size(result, 1);
                end
                ncols = cols;
                if ncols > size(result, 2) then
                    ncols = size(result, 2)
                end
                result = resize_matrix(result, nrows, ncols);
            end

        elseif filetype == 2 then
            fd1 = mopen(tmp_file,'rb');
            data_count = rows*cols;
            data = mget(rows*cols,'d',fd1);

            if size(data, 2) < data_count then
                //disp("ERROR: !");
                data_count = size(data, 2);
            end

            for i=1:cols
                result = [result; data(i:cols:data_count)];
            end
            result = result';
            mclose(fd1)
        else
            error("Unsupported file type, use: 1 - text (csv), 2 - binary");
        end
        mdelete(tmp_file);
    else
        error("File not found!");
    end

endfunction
