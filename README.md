MicroDAQ toolbox for Scilab
============
Develop real-time control and measurement aplication for free!

Descprition
============
MicroDAQ toolbox conbines Scilab/XCos environment with Embedded Solutions MicroDAQ real-time control measurement system equpted with TI C6000 DSP. Module extends Scilab by allowing user to automatically generate DSP applications directly from XCos scheme. User can use custom XCos blocks which gives access to MicroDAQ hardware (ADC, DAC, DIO, PWM, UART, Quadrature Encoder). Generated DSP application utilizes SYS/BIOS real-time opearting system combined with code generated from XCos scheme.

Key Features
============
* Real-time code generation for Texas Instruments C6000 DSPs 
* Code generation from Xcos model 
* Standalone model generation
* Blocks for MicroDAQ analog and digital I/O
* DSP data live access with standard Xcos sinks
* Execution profiling 
* Integration with LabVIEW 
* Windows and Linux support
* Block generator for custom/legacy user code 

Required software (dependencies)
================================
* [Scilab 5.5.2](http://www.scilab.org) or Scilab 6.0 (free)
* [C6000 compiler (ver. 7.4.21)](http://software-dl.ti.com/codegen/non-esd/downloads/download.htm#C6000) 
* [SYS/BIOS (ver. 6.50.01.12)](http://software-dl.ti.com/dsps/dsps_public_sw/sdo_sb/targetcontent/sysbios/6_50_01_12/index_FDS.html)
* [XDCTools (ver. 3.50.00.10)](http://software-dl.ti.com/dsps/dsps_public_sw/sdo_sb/targetcontent/rtsc/3_50_00_10/index_FDS.html)
* 
Installation
============
This package is integrated with Scilab Atoms installer. In order to use toolbox download Scilab software (version 5.5.2 or newer) and run atomsInstall('microdaq') from Scilab console. After MicroDAQ toolbox start run microdaq_setup to configure compiler and IP settings.

* [MicroDAQ toolbox Atoms website](http://atoms.scilab.org/toolboxes/microdaq)

Known Issues
============
* Only one Signal block supported when running model from external application or Scilab script


Release Notes
==============
Added:
* Analog input/output scan functions for data acquisition
* Custom blocks host compilation 
* Hardware detection in XCos blocks and HW access functions 
* Partial support for Scilab 6.0.0 (without XCos features, DSP management)
* Mac OS support X

Fixed:
* Windows 10 support 
* E1100 ADC02 configuration
* Gaps in MicroDAQ help 


Full changelog can be found  in [here](http://software-dl.ti.com/codegen/non-esd/downloads/download.htm#C6000").

How to report bugs?
===========
If you find a bug, please report it on our [issue section](https://github.com/microdaq/Scilab/issues) with a short description how to reproduce it. To help us to identify source of the problem attach MicorDAQ log file in your report. 

Exmaple: 
* Generate log file using mdaq command in Scilab console
`mdaq_log(pathToLogFile)` - function will create logfile in provided path 

* Write a short description and attach a log file
![alt text](https://raw.githubusercontent.com/microdaq/Scilab/1.2v/microdaq/help/en_US/images/bug-report.png)
