CC      := gcc
LD      := ld
AS      := nasm

BUILD_DIR := build
SRC_DIR   := src
INC_DIR   := include

BOOT_BIN  := $(BUILD_DIR)/boot.bin
STAGE2_ELF := $(BUILD_DIR)/stage2.elf
STAGE2_BIN := $(BUILD_DIR)/stage2.bin
STAGE2_PAD_BIN := $(BUILD_DIR)/stage2.padded.bin
IMAGE_BIN := $(BUILD_DIR)/os-image.bin
STAGE2_SECTORS := 8
STAGE2_MAX_BYTES := $(shell expr $(STAGE2_SECTORS) \* 512)

CFLAGS  := -m16 -ffreestanding -fno-pie -fno-pic -fno-stack-protector -nostdlib -nostartfiles -Wall -Wextra -I$(INC_DIR)
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

$(STAGE2_PAD_BIN): $(STAGE2_BIN)
	@size=$$(stat -c%s "$<"); \
	if [ $$size -gt $(STAGE2_MAX_BYTES) ]; then \
		echo "stage2 too large: $$size bytes (max $(STAGE2_MAX_BYTES))"; \
		exit 1; \
	fi
	cp "$<" "$@"
	truncate -s $(STAGE2_MAX_BYTES) "$@"

$(IMAGE_BIN): $(BOOT_BIN) $(STAGE2_PAD_BIN)
	cat $(BOOT_BIN) $(STAGE2_PAD_BIN) > $@

run: $(IMAGE_BIN)
	qemu-system-i386 -drive format=raw,file=$(IMAGE_BIN)

clean:
	rm -rf $(BUILD_DIR)
