
CC = ${PVSNESLIB_HOME}/devkitsnes/bin/wla-superfx
CFLAGS = -v -i -o
LD = ${PVSNESLIB_HOME}/devkitsnes/bin/wlalink
LDFLAGS = -v -i -s

SFILES = plotPixel.s
IFILES = 
OFILES = plotPixel.ofx

all: plotPixel.bin

plotPixel.bin: $(OFILES) makefile
	$(LD) $(LDFLAGS) linkfile plotPixel.bin

plotPixel.ofx: plotPixel.s
	$(CC) $(CFLAGS) plotPixel.ofx plotPixel.s

$(OFILES): $(HFILES)


clean:
	rm -f $(OFILES) core *~ plotPixel.bin plotPixel.sym *.lst

