// Copyright (c) 2015, Embedded Solutions
// All rights reserved.

// This file is released under the 3-clause BSD license. See COPYING-BSD.

mode(-1)
global STATE
STATE = 1

//DIRECTORY BROWSER FUNCTIONS
function browse_dir_callback1()
    directory = uigetdir()
    set(h(8),'String',directory)
    set(h(11),'Enable','on')
    set(h(12),'Enable','on')
endfunction

function [] = browse_dir_callback2()
    directory = uigetdir()
    set(h(11),'String',directory)
    set(h(14),'Enable','on')
    set(h(15),'Enable','on')
endfunction

function [] = browse_dir_callback3()
    directory = uigetdir()
    set(h(14),'String',directory)
    set(h(17),'Enable','on')
    set(h(18),'Enable','on')
endfunction

function [] = browse_dir_callback4()
    directory = uigetdir()
    set(h(17),'String',directory)
    set(h(22),'Enable','on')
endfunction

//EDIT BOX CALLBACK
function [] = edit_callback1()
    set(h(11),'Enable','on')
    set(h(12),'Enable','on')
endfunction

function [] = edit_callback2()
    set(h(14),'Enable','on')
    set(h(15),'Enable','on')
endfunction

function [] = edit_callback3()
    set(h(17),'Enable','on')
    set(h(18),'Enable','on')
endfunction

function [] = edit_callback4()
    set(h(22),'Enable','on')
endfunction

//CHECK CONNECTION FUNCTION
function [] = connect_callback()
    set(h(21),'Enable','off')
    ip = get(h(20),'String')
    mdaq_set_ip(ip);

    result = mdaq_ping();
    if result == %F  then
        messagebox('Unable to connect to MicroDAQ device!','Error','error')
        set(h(21),'Enable','on')
    else
        messagebox('Connection OK!','MicroDAQ info','info');
        set(h(21),'Enable','on')
    end
endfunction

//CLOSE FUNCTION
function [] = close_callback()
    global STATE
    STATE = 0;
    close(fig);
endfunction

//HELP FUNCTION
function [] = help_callback()
    messagebox(help_desc,'MircDAQ setup help');
endfunction

//FINAL SETUP FUNCTION
function [] = setup_callback ()
    //get paths from edit boxes
    CCSRoot = get(h(8),'String');
    CompilerRoot = get(h(11),'String');
    XDCRoot = get(h(14),'String');
    BIOSRoot = get(h(17),'String');

    //Lock setup button
    set(h(22),'Enable','off');
    set(h(22),'String','Building...');
    
    //build system
    TARGET_ROOT = dirname(get_function_path('microdaq_setup'))+"\..\etc";
    FILE_ROOT = dirname(get_function_path('microdaq_setup'))+"\..\rt_templates\target_paths.mk"

    cd(TARGET_ROOT+'\sysbios');
    
    sysbios_build_cmd = "SET PATH=" + XDCRoot + filesep() + "jre" + filesep() + "bin" + filesep() +";%PATH% & ";
    sysbios_build_cmd = sysbios_build_cmd + XDCRoot + filesep() + 'xs --xdcpath=""' + BIOSRoot + '/packages;' + CCSRoot + '/ccs_base;""' + ' xdc.tools.configuro -o configPkg -t ti.targets.elf.C674 -p ti.platforms.evmOMAPL137 -r release -c ' + CompilerRoot + ' --compileOptions ""-g --optimize_with_debug"" sysbios.cfg';
    disp("Building TI SYS/BIOS real-time operating system for MicroDAQ");
    
    unix_w(sysbios_build_cmd);


    //path to /configPkg/linker.cmd
    LINKER_PATH = TARGET_ROOT + '\sysbios\configPkg\linker.cmd';

    if isfile(LINKER_PATH) then

        [linker,err] = mopen(LINKER_PATH,'a')
        if err < 0 then
            messagebox('Building failed.','Building sys','error');
            set(h(22),'callback','close_callback','String','Close','Enable','on');
        else
            //Append 'sysbios_linker.cmd' to /configPkg/linker.cmd
            SYSBIOS_LINKER_PATH = TARGET_ROOT + '\sysbios\sysbios_linker.cmd';
            [sysbios_linker,err] = mopen(SYSBIOS_LINKER_PATH, 'r');
            content = mgetl(sysbios_linker);
            mclose(sysbios_linker)
            mputl(content,linker)
            mclose(linker);

            //Generate 'target_path.mk'
            [f,result0] = mopen(FILE_ROOT,'w');
            if result0 < 0 then
                messagebox('Building failed. Cannot create file ''target_path.mk'' ','Building sys','error');
                close_callback();
                return
            else
                mputl('# MicroDAQ paths',f)
                mputl('',f)
                mputl('CompilerRoot  = '+CompilerRoot,f)
                mputl('TargetRoot    = '+TARGET_ROOT,f)
                mputl('CCSRoot       = '+CCSRoot,f)
                mputl('XDCRoot       = '+XDCRoot,f)
                mputl('BIOSRoot      = '+BIOSRoot,f)
                mclose(f)
            end

            ip = get(h(20),'String')
            mdaq_set_ip(ip);

            //close window
            messagebox('Completed.','Building sys','info');
            //consol success message
            disp('');
            close_callback();
        end;

    else
        messagebox('Building failed.','Building sys','error');
        set(h(22),'callback','close_callback','String','Close','Enable','on');
    end;

