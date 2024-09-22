%ifndef INPUT_S
%define INPUT_S

%include "inc/output.s"

section .text
;; Gets a string from the user
;; Args: 
;;  di - buffer
;;  cx - maxlen
;; Rets: 
;;  di - pointer to string end
gets:
    push ax
    push bx
    push cx
.loop:
    call getc       ; Read in character
    cmp al, 0x08    ; Backspace
    je .backspace
    cmp al, 0x0d    ; Newline
    je .newline
    test cx, cx     ; If there are too many characters, just ignore it and wait for a newline/backspace
    jz .loop
    stosb           ; mov [si++], al
    dec cx
    call printc     ; Print the character
    jmp .loop       ; Get next
.backspace:
    dec byte [cursor]   ; Go back one space
    mov al, ' '         ; We will print a space to erase the last character
    call printc         ; Erase last character
    dec byte [cursor]   ; Go back again
    jmp .loop
.newline:
    mov bx, [cursor]
    call newline
    mov [cursor], bx

    xor al, al  ; Null byte
    stosb       ; Terminate string

    pop cx
    pop bx
    pop ax
    ret

;; Gets a character from the user
;; Rets:
;;  ah - scan code
;;  al - input character
getc:
    xor ax, ax
    int 0x16
    ret

%endif
