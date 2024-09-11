[bits 16]
[org 0x7c00]

_start:
    cli
.hang: 
    hlt
    jmp .hang

times (510-($-$$)) db 0
dw 0xaa55