endfunction

// ------------ UI -------------

//width of edit box
edit_w = 300;
//edit box start posisiton
edit_x = 12;
//window width
window_w = 400;
//window height
window_h = 460;
//object offset in x axis
x_offset = 30;
//object offset in y axis
y_offset = 40;
//text margin
t_margin = 15;
//font size
font_size = 12;

//frame label
lab1 = 'MicroDAQ Setup';

//General installation description
line1 = 'Setup wizard will configure MicroDAQ to work with Scilab. To use';
line2 = 'MicroDAQ package provide Code Composer Studio install paths and';
line3 = 'MicroDAQ device IP address. Select Help button for more info.';

help_desc = ['During installation user has to point where Code Composer Studio';
            'components are located. User has to select directories with:';
            '- Code Composer Studio 4/5 root directory';
            '- C6000 compiler';
            '- XDCTools';
            '- SYS/BIOS';
            '';
            'Example directory structure with standard Code Composer Studio installation:';
            'Code Composer Studio 4/5 install path → C:\ti\ccsv5';
            'C6000 compiler install path → C:\ti\ccsv5\tools\compiler\c6000_7.4.4';
            'XDCTools install path → C:\ti\xdctools_3_25_03_72';
            'SYS/BIOS RTOS install path → C:\ti\bios_6_35_04_50';
            '';
            'MicroDAQ Setup allows to check if connection with MicroDAQ device';
            'is OK. In order to test connection connect MicroDAQ with Ethernet';
            'cable, make sure that your IP address is in range with MicroDAQ IP';
            'settings and press Connection Test button.';
            ]

//First step
line4 = 'Code Composer Studio 4/5 install path:';
//Second step
line5 = 'C6000 compiler install path:';
//third step
line6 = 'XDCTools install path:';
//fourth step
line7 = 'SYS/BIOS RTOS install path:';
//ip setting
line8 = 'MicroDAQ IP address:';

if (getos() == "Linux") then
    default_path = "/opt/ti/"
else
    default_path = "C:\ti\"    
end

fig=figure(1,'figure_name','MicroDAQ Setup','position',[400 200 window_w window_h],'Backgroundcolor',[0.900000 0.900000 0.900000],"infobar_visible", "off", "toolbar_visible", "off", "dockable", "off", "menubar", "none");

//General Description
h(4)=uicontrol(fig,"Position",[t_margin window_h-50 window_w-t_margin-10 font_size+4],"Style","text","string",line1,"Horizontalalignment","left","Fontsize",font_size,"Backgroundcolor",[0.900000 0.900000 0.900000 ]);
h(5)=uicontrol(fig,"Position",[t_margin window_h-70 window_w-t_margin-10 font_size+4],"Style","text","string",line2,"Horizontalalignment","left","Fontsize",font_size,"Backgroundcolor",[0.900000 0.900000 0.900000 ]);
h(6)=uicontrol(fig,"Position",[t_margin window_h-90 window_w-t_margin-10 font_size+4],"Style","text","string",line3,"Horizontalalignment","left","Fontsize",font_size,"Backgroundcolor",[0.900000 0.900000 0.900000 ]);


//step 1 info
h(7)=uicontrol(fig,"Position",[t_margin window_h-130 window_w-t_margin-10 font_size+4],"Style","text","string",line4,"Horizontalalignment","left","Fontsize",font_size,"Backgroundcolor",[0.900000 0.900000 0.900000 ]);
//gui elements
h(8)=uicontrol(fig,"Position",[edit_x window_h-160 edit_x+edit_w 24],"callback","edit_callback1","Style","edit","string",default_path,"Tag","edit1","Horizontalalignment","left","Fontsize",12,"Backgroundcolor",[1.000000 1.000000 1.000000 ]);
h(9)=uicontrol(fig,"Position",[edit_w+x_offset window_h-160 50 24],"Style","pushbutton","string","...","callback","browse_dir_callback1","Horizontalalignment","center","Fontsize",12);

