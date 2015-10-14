function [data,result] = mdaq_mem_get(start_index, data_size, vector_size)
    data = [];
    result = 0;

    if  start_index < 1 | start_index > 4000000 then
        disp("ERROR: Incorrect start index - use values from 1 to 4000000!")
        return;
    end
    
    if data_size < 1 then
        disp("ERROR: Incorrect data size!");
       return;
   end

   if vector_size < 1 then
       disp("ERROR: Incorrect data vector size!");
       return;
   end

   size_mod = modulo(data_size, vector_size)
   if size_mod <> 0  then
       disp("ERROR: Incorrect data and vector size!");
       return; 
   end

   connection_id = mdaq_open();
   if connection_id < 0 then
       disp('ERROR: Unable to connect to MicroDAQ device - check your setup!');
       return;
   end

    row_size = vector_size;
    col_size = data_size / vector_size;
    
    [data result] = call("sci_mlink_mem_get2",..
            connection_id, 1, 'i',..
            start_index, 2, 'i',..
            data_size, 3, 'i',..
        "out",..
            [row_size, col_size] , 4, 'r',.. 
            [1,1], 5, 'i');

    mdaq_close(connection_id);
endfunction
