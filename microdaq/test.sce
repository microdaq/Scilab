        mprintf("\nFor more help on MicroDAQ toolbox, DSP managment functions, C code integration\ntools and other MicroDAQ toolbox features see help (help microdaq).\n\n");
        mprintf("WARNING: MicroDAQ toolbox ver 1.2.x requires firmware ver 2.0.0 or higher.\n\t Make sure that latest firmware has been installed. Link to latest\n\t firmware version https://github.com/microdaq/Firmware\n\n\t TI Code Composer Studio 5.x is no longer supported. Please install\n\t proper C6000 compiler, XDC tools and SYS/BIOS according to \n\t microdaq_setup installer (help button).\n")
        sci_ver(1) = 6
        if sci_ver(1) == 5 then 
            mprintf("\nRun microdaq_setup to configure toolbox:\n\tmicrodaq_setup() - GUI mode\n\tmicrodaq_setup(compilerPath, xdctoolsPath, sysbiosPath, ipAddress) - non-GUI mode");
        end

            
            mprintf("\nWARNING: MicroDAQ toolbox on Scilab 6.0 has limited functionality. \n\tCode generation from Xcos diagram, DSP management functions\n\tand legacy C code integration is not supported.\n\tUse Scilab 5.5.2 to have full-featured MicroDAQ toolbox for Scilab\n");
            mprintf("\nRun microdaq_setup to configure toolbox:\n\tmicrodaq_setup(ipAddress)"); 
