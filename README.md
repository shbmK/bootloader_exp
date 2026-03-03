# Basic C Bootloader Skeleton - #BasicBoot

This project is a starter skeleton for a tiny x86 BIOS bootloader flow that we can refine step-by-step.

Current scope:
- Stage 1 boot sector (`src/boot.asm`) reads fixed stage2 sectors via BIOS `INT 13h`.
- Stage 1 prints basic boot status messages using BIOS teletype output (`INT 10h`).
- Stage 2 freestanding C code (`src/stage2.c`) writes a VGA banner and emits debug bytes to port `0xE9`.
- Minimal build system (`Makefile`) and linker script (`linker.ld`).

## Layout

- `src/boot.asm` - 16-bit boot sector entry.
- `src/stage2.c` - C stage placeholder with TODO hooks.
- `include/io.h` - simple low-level helpers for port I/O.
- `linker.ld` - places stage 2 at fixed load address.
- `Makefile` - builds a raw disk image.

## Build

Prerequisites:
- `nasm`
- `gcc` (with 32/16-bit capable toolchain)
- `binutils` (`ld`, `objcopy`)
- `qemu-system-i386` (for running)

```bash
make
```

Artifacts are generated under `build/`.

## Run (if QEMU is installed)

```bash
make run
```

You should see stage1 text like:
- `Loading stage2... OK` on successful read/jump
- `Loading stage2... ERR` if read fails after retries

The stage1 loader currently retries disk reads 3 times with BIOS disk reset between attempts.
The build also verifies Stage 2 fits in 8 sectors (4096 bytes) and pads it to fixed size.

## Quick setup examples

Arch Linux:
```bash
sudo pacman -S --needed nasm gcc binutils qemu-system-i386
```

Debian/Ubuntu:
```bash
sudo apt update
sudo apt install -y nasm gcc binutils qemu-system-x86
```

## Notes

- This is intentionally a skeleton, not a complete production bootloader.
- Stage 1 currently assumes stage2 fits in 8 sectors and lives right after sector 1.
- Next iterations can add:
  - GDT setup and protected-mode transition
  - Real screen output and memory map probing
