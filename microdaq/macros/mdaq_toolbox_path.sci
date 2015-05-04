function result_path = mdaq_toolbox_path()
    result_path = [];
    path = dirname(get_function_path('mdaq_toolbox_path')) + filesep();
    result_path = part(path,1:length(path)-length("macros") - 1 );
endfunction
