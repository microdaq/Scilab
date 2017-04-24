// This file is released under the 3-clause BSD license. See COPYING-BSD.
sci_ver_str = getversion('scilab', 'string_info');

add_help_chapter("Utility functions",get_absolute_file_path("build_help.sce") + filesep() + "utility",%T);
add_help_chapter("HW access functions",get_absolute_file_path("build_help.sce") + filesep() + "hw_access",%T);

if sci_ver_str == 'scilab-5.5.2' then
    add_help_chapter("DSP managment",get_absolute_file_path("build_help.sce") + filesep() + "dsp_managment",%T);
    add_help_chapter("C/C++ code integration",get_absolute_file_path("build_help.sce") + filesep() + "code_integration",%T);
    add_help_chapter("Blocks",get_absolute_file_path("build_help.sce") + filesep() + "blocks",%T);
end

tbx_build_help(TOOLBOX_TITLE,get_absolute_file_path("build_help.sce"));
