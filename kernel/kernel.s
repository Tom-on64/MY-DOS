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
    mov di, buffer  ; Input buffer
.getchar:
    call getc       ; Get character from user in al

    ;; Check for special characters
    cmp al, ENDL    ; Check if user pressed Enter
    je .newline     ; True? -> Newline

    cmp al, 0x08    ; Check for backspace
    je .backspace

    stosb               ; mov [di], al; inc di
    mov ah, [attr]      ; Color attribute byte
    mov bx, [cursor]    ; Cursor
    call putc           ; Print character
    inc word [cursor]   ; Increment cursor
    jmp .getchar        ; Get next character

.backspace:
    dec byte [cursor]   ; Go back one space
    dec di              ; decrement pointer to buffer
    mov bx, [cursor]    ; Cursor
    mov ah, [attr]      ; Color attribute 
    mov al, ' '         ; Remove last character
    call putc           ; Draw
    jmp .getchar        ; Get another character

.newline:
    mov bx, [cursor]
    call newline    ; Calculate new cursor position
    mov [cursor], bx
    cmp di, buffer  ; Check if there was a command
    je input        ; No command? goto input
    mov al, ENDL
    stosb           ; Store newline at the end of string
    xor al, al
    stosb           ; Terminate string

;; Expects a command in buffer
runCommand:
    print "INPUT: "
    mov si, buffer
    mov bx, [cursor]
    mov ah, [attr]
    call puts
    mov [cursor], bx
    jmp input

.halt:
    cli
    hlt
    jmp .halt

;; Variables etc.
section .data
bufLen: dw 0
buffer: times 256 db 0

;; Command constants
cmd_help: db "help", 0
cmd_test: db "test", 0

