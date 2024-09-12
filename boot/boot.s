bits 16

%define KERNEL_SEGMENT 0x100

;; Code
section .text
_start:
    ;; Store boot drive number
    mov [driveNum], dl

    ;; Segment setup
    mov ax, 0
    mov ds, ax
    mov es, ax
    mov ss, ax  ; Setup stack
    mov sp, 0x7c00

    ;; Clear screen
    xor ah, ah
    mov al, 0x03
    int 0x10

    ;; Disable cursor
    mov ah, 0x01    ; Set cursor shape
    mov cx, 0x2607  ; Invisible cursor
    int 0x10

    ;; Load and run Kernel
    mov bx, KERNEL_SEGMENT
    mov es, bx
    xor bx, bx

    mov ch, 0   ; Cylinder
    mov dh, 0   ; Head
    mov cl, 2   ; Sector
    mov al, 10  ; Sector count 5kB
    mov dl, [driveNum]

    mov ah, 0x02
    int 0x13

    jc error

    mov ax, KERNEL_SEGMENT
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0xfffe

    jmp KERNEL_SEGMENT:0x0000 ; Far jump implicitly sets the code segment

error:
    mov si, errMsg
    mov ah, 0x0e
.printLoop:
    lodsb
    or al, al
    jz .done
    int 0x10
    jmp .printLoop
.done:
    cli
    hlt
    jmp .done

;; Data
section .data
driveNum: db 0
errMsg: db "Failed to read kernel!"

section .sign
dw 0xaa55

