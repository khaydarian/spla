include Makefile.toolchain

# Disable implicit rules
.SUFFIXES:

.PHONY: all
all: spla

.PHONY: clean
clean:
	rm -rf build/ spla

HDRS := build/ftdi.h $(wildcard *.h)
OBJS := build/ftdi.o $(patsubst %.c,build/%.o,$(wildcard *.c))

# libusn
LIBUSB_CFLAGS := -I/usr/include/libusb-1.0
LIBUSB_LIBS := -L/usr/lib/x86_64-linux-gnu -lusb-1.0

x:=$(shell mkdir -p build)

build/%.o: %.c $(HDRS)
	$(CC) $(CFLAGS) $(LIBUSB_CFLAGS) -Ibuild/ -c $< -o $@

spla: $(OBJS)
	$(LD) $(LDFLAGS) $^ -o $@ $(LIBUSB_LIBS)

build/ftdi.o: build/ftdi.c build/ftdi.h build/ftdi_i.h build/ftdi_version_i.h
	$(CC) -c $< $(LIBUSB_CFLAGS) -o $@

FTDI_EXTRACT := tar xjf ../third_party/libftdi1-1.4.tar.bz2
FTDI_SRC := libftdi1-1.4/src

build/ftdi.h:
	$(FTDI_EXTRACT) $(FTDI_SRC)/ftdi.h -O >$@

build/ftdi_i.h:
	$(FTDI_EXTRACT) $(FTDI_SRC)/ftdi_i.h -O >$@

build/ftdi_version_i.h:
	$(FTDI_EXTRACT) $(FTDI_SRC)/ftdi_version_i.h.in -O | sed 's/@MAJOR_VERSION@/1/;s/@MINOR_VERSION@/4/;s/@VERSION_STRING@/1.4/;s/@SNAPSHOT_VERSION@//;' >$@

build/ftdi.c:
	$(FTDI_EXTRACT) $(FTDI_SRC)/ftdi.c -O >$@
