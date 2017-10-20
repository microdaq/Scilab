function [is_working, versions] = mdaq_is_working(func_name)
    // vector: [major], [minor], [Maintenance]
    sci_ver = getversion('scilab');
    uglyfuncs = list();
    
    // CUSTOM BLOCKS -
    uglyfuncs($+1) = list('mdaqBlockBuild',           '5.5.2');     
    uglyfuncs($+1) = list('mdaqBlockAdd',             '5.5.2');
    uglyfuncs($+1) = list('mdaqBlock',                 '5.5.2');
    
    // DSP MANAGMENT -
    uglyfuncs($+1) = list('mdaqDSPBuild',             '5.5.2');
    uglyfuncs($+1) = list('mdaqDSPSignal',            '5.5.2');
    uglyfuncs($+1) = list('mdaqDSPSignalRead',       '5.5.2');
    uglyfuncs($+1) = list('mdaqDSPStart',             '5.5.2');
    uglyfuncs($+1) = list('mdaqDSPStop',              '5.5.2');
    uglyfuncs($+1) = list('mdaqDSPTerminate',         '5.5.2');
    
       
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
    
    is_working = %T;
    versions = 'Function ' + func_name + ' works on scilab 5.5.2 and 6.x.x versions.';
endfunction 
