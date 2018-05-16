SOURCES= $(wildcard *.c)
ELFS=$(SOURCES:.c=.elf)
ASM=$(SOURCES:.c=.s)
DMP=$(SOURCES:.c=.d)
RAW=$(SOURCES:.c=.raw)
BIN=$(SOURCES:.c=.bin)
X=$(SOURCES:.c=.x)

# 2016-05 version
CC = mips-linux-gnu-gcc 
OBJDUMP = mips-linux-gnu-objdump
OBJCOPY = mips-linux-gnu-objcopy
# Old version of toolchain
#CC = mips-sde-elf-gcc
#OBJDUMP = mips-sde-elf-objdump
#OBJCOPY = mips-sde-elf-objcopy

CFLAGS = -static -EB -nostdlib -nostartfiles -O0 -fno-delayed-branch -fomit-frame-pointer
CORE = -mips32

all: $(ELFS) $(ASM) $(DMP) $(BIN) $(RAW) $(X)
	
%.elf: %.c
	@echo "ELF-ing $^"
	$(CC) $(CORE) $(CFLAGS) -o $@ $^ -T ece429.ld

%.s: %.c
	@echo "S-ing $^"
	$(CC) $(CORE) $(CFLAGS) -S $^ -T ece429.ld

%.d: %.elf
	$(OBJDUMP) -D $^ > $@

%.bin: %.elf
	$(OBJCOPY) -O binary $^ $@

%.raw: %.bin
	od -Ax -tx $^ > $@

%.x: %.raw
	./mk-bin.py $^ > $@

clean:
	rm -f *.o core *.elf *.bin *.raw *.x 

rebuild: clean build
