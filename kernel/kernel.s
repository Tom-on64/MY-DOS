bits 16

%define BUF_LEN 256
%define READ_BUF 0x2000

;; This will be put at the start of the binary
section entry
    jmp _start

;; Header files
%include "inc/meta.s"
%include "inc/output.s"
%include "inc/input.s"
%include "inc/string.s"
%include "inc/disk.s"
%include "inc/conv.s"

;; Main
section .text
_start:
    mov [driveNum], dl
    call cls    ; Clear screen
    mov si, str_welcome
    call prints

input:
    print "> "
    mov di, buffer  ; Input buffer
    mov cx, BUF_LEN
    call gets
    dec di          ; Account for null byte
    cmp di, buffer  ; Check if there was a command
    je input        ; No command? goto input

;; Expects a command in buffer
runCommand:
    mov si, buffer 
    dec si          ; Avoid an off by one error
    xor cx, cx      ; Counter
.loop:
    cmp cx, 256     ; Don't overflow
    je .done        ; String is too long
    inc cx          ; Increment counter
    inc si          ; Increment si
    cmp byte [si], ' '  ; Check for a space
    jne .loop       ; Space not fount
    mov byte [si], 0    ; Replace space with Null byte
.done: 
    ;; Check
    strcmp buffer, cmd_help
    jz .help
    strcmp buffer, cmd_test
    jz .test
    strcmp buffer, cmd_exit
    jz .exit
    strcmp buffer, cmd_cls
    jz .cls
    strcmp buffer, cmd_char
    jz .char

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
.char:
    print "ASCII byte: "
    mov di, buffer
    mov cx, BUF_LEN
    call gets
    mov si, buffer
    call atoi
    print "ASCII char: "
    mov al, cl
    call printc
    print ENDL
    jmp input

;; Variables etc.
section .data
driveNum: db 0

;; Strings
str_help: db    "Available commands:",ENDL,\
                "CHAR       | Prints an ASCII from the input number",ENDL,\
                "CLS        | Clears the screen",ENDL,\
                "EXIT       | Exits MY-DOS",ENDL,\
                "HELP       | Prints this help message",ENDL,\
                "TEST       | TEMPORARY TEST COMMAND",ENDL,0
str_welcome: db "Welcome to MY-DOS V",VERSION,"!",ENDL,0

;; Command constants
cmd_help: db "help", 0
cmd_test: db "test", 0
cmd_exit: db "exit", 0
cmd_disk: db "disk", 0
cmd_char: db "char", 0
cmd_cls: db "cls", 0

buffer: times BUF_LEN db 0
db ENDL ; Newline after buffer

