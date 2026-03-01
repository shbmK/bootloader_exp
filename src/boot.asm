; Minimal BIOS boot sector skeleton.
; This is intentionally tiny; disk-loading logic is a TODO.

BITS 16
ORG 0x7C00

start:
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00
    sti

    ; TODO: load stage2 from disk to 0x7E00, then jump there.
    ; For now this skeleton just hangs.
hang:
    hlt
    jmp hang

times 510-($-$$) db 0
dw 0xAA55
