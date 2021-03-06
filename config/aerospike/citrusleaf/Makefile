C_DEPTH = ..
DIR_INCLUDE_C =  $(C_DEPTH)/include/
DIR_INCLUDE_CF =  $(C_DEPTH)/../cf_base/include/
DIR_OBJECT = ./obj
CLEANALL = 1

AS_CFLAGS = -D_FILE_OFFSET_BITS=64 -std=gnu99 -D_REENTRANT
MARCH_NATIVE = $(shell uname -m)
CFLAGS_NATIVE = -g -O3 -fPIC -fno-common -fno-strict-aliasing -rdynamic -Wextra -Wno-missing-field-initializers $(AS_CFLAGS) -D MARCH_$(MARCH_NATIVE) -march=nocona
# Linux auto-sets to 64, MacOS doesn't
ifeq ($(SYSTEM),Darwin)
	CFLAGS_NATIVE += -v -D OSX
endif

LDFLAGS = -fPIC -shared
CC = gcc
C_LIB = $(C_DEPTH)/lib/libcitrusleaf.a
TARGET_S = _citrusleaf.so
SOURCE = citrusleaf.i

# Include path of each target language
#DIR_INCLUDE_PYTHON =  /usr/include/python2.6/
#DIR_INCLUDE_PERL   =  /usr/lib/perl/5.14/CORE/
DIR_INCLUDE_PYTHON = $(shell python -c 'from distutils import sysconfig as s; print s.get_config_vars()["INCLUDEPY"]')
DIR_INCLUDE_PERL   =  $(shell perl -MConfig -e 'print "$$Config{archlib}/CORE"')

# Target language name
LANG_PYTHON = python
LANG_PERL   = perl

# Extra options of each target needed during creation of object files
OPTS_CC_PYTHON   = 
OPTS_CC_PERL     = -D_GNU_SOURCE
OPTS_SWIG_PYTHON = 
OPTS_SWIG_PERL   = -const

# Setting default target based settings to PYTHON settings
DIR_INCLUDE_TARGET = $(DIR_INCLUDE_PYTHON)
OPTS_CC_TARGET     = $(OPTS_CC_PYTHON)
OPTS_SWIG_TARGET   = $(OPTS_SWIG_PYTHON)

# Setting default target based settings based on LANG param
ifeq ($(LANG),$(LANG_PYTHON))
	DIR_INCLUDE_TARGET = $(DIR_INCLUDE_PYTHON)
	OPTS_CC_TARGET     = $(OPTS_CC_PYTHON)
	OPTS_SWIG_TARGET   = $(OPTS_SWIG_PYTHON)
	TARGET_S           = _citrusleaf.so
endif
ifeq ($(LANG), $(LANG_PERL))
	DIR_INCLUDE_TARGET = $(DIR_INCLUDE_PERL)
	OPTS_CC_TARGET     = $(OPTS_CC_PERL)
	OPTS_SWIG_TARGET   = $(OPTS_SWIG_PERL)
	TARGET_S           = citrusleaf.so
endif


all: $(TARGET_S) putobj
	
$(TARGET_S): citrusleaf_wrap.o $(C_LIB)
	ld $(LDFLAGS) citrusleaf_wrap.o -lrt -lz -lssl $(C_LIB) -o $(LANG)/$(TARGET_S)

citrusleaf_wrap.o: citrusleaf_wrap.c $(DIR_INCLUDE_C)
	$(CC) $(CFLAGS_NATIVE) -c -I$(DIR_INCLUDE_C) -I$(DIR_INCLUDE_TARGET) $(OPTS_CC_TARGET) $< 

citrusleaf_wrap.c: $(SOURCE)
	mkdir -p $(LANG)
	swig -outdir $(LANG) -$(LANG) $(OPTS_SWIG_TARGET) $(SOURCE)

putobj: 
	mkdir -p $(DIR_OBJECT)
	mv *.o $(DIR_OBJECT)

clean: 
	rm -rf $(DIR_OBJECT)
	rm -rf citrusleaf_wrap.c
# Target specific cleaning
ifeq ($(LANG),$(LANG_PYTHON))
	rm -rf $(LANG)/*.so
	rm -rf $(LANG)/citrusleaf*
	rm -rf $(LANG)/*.pyc
CLEANALL = 0
endif

ifeq ($(LANG),$(LANG_PERL))
	#rm -rf $(LANG)/*.so
	#rm -rf $(LANG)/citrusleaf*
CLEANALL = 0
endif
# Add here for more languages

# Clean for all languages, if LANG is not defined
ifeq ($(CLEANALL),1)
	rm -rf $(LANG_PYTHON)/*.so
	rm -rf $(LANG_PYTHON)/citrusleaf*	
	rm -rf $(LANG_PYTHON)/*.pyc
	rm -rf $(LANG_PERL)/*.so
	rm -rf $(LANG_PERL)/citrusleaf*	
endif
