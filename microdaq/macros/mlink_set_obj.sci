function result = mlink_set_obj(connection_id, obj_name, obj_value)
    result = call("sci_mlink_set_obj",..
                        connection_id, 1, "i",..
                        obj_name, 2, "c",..
                        obj_value, 3, "r",..
                        1, 4, "i",..
                    "out",..
                        [1,1], 5, "i");
endfunction
