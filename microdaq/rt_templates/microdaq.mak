# MicroDAQ specific tokens
MICRODAQ_DOWNLOAD   	= 1
ON_TARGET_WAIT_FOR_STARTM   = 1

# Enable debugging
STRIP_BUILD         	= $$STRIP$$

MODEL                   = $$MODEL$$
MDAQLIB			= $$MDAQLIB$$
USERLIB			= $$USERLIB$$
SCILABLIB		= $$SCILABLIB$$
MODULES                 = $$MICRODAQ_MAIN$$ common.c $$MODEL$$.c $$FILES$$ $$SMCUBE_FILES$$
MAKEFILE                = Makefile
NUMST                   = 1
NCSTATES                = 0
B_ERTSFCN               = 0
EXT_MODE                = 0
TMW_EXTMODE_TESTING     = 0
EXTMODE_TRANSPORT       = 0
CPU_OPTION				= $$CPUOPT$$


#--------------------- Autogenerated paths makefile ----------------------------
-include $$TARGET_PATHS$$ 

#--------------------- Handwritten tools makefile ------------------------------
-include $$TARGET_TOOLS$$ 

#------------------------------ Includes -------------------------------------
# Place -I options here
USER_INCLUDES = -I$(MDAQLIB)\ -I$(SCILABLIB)\include 

INCLUDES = -I. -DMODEL=$(MODEL)

INCLUDES += $(USER_INCLUDES) 

CFLAGS += $(subst \,/,$(INCLUDES))
CXXFLAGS += $(subst \,/,$(INCLUDES))

LDFLAGS += -l"$(TargetRoot)/sysbios/$(CPU_OPTION)/configPkg/linker.cmd"
LDFLAGS += -l"libc.a"

ifeq ($(STRIP_BUILD), 1)
	LDFLAGS += -l$(MDAQLIB)\mdaq_blocks.lib
	LDFLAGS += -l$(MDAQLIB)\microdaq.lib
else
	LDFLAGS += -l$(MDAQLIB)\mdaq_blocks_debug.lib
	LDFLAGS += -l$(MDAQLIB)\microdaq_debug.lib
endif 

LDFLAGS += -l$(USERLIB)\lib\userlib.lib
LDFLAGS += -l$(SCILABLIB)\lib\libsciscicos_blocks.lib
LDFLAGS += -l$(SCILABLIB)\lib\liblapack.lib
LDFLAGS := $(subst \,/,$(LDFLAGS))

#--------------------- SMCube external files ------------------------------
# this is present only if a SMCube block uses external files
-include smcube-ext-files\smcube-ext-files.mk

#-------------------------------- Target application --------------------------------------
# Define the target file
PRODUCT = $(MODEL)$(PROGRAM_FILE_EXT)

#-------------- Source Files, Object Files and Dependency Files -----------
SRCS += $(MODULES)

OBJS = $(subst \,/,$(addsuffix $(OBJ_EXT), $(basename $(SRCS)))) 

#-------------- Default target -----------
all: $(PRODUCT)

# Need a rule to generate the build success string if product was already up to date
.PHONY : all
all : $(PRODUCT)
	@echo "MicroDAQ DSP application $(PRODUCT)created successfully"

#----------------------------- Dependencies ------------------------------------

%.o: %.c
	$(CC) -c $$BUILD_MODE%% $(CFLAGS) $< $(CCOUTPUTFLAG)$@ 

$(PRODUCT): $(OBJS)
	$(CC) $(LDFLAGS) $(OBJS) $(CCOUTPUTFLAG)$(PRODUCT) 
ifeq ($(STRIP_BUILD), 1)
	@$(STRIP) $(PRODUCT)
endif
