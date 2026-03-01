; Minimal BIOS boot sector skeleton.
; Loads fixed-size stage2 from disk to 0x7E00 and jumps there.

BITS 16
ORG 0x7C00

start:
    mov [boot_drive], dl

    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00
    sti

    mov si, msg_loading
    call print_string

    mov si, DISK_RETRIES
.read_retry:
    ; BIOS INT 13h read:
    ; - CHS: cylinder=0, head=0, sector=2 (right after boot sector)
    ; - Count: STAGE2_SECTORS sectors
    ; - Destination: 0000:7E00
    mov ah, 0x02
    mov al, STAGE2_SECTORS
    mov ch, 0x00
    mov cl, 0x02
    mov dh, 0x00
    mov dl, [boot_drive]
    mov bx, 0x7E00
    int 0x13
    jnc load_ok

    ; Reset disk system, then retry read a few times.
    xor ah, ah
    mov dl, [boot_drive]
    int 0x13
    dec si
    jnz .read_retry
    jmp disk_error

load_ok:
    mov si, msg_ok
    call print_string
    jmp 0x0000:0x7E00

disk_error:
    mov si, msg_err
    call print_string
    cli
hang:
    hlt
    jmp hang

print_string:
    mov ah, 0x0E
.next:
    lodsb
    test al, al
    jz .done
    int 0x10
    jmp .next
.done:
    ret

boot_drive: db 0
STAGE2_SECTORS equ 8
DISK_RETRIES equ 3
msg_loading: db "Loading stage2...", 0
msg_ok:      db " OK", 13, 10, 0
msg_err:     db " ERR", 13, 10, 0

times 510-($-$$) db 0
dw 0xAA55
