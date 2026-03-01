# Basic C Bootloader Skeleton

This project is a starter skeleton for a tiny x86 BIOS bootloader flow that we can refine step-by-step.

Current scope:
- Stage 1 boot sector (`src/boot.asm`) reads fixed stage2 sectors via BIOS `INT 13h`.
- Stage 1 prints basic boot status messages using BIOS teletype output (`INT 10h`).
- Stage 2 freestanding C code (`src/stage2.c`) as a placeholder.
- Minimal build system (`Makefile`) and linker script (`linker.ld`).

## Layout

- `src/boot.asm` - 16-bit boot sector entry.
- `src/stage2.c` - C stage placeholder with TODO hooks.
- `include/io.h` - simple low-level helpers for port I/O.
- `linker.ld` - places stage 2 at fixed load address.
- `Makefile` - builds a raw disk image.

## Build

```bash
make
```

Artifacts are generated under `build/`.

## Run (if QEMU is installed)

```bash
make run
```

## Notes

- This is intentionally a skeleton, not a complete production bootloader.
- Stage 1 currently assumes stage2 fits in 8 sectors and lives right after sector 1.
- Next iterations can add:
  - GDT setup and protected-mode transition
  - Real screen output and memory map probing