//y offset between steps = 50

//step 2 info
h(10)=uicontrol(fig,"Position",[t_margin window_h-190 window_w-t_margin-10 font_size+2],"Style","text","string",line5,"Horizontalalignment","left","Fontsize",font_size,"Backgroundcolor",[0.900000 0.900000 0.900000 ]);
//step 2 elements
h(11)=uicontrol(fig,"Position",[edit_x window_h-220 edit_x+edit_w 24],"callback","edit_callback2",'Enable','off',"Style","edit","string",default_path,"Tag","edit2","Horizontalalignment","left","Fontsize",12,"Backgroundcolor",[1.000000 1.000000 1.000000 ]);
h(12)=uicontrol(fig,"Position",[edit_w+x_offset window_h-220 50 24],'Enable','off',"Style","pushbutton","string","...","callback","browse_dir_callback2","Horizontalalignment","center","Fontsize",12);

//step 3 info
h(13)=uicontrol(fig,"Position",[t_margin window_h-250 window_w-t_margin-10 font_size+4],"Style","text","string",line6,"Horizontalalignment","left","Fontsize",font_size,"Backgroundcolor",[0.900000 0.900000 0.900000 ]);
//step 3 elements
h(14)=uicontrol(fig,"Position",[edit_x window_h-280 edit_x+edit_w 24],"callback","edit_callback3",'Enable','off',"Style","edit","string",default_path,"Tag","edit3","Horizontalalignment","left","Fontsize",12,"Backgroundcolor",[1.000000 1.000000 1.000000 ]);
h(15)=uicontrol(fig,"Position",[edit_w+x_offset window_h-280 50 24],'Enable','off',"Style","pushbutton","string","...","callback","browse_dir_callback3","Horizontalalignment","center","Fontsize",12);

//step 4 info
h(16)=uicontrol(fig,"Position",[t_margin window_h-310 window_w-t_margin-10 font_size+4],"Style","text","string",line7,"Horizontalalignment","left","Fontsize",font_size,"Backgroundcolor",[0.900000 0.900000 0.900000 ]);
//step 4 elements
h(17)=uicontrol(fig,"Position",[edit_x window_h-340 edit_x+edit_w 24],"callback","edit_callback4",'Enable','off',"Style","edit","string",default_path,"Tag","edit4","Horizontalalignment","left","Fontsize",12,"Backgroundcolor",[1.000000 1.000000 1.000000 ]);
h(18)=uicontrol(fig,"Position",[edit_w+x_offset window_h-340 50 24],'Enable','off',"Style","pushbutton","string","...","callback","browse_dir_callback4","Horizontalalignment","center","Fontsize",12);


//ip info
h(19)=uicontrol(fig,"Position",[t_margin window_h-370 window_w-t_margin-10 font_size+4],"Style","text","string",line8,"Horizontalalignment","left","Fontsize",font_size,"Backgroundcolor",[0.900000 0.900000 0.900000 ]);
//ip edit box
h(20)=uicontrol(fig,"Position",[edit_x window_h-400 edit_x+100 24],"Style","edit","string","10.10.1.1","Tag","edit1","Horizontalalignment","left","Fontsize",12,"Backgroundcolor",[1.000000 1.000000 1.000000 ]);
//connect button
h(21)=uicontrol(fig,"Position",[ edit_x+x_offset+100 window_h-400  130 24],"Style","pushbutton","string","Connection Test","callback","connect_callback","Horizontalalignment","center","Fontsize",12);

//final buton

h(22)=uicontrol(fig,"Position",[window_w/4 15 window_w/4-10 24],"Style","pushbutton","string","OK","callback","setup_callback","Horizontalalignment","center","Fontsize",12,'Enable','off');
h(23)=uicontrol(fig,"Position",[window_w/4*2 15 window_w/4-10 24],"Style","pushbutton","string","Cancel","callback","close_callback","Horizontalalignment","center","Fontsize",12,'Enable','on');
h(24)=uicontrol(fig,"Position",[window_w/4*3 15 window_w/4-10 24],"Style","pushbutton","string","Help","callback","help_callback","Horizontalalignment","center","Fontsize",12,'Enable','on');

