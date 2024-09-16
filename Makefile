ifeq ($(strip $(PVSNESLIB_HOME)),)
$(error "Please create an environment variable PVSNESLIB_HOME by following this guide: https://github.com/alekmaul/pvsneslib/wiki/Installation")
endif

LIBSFX	:=	/opt/toolchains/snes/libSFX

SFXA	:=	$(LIBSFX)/tools/cc65/bin/ca65
SFXL	:=	$(LIBSFX)/tools/cc65/bin/ld65
libsfx_inc = $(LIBSFX)/include

SFXF	:=	-g -U -I ./ -I $(libsfx_inc) -I $(libsfx_inc)/Configurations -D TARGET_GSU
SFXFL	= --cfg-path ./

FXFILES := $(wildcard *.s)

include ${PVSNESLIB_HOME}/devkitsnes/snes_rules

.PHONY: bitmaps all clean

#---------------------------------------------------------------------------------
# ROMNAME is used in snes_rules file
export ROMNAME := superfx

all: clean compile_sgs bitmaps $(ROMNAME).sfc

clean: cleanBuildRes cleanRom cleanGfx clean_sgs

compile_sgs:
	cd ./superfx && make clean && make

clean_sgs:
	cd ./superfx && make clean


#---------------------------------------------------------------------------------
pvsneslibfont.pic: pvsneslibfont.png
	@echo convert font with no tile reduction ... $(notdir $@)
	$(GFXCONV) -s 8 -o 16 -u 16 -p -e 0 -i $<

bitmaps : pvsneslibfont.pic
