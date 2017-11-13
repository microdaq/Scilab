[a b] = getversion();
host_lib = pathconvert(root_tlbx+"/etc/mdaqlib/libmdaqblocks_"+b(2)+getdynlibext(), %f);

if isfile(host_lib) then
    os = getos();
    scicos_libpath = "";
    if os == 'Windows' then 
        scicos_libpath = SCI + "\bin\scicos";
    elseif (os == 'Linux') | (os == 'Darwin') then 
        scicos_libpath = SCI+"/../../lib/scilab/libsciscicos";
    end

    link(scicos_libpath + getdynlibext());
    link(host_lib, ['mdaq_pid_z'],'c');
else
    error('Error: cannot load: '+host_lib);
end
clear a;
clear b;
clear host_lib;
