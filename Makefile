CC      := gcc
LD      := ld
AS      := nasm

BUILD_DIR := build
SRC_DIR   := src
INC_DIR   := include

BOOT_BIN  := $(BUILD_DIR)/boot.bin
STAGE2_ELF := $(BUILD_DIR)/stage2.elf
STAGE2_BIN := $(BUILD_DIR)/stage2.bin
IMAGE_BIN := $(BUILD_DIR)/os-image.bin

CFLAGS  := -m32 -ffreestanding -fno-pie -fno-pic -nostdlib -nostartfiles -Wall -Wextra -I$(INC_DIR)
LDFLAGS := -m elf_i386 -T linker.ld -nostdlib

.PHONY: all clean run

all: $(IMAGE_BIN)

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(BOOT_BIN): $(SRC_DIR)/boot.asm | $(BUILD_DIR)
	$(AS) -f bin $< -o $@

$(BUILD_DIR)/stage2.o: $(SRC_DIR)/stage2.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

$(STAGE2_ELF): $(BUILD_DIR)/stage2.o linker.ld
	$(LD) $(LDFLAGS) $< -o $@

$(STAGE2_BIN): $(STAGE2_ELF)
	objcopy -O binary $< $@

$(IMAGE_BIN): $(BOOT_BIN) $(STAGE2_BIN)
	cat $(BOOT_BIN) $(STAGE2_BIN) > $@

run: $(IMAGE_BIN)
	qemu-system-i386 -drive format=raw,file=$(IMAGE_BIN)

clean:
	rm -rf $(BUILD_DIR)
