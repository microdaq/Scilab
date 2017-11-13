// This file is released under the 3-clause BSD license. See COPYING-BSD.
add_help_chapter("Utility functions",get_absolute_file_path("build_help.sce") + filesep() + "utility",%T);
add_help_chapter("Data acquisition",get_absolute_file_path("build_help.sce") + filesep() + "hw_access",%T);
add_help_chapter("DSP managment",get_absolute_file_path("build_help.sce") + filesep() + "dsp_managment",%T);
add_help_chapter("C/C++ code integration",get_absolute_file_path("build_help.sce") + filesep() + "code_integration",%T);
add_help_chapter("Blocks",get_absolute_file_path("build_help.sce") + filesep() + "blocks",%T);

tbx_build_help(TOOLBOX_TITLE,get_absolute_file_path("build_help.sce"));
