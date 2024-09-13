bits 16

;; This will be put at the start of the binary
section entry
    jmp _start

;; Header files
%include "inc/output.s"
%include "inc/input.s"
%include "inc/string.s"

;; Main
section .text
_start:
    call cls    ; Clear screen
    print "Welcome to MY-DOS!", ENDL

input:
    print "> "
.getchar:
    call getc   ; Get character from user in al
    cmp al, ENDL; Check if user pressed Enter
    je .newline ; True? -> Newline

    ; Else print the character 
    mov ah, [attr]
    mov bx, [cursor]
    call putc
    inc word [cursor]
    jmp .getchar  ; Get next character

.newline:
    mov bx, [cursor]
    call newline    ; Calculate new cursor position
    mov [cursor], bx
    jmp input  ; Get more input

.halt:
    cli
    hlt
    jmp .halt

;; Variables etc.
section .data
bufLen: db 0
buffer: times 256 db 0

