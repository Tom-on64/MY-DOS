bits 16

%include "kernel/output.s"

section .text
section entry
_start:
    call cls
    mov si, msg
    call puts

    cli
.halt: hlt
    jmp .halt

section .data
msg: db "Hello, World!", 0

