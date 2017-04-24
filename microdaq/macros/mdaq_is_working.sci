function [is_working, versions] = mdaq_is_working(func_name)
    // vector: [major], [minor], [Maintenance]
    sci_ver = getversion('scilab');
    uglyfuncs = list();
    
    // CUSTOM BLOCKS -
    uglyfuncs($+1) = list('mdaq_block_build',           '5.5.2');     
    uglyfuncs($+1) = list('mdaq_block_add',             '5.5.2');
    uglyfuncs($+1) = list('mdaq_block',                 '5.5.2');
    
    // DSP MANAGMENT -
    uglyfuncs($+1) = list('mdaq_dsp_build',             '5.5.2');
    uglyfuncs($+1) = list('mdaq_dsp_signal',            '5.5.2');
    uglyfuncs($+1) = list('mdaq_dsp_signal_read',       '5.5.2');
    uglyfuncs($+1) = list('mdaq_dsp_start',             '5.5.2');
    uglyfuncs($+1) = list('mdaq_dsp_stop',              '5.5.2');
    uglyfuncs($+1) = list('mdaq_dsp_terminate',         '5.5.2');
    
     // HW ACCSESS - HAVE TO WORK 
    uglyfuncs($+1) = list('mdaq_ai_read',               '5.5.2', '6.x.x');
    uglyfuncs($+1) = list('mdaq_ao_write',              '5.5.2', '6.x.x');
    uglyfuncs($+1) = list('mdaq_dio_read',              '5.5.2', '6.x.x');
    uglyfuncs($+1) = list('mdaq_dio_func',              '5.5.2', '6.x.x');
    uglyfuncs($+1) = list('mdaq_dio_write',             '5.5.2', '6.x.x');    
    uglyfuncs($+1) = list('mdaq_enc_init',              '5.5.2', '6.x.x');
    uglyfuncs($+1) = list('mdaq_enc_read',              '5.5.2', '6.x.x');
    uglyfuncs($+1) = list('mdaq_hs_ai_init',            '5.5.2', '6.x.x');
    uglyfuncs($+1) = list('mdaq_hs_ai_read',            '5.5.2', '6.x.x');
    uglyfuncs($+1) = list('mdaq_key_read',              '5.5.2', '6.x.x');
    uglyfuncs($+1) = list('mdaq_led_write',             '5.5.2', '6.x.x');
    uglyfuncs($+1) = list('mdaq_mem_get',               '5.5.2', '6.x.x');
    uglyfuncs($+1) = list('mdaq_mem_set',               '5.5.2', '6.x.x');
    uglyfuncs($+1) = list('mdaq_pwm_init',              '5.5.2', '6.x.x');
    uglyfuncs($+1) = list('mdaq_pwm_write',             '5.5.2', '6.x.x');
    
    // UTILITY FUNCTIONS
    uglyfuncs($+1) = list('mdaq_get_file_data',         '5.5.2', '6.x.x');
    uglyfuncs($+1) = list('mdaq_hwinfo',                '5.5.2', '6.x.x');
    uglyfuncs($+1) = list('mdaq_ping',                  '5.5.2', '6.x.x');
    uglyfuncs($+1) = list('mdaq_toolbox_path',          '5.5.2', '6.x.x');
     
    
    versions = 'This function is not supported in Scilab '+string(sci_ver(1))+'.'+string(sci_ver(2))+'.'+string(sci_ver(3))+..
    '. Currently is only compatible with version: '; 
    
    ver_str = '';
    is_working = %F;
    
    for f=1:length(uglyfuncs)
        if func_name == uglyfuncs(f)(1) then 
            for v=2:length(uglyfuncs(f))
                ver_str =  ver_str + uglyfuncs(f)(v) + ', ';
                func_ver = strsplit(uglyfuncs(f)(v), '.');
                
                if func_ver(1) == 'x' then 
                    is_working = %T;
                elseif (func_ver(2) == 'x')
                    if (strtod(func_ver(1)) == sci_ver(1)) then 
                        is_working = %T;
                    end       
                elseif (func_ver(3) == 'x')
                    if (strtod(func_ver(1)) == sci_ver(1)) & (strtod(func_ver(2)) == sci_ver(2)) then 
                        is_working = %T;
                    end        
                else
                    if (strtod(func_ver(1)) == sci_ver(1)) & (strtod(func_ver(2)) == sci_ver(2)) & (strtod(func_ver(3)) == sci_ver(3)) then 
                        is_working = %T;
                    end
                end
                
            end
            
            versions = versions + ver_str;
            
            if is_working then 
                versions = 'This function is compatible with Scilab version: '
                versions = versions + ver_str;
            end 
            
            return;
        end
    end
    
    versions = 'Function ' + func_name + ' not exists.';
endfunction 
