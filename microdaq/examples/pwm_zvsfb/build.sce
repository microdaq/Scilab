// Create new PWM block  

b = mdaqBlock();
b.name = "ZVSFB";
b.param_name = ["PWM period"; "Default duty"]
b.param_size = [ 1 1 ];
b.param_def_val(1) = 1000;
b.param_def_val(2) = 50;
b.in = [4 1 1 1 1 1];
b.out = [];

mdaqBlockAdd(b)

copyfile(pathconvert(mdaqToolboxPath() + "examples/pwm_zvsfb/user_blocks/", %F),  pathconvert(mdaqToolboxPath() + "/macros/user_blocks", %f)); 
copyfile(pathconvert(mdaqToolboxPath() + "examples/pwm_zvsfb/userlib/", %F), pathconvert(mdaqToolboxPath() + "/src/c/userlib/", %F)); 

deletefile(mdaqToolboxPath() + "/macros/user_blocks/mdaq_zvsfb.bin");
deletefile(mdaqToolboxPath() + "/macros/user_blocks/mdaq_zvsfb_sim.bin");

deletefile(mdaqToolboxPath() + "/src/c/userlib/mdaq_pwm_zvsfb.o");
deletefile(mdaqToolboxPath() + "/src/c/userlib/mdaq_zvsfb.o");
 
mdaqBlockBuild(%t, %f)

mprintf("Restart Scilab to use new Xcos block"); 
