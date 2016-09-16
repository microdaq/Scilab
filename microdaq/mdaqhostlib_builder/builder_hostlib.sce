clc
//Building userdll for host 
if haveacompiler() then
    mprintf(" ### Building mdaq block dll...\n")

    cd("macros")
    blocks = [];
    macros = ls("*.sci")
    for i=1:size(macros,'*')
        blocks(i) = part(macros(i), 1:length(macros(i)) - 4);
    end
    cd("..");

    cd("src");
    c_files = ls("*.c");
    
    cflags = "";
    
    os = getos();
    scicos_libpath = "";
    if os == 'Windows' then 
        cflags = "-I .."+filesep()+"includes";
        scicos_libpath = SCI + filesep() + "bin" + filesep() + "scicos";
    elseif os == 'Linux' then 
        cflags    = '-I '+pwd()+'..'+filesep()+'includes -I'+pwd();
        scicos_libpath = SCI+"/../../lib/scilab/libsciscicos";
    else
        error("This platform is not supported!");
    end
    
    
    libs=[scicos_libpath];

    disp(c_files); 
    disp(blocks);
    
    //check scilab version 
    [v,o] = getversion();
    dllname = [];
    loadername = [];
    if o(2) == 'x64' then 
        dllname = 'mdaqblocks_x64';
        loadername = 'loader_x64.sce';
    else 
        dllname = 'mdaqblocks_x86';
        loadername = 'loader_x86.sce';
    end
    
    tbx_build_src(blocks', c_files', 'c',  "",libs , "", cflags, "", "", dllname, loadername);

    if isfile("lib"+dllname+getdynlibext()) then
        copyfile("lib"+dllname+getdynlibext(), ".."+filesep()+"out");
        copyfile(loadername, ".."+filesep()+"out");
        exec("cleaner.sce");
    end
    cd("..");
else
    mprintf("Eroor: No compiler detected, cannot build host shared library!\n") 
end
