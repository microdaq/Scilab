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

Installation
============
This package is integrated with Scilab Atoms installer. In order to use toolbox download Scilab software (version 5.4 or newer) and run atomsInstall('microdaq') from Scilab console. After MicroDAQ toolbox start run microdaq_setup to configure compiler and IP settings.

* [MicroDAQ toolbox Atoms website](http://atoms.scilab.org/toolboxes/microdaq)

Known Issues
============

* Xcos context doesn't work with code generation
* Only one Signal block supported when running model from external application or Scilab script
* Missing help for blocks and functions
* Demos for MicroDAQ blocks

Support
=======

This package is support by Embedded Solutions. Issues and problems with software can be raported on: 

        support@embedded-solutions.pl

Required software (dependencies)
================================
* [Scilab 5.4](http://www.scilab.org) or Scilab 6.0 (free)
* [Texas Instruments Code Composer Studio 5.5](http://processors.wiki.ti.com/index.php/Download_CCS#Code_Composer_Studio_Version_5_Downloads) with SYS/BIOS and C6000 compiler installed (free with XDX100 emulator license)
