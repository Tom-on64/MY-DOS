bits 16

;;
;; Code
;;
section .text
_start:
    ;; Segment setup
    mov ax, 0
    mov ds, ax
    mov es, ax
    mov ss, ax  ; Setup stack
    mov sp, 0x7c00

    mov ah, 0x01    ; Set cursor shape
    mov cx, 0x2607  ; Invisible cursor
    int 0x10

    ;; TODO: Load and run Kernel

    ;; Halt
    cli         ; Clear interrupts
.hang: hlt      ; Halt system
    jmp .hang   ; In case an non-maskable interrupt gets called, jump back and halt again

;;
;; Data
;;
section .data

section .sign
dw 0xaa55

