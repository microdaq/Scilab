﻿// Copyright (c) 2015, Embedded Solutions
// All rights reserved.

// This file is released under the 3-clause BSD license. See COPYING-BSD.

mode(-1)
global STATE
STATE = 1

titbx_path = "";
if getos() == 'Linux' then 
    titbx_path = pathconvert("/opt/");
elseif getos() == 'Windows' then 
    titbx_path = pathconvert("C:\");
end

disp(titbx_path);

//DIRECTORY BROWSER FUNCTIONS
function [] = browse_dir_callback2()
    directory = uigetdir(titbx_path)
    
    if directory <> "" then
        set(h(11),'String', directory);
        set(h(14),'Enable','on')
        set(h(15),'Enable','on')
    end
endfunction

function [] = browse_dir_callback3()
    directory = uigetdir(titbx_path)
    
    if directory <> "" then
        set(h(14),'String',directory)
        set(h(17),'Enable','on')
        set(h(18),'Enable','on')
    end
endfunction

function [] = browse_dir_callback4()
    directory = uigetdir(titbx_path)
   
    if directory <> "" then
        set(h(17),'String',directory)
        set(h(22),'Enable','on')
    end
endfunction

//EDIT BOX CALLBACK
//function [] = edit_callback1()
//    set(h(11),'Enable','on')
//    set(h(12),'Enable','on')
//endfunction

function [] = edit_callback2()
    directory  = get(h(11),'String')
    if isdir(directory) then
        set(h(14),'Enable','on')
        set(h(15),'Enable','on')
    else
        warning("C6000 compiler install path: Specified folder could not be found.");
    end
endfunction

function [] = edit_callback3()
    directory  = get(h(14),'String')
    if isdir(directory) then
        set(h(17),'Enable','on')
        set(h(18),'Enable','on')
    else
        warning("XDCTools install path: Specified folder could not be found.");
    end
endfunction

function [] = edit_callback4()
    directory  = get(h(17),'String')
    if isdir(directory) then
        set(h(22),'Enable','on')
    else
        warning("SYS/BIOS RTOS install path: Specified folder could not be found.");
    end
endfunction

//CHECK CONNECTION FUNCTION
function [] = connect_callback()
    set(h(21),'Enable','off')
    ip = get(h(20),'String')
    mdaq_set_ip(ip);

    result = mdaq_open();
    if result < 0  then
        messagebox('Unable to connect to MicroDAQ device!','Error','error')
        set(h(21),'Enable','on')
    else
        global %microdaq;
        messagebox(%microdaq.model + ' connected!','MicroDAQ info','info');
        set(h(21),'Enable','on')
      
        mdaq_close(result);
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
    CompilerRoot = getshortpathname(pathconvert(get(h(11),'String'), %F));
    XDCRoot = getshortpathname(pathconvert(get(h(14),'String'), %F));
    BIOSRoot = getshortpathname(pathconvert(get(h(17),'String'), %F));

    //Lock setup button
    set(h(22),'Enable','off');
    set(h(22),'String','Building...');

    dir_temp = pwd(); 

    //build system
    TARGET_ROOT = pathconvert(dirname(get_function_path('microdaq_setup'))+"\..\etc", %F);
    FILE_ROOT = pathconvert(dirname(get_function_path('microdaq_setup'))+"\..\rt_templates\target_paths.mk", %F);

    sysbios_build_cmd = 'SET PATH=' + pathconvert(XDCRoot + "/jre/bin/") + ';%PATH% & ';
    sysbios_build_cmd = sysbios_build_cmd + XDCRoot + filesep() + 'xs --xdcpath=""' + BIOSRoot + filesep() +'packages' + '""; xdc.tools.configuro -o configPkg -t ti.targets.elf.C674 -p ti.platforms.evmOMAPL137 -r release -c ' + CompilerRoot + ' --compileOptions ""-g --optimize_with_debug""  sysbios.cfg'
    
    sysbios_build_cmd = strsubst(sysbios_build_cmd, filesep()+filesep(), filesep());

    disp("Building TI SYS/BIOS real-time operating system for MicroDAQ");
    cd( TARGET_ROOT+ filesep() + 'sysbios' + filesep() + 'cpu0' + filesep());
    unix_w(sysbios_build_cmd);
    cd( TARGET_ROOT+ filesep() + 'sysbios' + filesep() + 'cpu1' + filesep());
    unix_w(sysbios_build_cmd);

    //path to /configPkg/linker.cmd
    LINKER0_PATH = pathconvert(TARGET_ROOT + '\sysbios\cpu0\configPkg\linker.cmd', %F);
    LINKER1_PATH = pathconvert(TARGET_ROOT + '\sysbios\cpu1\configPkg\linker.cmd', %F);

    if isfile(LINKER0_PATH) then
        [linker0,err] = mopen(LINKER0_PATH,'a')
        [linker1,err] = mopen(LINKER1_PATH,'a')
        if err < 0 then
            messagebox('Building failed.','Building sys','error');
            set(h(22),'callback','close_callback','String','Close','Enable','on');
        else
            //Append 'sysbios_linker.cmd' to /configPkg/linker.cmd
            SYSBIOS_LINKER_PATH = pathconvert(TARGET_ROOT + '\sysbios\sysbios_linker.cmd', %F);
            [sysbios_linker,err] = mopen(SYSBIOS_LINKER_PATH, 'r');
            content = mgetl(sysbios_linker);
            mclose(sysbios_linker)
            mputl(content,linker0)
            mputl(content,linker1)
            mclose(linker0);
            mclose(linker1);

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

            cd(dir_temp);
            close_callback();
        end;

    else
        cd(dir_temp);
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
line1 = 'The microdaq_setup wizard will configure MicorDAQ device to work';
line2 = 'with Scilab. Install TI Code Composer Studio 4/5 and connect your'
line3 = 'MicroDAQ device. Select Help button for more info.';

help_paths = [
'C6000 compiler install path → ti\ccsv5\tools\compiler\c6000_7.4.4';
'XDCTools install path → ti\xdctools_3_25_03_72';
'SYS/BIOS RTOS install path → ti\bios_6_35_04_50';
];


if getos() == 'Linux' then 
    help_paths = [
    'C6000 compiler install path → /opt/ti/ccsv5/tools/compiler/c6000_7.4.4';
    'XDCTools install path → /opt/ti/xdctools_3_25_03_72';
    'SYS/BIOS RTOS install path → /opt/ti/bios_6_35_04_50';
    ];
elseif getos() == 'Windows' then 
    help_paths = [
    'C6000 compiler install path → C:\ti\ccsv5\tools\compiler\c6000_7.4.4';
    'XDCTools install path → C:\ti\xdctools_3_25_03_72';
    'SYS/BIOS RTOS install path → C:\ti\bios_6_35_04_50';
    ];
end


help_desc = ['Check your IP settings and verify connection with MicroDAQ'; 
'device with system ''ping'' command.';
'During installation point where Code Composer Studio';
'components are located. User has to provide directories with:';
'- C6000 compiler';
'- XDCTools';
'- SYS/BIOS';
'';
'Example directory structure with standard Code Composer Studio installation:';
help_paths;
'';
'More info is available on website: ';
'https://github.com/microdaq/Scilab';
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

default_path = titbx_path;

fig=figure(1,'figure_name','MicroDAQ Setup','position',[400 200 window_w window_h],'Backgroundcolor',[0.900000 0.900000 0.900000],"infobar_visible", "off", "toolbar_visible", "off", "dockable", "off", "menubar", "none");

//General Description
h(4)=uicontrol(fig,"Position",[t_margin window_h-50 window_w-t_margin-10 font_size+4],"Style","text","string",line1,"Horizontalalignment","left","Fontsize",font_size,"Backgroundcolor",[0.900000 0.900000 0.900000 ]);
h(5)=uicontrol(fig,"Position",[t_margin window_h-70 window_w-t_margin-10 font_size+4],"Style","text","string",line2,"Horizontalalignment","left","Fontsize",font_size,"Backgroundcolor",[0.900000 0.900000 0.900000 ]);
h(6)=uicontrol(fig,"Position",[t_margin window_h-90 window_w-t_margin-10 font_size+4],"Style","text","string",line3,"Horizontalalignment","left","Fontsize",font_size,"Backgroundcolor",[0.900000 0.900000 0.900000 ]);


//step 1 info
//h(7)=uicontrol(fig,"Position",[t_margin window_h-130 window_w-t_margin-10 font_size+4],"Style","text","string",line4,"Horizontalalignment","left","Fontsize",font_size,"Backgroundcolor",[0.900000 0.900000 0.900000 ]);
//gui elements
//h(8)=uicontrol(fig,"Position",[edit_x window_h-160 edit_x+edit_w 24],"callback","edit_callback1","Style","edit","string",default_path,"Tag","edit1","Horizontalalignment","left","Fontsize",12,"Backgroundcolor",[1.000000 1.000000 1.000000 ]);
//h(9)=uicontrol(fig,"Position",[edit_w+x_offset window_h-160 50 24],"Style","pushbutton","string","...","callback","browse_dir_callback1","Horizontalalignment","center","Fontsize",12);
//
//y offset between steps = 50

//step 2 info
h(10)=uicontrol(fig,"Position",[t_margin window_h-130 window_w-t_margin-10 font_size+2],"Style","text","string",line5,"Horizontalalignment","left","Fontsize",font_size,"Backgroundcolor",[0.900000 0.900000 0.900000 ]);
//step 2 elements
h(11)=uicontrol(fig,"Position",[edit_x window_h-160 edit_x+edit_w 24],"callback","edit_callback2",'Enable','on',"Style","edit","string",default_path,"Tag","edit2","Horizontalalignment","left","Fontsize",12,"Backgroundcolor",[1.000000 1.000000 1.000000 ]);
h(12)=uicontrol(fig,"Position",[edit_w+x_offset window_h-160 50 24],'Enable','on',"Style","pushbutton","string","...","callback","browse_dir_callback2","Horizontalalignment","center","Fontsize",12);

//step 3 info
h(13)=uicontrol(fig,"Position",[t_margin window_h-190 window_w-t_margin-10 font_size+4],"Style","text","string",line6,"Horizontalalignment","left","Fontsize",font_size,"Backgroundcolor",[0.900000 0.900000 0.900000 ]);
//step 3 elements
h(14)=uicontrol(fig,"Position",[edit_x window_h-220 edit_x+edit_w 24],"callback","edit_callback3",'Enable','off',"Style","edit","string",default_path,"Tag","edit3","Horizontalalignment","left","Fontsize",12,"Backgroundcolor",[1.000000 1.000000 1.000000 ]);
h(15)=uicontrol(fig,"Position",[edit_w+x_offset window_h-220 50 24],'Enable','off',"Style","pushbutton","string","...","callback","browse_dir_callback3","Horizontalalignment","center","Fontsize",12);

//step 4 info
h(16)=uicontrol(fig,"Position",[t_margin window_h-250 window_w-t_margin-10 font_size+4],"Style","text","string",line7,"Horizontalalignment","left","Fontsize",font_size,"Backgroundcolor",[0.900000 0.900000 0.900000 ]);
//step 4 elements
h(17)=uicontrol(fig,"Position",[edit_x window_h-280 edit_x+edit_w 24],"callback","edit_callback4",'Enable','off',"Style","edit","string",default_path,"Tag","edit4","Horizontalalignment","left","Fontsize",12,"Backgroundcolor",[1.000000 1.000000 1.000000 ]);
h(18)=uicontrol(fig,"Position",[edit_w+x_offset window_h-280 50 24],'Enable','off',"Style","pushbutton","string","...","callback","browse_dir_callback4","Horizontalalignment","center","Fontsize",12);


//ip info
h(19)=uicontrol(fig,"Position",[t_margin window_h-370 window_w-t_margin-10 font_size+4],"Style","text","string",line8,"Horizontalalignment","left","Fontsize",font_size,"Backgroundcolor",[0.900000 0.900000 0.900000 ]);
//ip edit box
h(20)=uicontrol(fig,"Position",[edit_x window_h-400 edit_x+100 24],"Style","edit","string","10.10.1.1","Tag","edit1","Horizontalalignment","left","Fontsize",12,"Backgroundcolor",[1.000000 1.000000 1.000000 ]);
//connect button
h(21)=uicontrol(fig,"Position",[ edit_x+x_offset+100 window_h-400  130 24],"Style","pushbutton","string","Test connection","callback","connect_callback","Horizontalalignment","center","Fontsize",12);

//final buton

h(22)=uicontrol(fig,"Position",[window_w/4 15 window_w/4-10 24],"Style","pushbutton","string","OK","callback","setup_callback","Horizontalalignment","center","Fontsize",12,'Enable','off');
h(23)=uicontrol(fig,"Position",[window_w/4*2 15 window_w/4-10 24],"Style","pushbutton","string","Cancel","callback","close_callback","Horizontalalignment","center","Fontsize",12,'Enable','on');
h(24)=uicontrol(fig,"Position",[window_w/4*3 15 window_w/4-10 24],"Style","pushbutton","string","Help","callback","help_callback","Horizontalalignment","center","Fontsize",12,'Enable','on');

