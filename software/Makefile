include Makefile.toolchain

# Disable implicit rules
.SUFFIXES:

.PHONY: all
all: spla

.PHONY: clean
clean:
	rm -rf build/ spla

HDRS :=
OBJS := build/spla.o

x:=$(shell mkdir -p build)

LIBFTDI_LFLAGS := $(shell libftdi-config --libs)

build/%.o: %.c $(HDRS)
	$(CC) $(CCFLAGS) -c -o $@ $<

spla: $(OBJS)
	$(LD) $(LDCFLAGS) -o $@ $^ $(LIBFTDI_LFLAGS)
