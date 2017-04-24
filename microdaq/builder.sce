// Copyright (c) 2015, Embedded Solutions
// All rights reserved.

// This file is released under the 3-clause BSD license. See COPYING-BSD.

mode(-1);
lines(0);

function main_builder()
  TOOLBOX_NAME  = "microdaq";
  TOOLBOX_TITLE = "MicroDAQ toolbox";
  toolbox_dir   = get_absolute_file_path("builder.sce");

// Check Scilab's version
// =============================================================================

  // check minimal version (xcosPal required)
  if ~isdef('xcosPal') then
    // and xcos features required
    error(gettext('Scilab 5.3.2 or more is required.'));
  end

// Check modules_manager module availability
// =============================================================================

  if ~isdef('tbx_build_loader') then
    error(msprintf(gettext('%s module not installed.'), 'modules_manager'));
  end


  if ~isdir(toolbox_dir+filesep()+"images"+filesep()+"h5")
      [status, msg] = mkdir(toolbox_dir+filesep()+"images"+filesep()+"h5");
      if and(status <> [1 2])
          error(msg);
      end
  end

// Action
// =============================================================================

  tbx_builder_macros(toolbox_dir);
  tbx_builder_help(toolbox_dir);
  tbx_build_loader(toolbox_dir);
  tbx_build_cleaner(toolbox_dir);
  
  sci_ver_str = getversion('scilab', 'string_info');
  help_path = pathconvert(toolbox_dir+'jar/'+sci_ver_str);
  if isdir(toolbox_dir+'/jar/'+sci_ver_str) == %F then
      mkdir(help_path);
  end
  movefile(pathconvert(toolbox_dir+'jar/scilab_en_US_help.jar', %F), pathconvert(help_path+'scilab_en_US_help.jar', %F));
  
  //delete mblockstmpdir file to force loader to rebuild mdaq palette 
  deletefile(toolbox_dir+filesep()+"etc"+filesep()+"mblockstmpdir");
  
endfunction

if with_module('xcos') then
  main_builder();
  clear main_builder; // remove main_builder on stack
end
