bits 16

;; This will be put at the start of the binary
section entry
    jmp _start

;; Header files
%include "inc/meta.s"
%include "inc/output.s"
%include "inc/input.s"
%include "inc/string.s"

;; Main
section .text
_start:
    call cls    ; Clear screen
    mov si, str_welcome
    call prints

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
    call printc         ; Print character
    jmp .getchar        ; Get next character

.backspace:
    dec byte [cursor]   ; Go back one space
    dec di              ; decrement pointer to buffer
    mov al, ' '         ; Remove last character
    call printc         ; Print
    dec byte [cursor]   ; Go back one space
    jmp .getchar        ; Get another character

.newline:
    mov bx, [cursor]
    call newline    ; Calculate new cursor position
    mov [cursor], bx
    cmp di, buffer  ; Check if there was a command
    je input        ; No command? goto input
    xor al, al
    stosb           ; Terminate string

;; Expects a command in buffer
runCommand:
    ;; Check
    strcmp buffer, cmd_help
    jz .help
    strcmp buffer, cmd_test
    jz .test
    strcmp buffer, cmd_exit
    jz .exit
    strcmp buffer, cmd_cls
    jz .cls

    ;; No command
    print "Unknown command!",ENDL
    jmp input
;; Prints help message
.help:
    mov si, str_help
    call prints
    jmp input
;; Temporary test command
.test:
    print "Testing...",ENDL
    jmp input
;; Clears the screen
.cls:
    call cls
    jmp input
;; Halts the system
.exit:
    mov dx, 0x604
    mov ax, 0x2000
    out dx, ax
.halt:
    cli
    hlt
    jmp .halt

;; Variables etc.
section .data

;; Strings
str_help: db    "Available commands:",ENDL,\
                "CLS        | Clears the screen",ENDL,\
                "EXIT       | Exits MY-DOS",ENDL,\
                "HELP       | Prints this help message",ENDL,\
                "TEST       | TEMPORARY TEST COMMAND",ENDL,0
str_welcome: db "Welcome to MY-DOS V",VERSION,"!",ENDL,0

;; Command constants
cmd_help: db "help", 0
cmd_test: db "test", 0
cmd_exit: db "exit", 0
cmd_cls: db "cls", 0

;; Buffer TODO: make it not overflow :)
buffer: times 256 db 0

