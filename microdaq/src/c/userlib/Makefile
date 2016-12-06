
-include ../../../rt_templates/target_paths.mk
-include ../../../rt_templates/target_tools.mk

ifeq ($(OPT_FLAG),)
OPT_FLAG=-O2
else
OPT_FLAG=-g
endif

PRODUCT = userlib.lib

USER_INCLUDES = -Iscilab -I../../../etc/mdaqlib/
DSPLIB_INCLUDES = -Iscilab -I../../../etc/dsplib/
MATHLIB_INCLUDES = -Iscilab -I../../../etc/mathlib/

INCLUDES = -I. -DMODEL=userlib

INCLUDES += $(USER_INCLUDES) 
INCLUDES += $(DSPLIB_INCLUDES) 
INCLUDES += $(MATHLIB_INCLUDES) 

CFLAGS += $(subst \,/,$(INCLUDES))
CXXFLAGS += $(subst \,/,$(INCLUDES))

LDFLAGS := $(subst \,/,$(LDFLAGS))

SRCS = $(patsubst %.c, %.o, $(wildcard *.c))

OBJS = $(subst \,/,$(addsuffix $(OBJ_EXT), $(basename $(SRCS)))) 

all: $(PRODUCT)

.PHONY : all
all : $(PRODUCT)
	@echo "MicroDAQ User library $(PRODUCT) created successfully"

%.o: %.c
	$(CC) -c $(OPT_FLAG) $(CFLAGS) $< $(CCOUTPUTFLAG)$@ 

$(PRODUCT): $(OBJS)
	$(AR) $(ARFLAGS) $(PRODUCT) $(OBJS)
