bits 16

;; This will be put at the start of the binary
section entry
    jmp _start

;; Header files
%include "kernel/output.s"
%include "kernel/input.s"

;; Main
section .text
_start:
    call cls
    print "Welcome to MY-DOS!",ENDL

.input:
    call getc
    cmp al, 0x0d
    je .newline
    mov ah, [attr]
    mov bx, [cursor]
    call putc
    inc word [cursor]
    jmp .input

.newline:
    mov bx, [cursor]
    call newline
    mov [cursor], bx
    jmp .input

.halt:
    cli
    hlt
    jmp .halt

;; Variables etc.
section .data
bufLen: db 0
buffer: times 256 db 0

