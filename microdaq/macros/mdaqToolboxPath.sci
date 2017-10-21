function result_path = mdaqToolboxPath()
    result_path = [];
    path = dirname(get_function_path('mdaqToolboxPath')) + filesep();
    result_path = part(path,1:length(path)-length("macros") - 1 );
endfunction
