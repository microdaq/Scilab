function result_path = mdaqToolboxPath()
    result_path = [];
    path = fileparts(get_function_path('mdaqToolboxPath'));
    result_path = part(path,1:length(path)-length("macros") - 1 );
endfunction
