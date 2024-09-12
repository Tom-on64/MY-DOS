%ifndef OUTPUT_S
%define OUTPUT_S

%define ENDL 0x0a, 0x0d
%define VIDMEM 0xb800
%define ROWS 25
%define COLS 80

section .text

;; Prints a character to the screen
;; Args:
;;  al - Character
;;  ah - Color attribute
;;  bx - Offset into video memory
putc:
    pusha
    push es

    ; Can't modify es directly so i need to use cx
    mov cx, VIDMEM
    mov es, cx

    imul bx, 2
    
    ; Write character into video memory
    mov [es:bx], ax
.done:
    pop es
    popa
    ret

;; Prints a string to the screen
;; Args:
;;  si - Pointer to string
puts:
    pusha
    mov bx, [cursor]
    mov ah, [attr] ; White on black
.print:
    lodsb       ; mov al, [si]; inc si
    or al, al   ; Check for end of string
    jz .done

    call putc
    inc bx

    jmp .print
.done:
    mov [cursor], bx
    popa
    ret

;; Clears the screen
cls:
    pusha
    push es

    mov ax, VIDMEM  ; Set es to the VIDMEM address
    mov es, ax

    mov ah, [attr]  ; Clearing is just filling the screen with spaces
    mov al, ' '
    xor bx, bx
    mov cx, (ROWS*COLS*2) ; Amount of bytes in the Video Buffer
.loop:
    cmp bx, cx      ; Have we written enough bytes?
    jg .done
    mov [es:bx], ax ; Write word to VIDMEM
    add bx, 2       ; Wrote 1 word = 2 bytes
    jmp .loop
.done:
    pop es
    popa
    ret

section .data
attr: db 0x17
cursor: dw 0

%endif
