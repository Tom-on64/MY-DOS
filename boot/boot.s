bits 16

%define KERNEL_SEGMENT  0x100   ; 0x1000

;; Code
section .text
_start:
    ;; Store boot drive number
    mov [driveNum], dl

    ;; Segment setup
    mov ax, 0
    mov ds, ax  ; Data segment
    mov es, ax  ; Extra segment     (GP)
    mov gs, ax  ; General segment   (GP)
    mov fs, ax  ; Filesys segment   (GP)
    mov ss, ax  ; Stack segment
    mov sp, 0x7c00

    ;; Clear screen
    xor ah, ah
    mov al, 0x03
    int 0x10

    ;; Disable cursor
    mov ah, 0x01    ; Set cursor shape
    mov cx, 0x2607  ; Invisible cursor
    int 0x10

    ;; Check if LBA is supported
    mov si, lbaErr
    mov ah, 0x41
    mov bx, 0x55aa
    mov dl, [driveNum]
    int 0x13
    jc error

    ;; Load and run Kernel
    mov bx, KERNEL_SEGMENT
    mov es, bx
    xor bx, bx

    mov ch, 0   ; Cylinder
    mov dh, 0   ; Head
    mov cl, 4   ; Sector
    mov al, 10  ; Sector count 5kB
    mov dl, [driveNum]

    mov ah, 0x02
    int 0x13

    mov si, errMsg
    jc error

    mov dl, [driveNum]

    mov ax, KERNEL_SEGMENT
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0xfffe

    jmp KERNEL_SEGMENT:0x0000 ; Far jump implicitly sets the code segment

;; Prints a string
;; si - error message
error:
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
errMsg: db "Failed to read kernel!",0
lbaErr: db "LBA addressing not supported. Is your PC from 1993??",0

section .sign
dw 0xaa55

