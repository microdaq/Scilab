// Copyright (c) 2015, Embedded Solutions
// All rights reserved.

// This file is released under the 3-clause BSD license. See COPYING-BSD.

function cleanmacros()
    basepath = get_absolute_file_path('cleanmacros.sce');

    libpaths = ["", "microdaq_blocks", "microdaq_macros", "user_blocks"]

    for i = 1:size(libpaths, "c")
        libpath = basepath + libpaths(i)
        binfiles = ls(libpath+'/*.bin');
        for i = 1:size(binfiles,'*')
            mdelete(binfiles(i));
        end

        mdelete(libpath+'/names');
        mdelete(libpath+'/lib');
    end

    blockfiles = ls(basepath+'../images/h5/*.h5');
    for i = 1:size(blockfiles,'*')
        mdelete(blockfiles(i));
    end

    try
        mdelete(basepath+'../etc/mlink/hwid');
        mdelete(basepath+'../etc/mlink/ip_config.txt');
    catch
    end

endfunction

cleanmacros();
clear cleanmacros; // remove cleanmacros on stack

