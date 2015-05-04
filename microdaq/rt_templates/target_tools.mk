# Target Tool Specification Makefile (target_tools.mk)

# Compiler command and options
CC = "$(CompilerRoot)/bin/cl6x"
CFLAGS = -mv6740 --abi=eabi --include_path="$(CompilerRoot)/include" \
         --define=omapl137 --include_path="$(XDCRoot)/packages" \
         --include_path="$(BIOSRoot)/packages" \
         --display_error_number --diag_warning=225 --diag_wrap=off

CFLAGS += $(EXT_CC_OPTS) $(OPTS)
CDEBUG = -g
CFLAGS_OPT= -O2
CCOUTPUTFLAG = --output_file=

CXX      =
CXXFLAGS =
CXXDEBUG =

# Linker command and options
LD      = $(CC)
LDFLAGS = -mv6740 --abi=eabi --define=omapl137 \
          --display_error_number --diag_warning=225 --diag_wrap=off \
          -z --stack_size=0x800 -m"$(MODEL).map" --heap_size=0x800 \
          -i"$(CompilerRoot)/lib" -i"$(CompilerRoot)/include" \
          --reread_libs --define=DSP_CORE=1 --warn_sections --rom_model \
          -l"$(TargetRoot)/sysbios/configPkg/linker.cmd" -l"libc.a"

LDFLAGS_EXTMODE =
LDDEBUG =
LDOUTPUTFLAG = --output_file=

# Archiver command and options
AR      = "$(CompilerRoot)/bin/ar6x"
ARFLAGS = -r

# Binary file format converter command and options
OBJCOPY      = 
OBJCOPYFLAGS = 

# Specify the output extension from compiler
OBJ_EXT = .o

# Specify extension from linker
PROGRAM_FILE_EXT = .out 

# Specify extension for final product at end of build
EXE_FILE_EXT     = $(PROGRAM_FILE_EXT)
