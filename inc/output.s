%ifndef OUTPUT_S
%define OUTPUT_S

%define ENDL 0x0d
%define VIDMEM 0xb800
%define ROWS 25
%define COLS 80

;; Prints a string to the screen
;; Args: bytes of a string
%macro print 1+
section .data
%%string: db %1, 0
section .text
    mov si, %%string
    call prints
%endmacro

section .text

;; Prints a character to the screen
;; Args:
;;  al - Character
;;  ah - Color attribute
;;  bx - Cursor position
putc:
    push ax
    push cx
    push bx
    push es

    ; Can't modify es directly so i need to use cx
    mov cx, VIDMEM
    mov es, cx

    imul bx, 2  ; 1 character takes 2 bytes (ASCII byte, Attribute byte)
    
    ; Write character into video memory
    mov [es:bx], ax
.done:
    pop es
    pop bx
    pop cx
    pop ax
    ret

;; Prints a string to the screen
;; Args:
;;  si - Pointer to string
;;  ah - Color attribute
;;  bx - Cursor position
;; Rets:
;;  bx - New cursor position
puts:
    push si
    push ax
.print:
    lodsb       ; mov al, [si]; inc si
    or al, al   ; Check for null byte
    jz .done    ; Null byte means end of string
    cmp al, ENDL; Check if we have a newline
    je .newline ; Newline
    call putc   ; Print the character
    inc bx      ; Move forward 1 char
    jmp .print  ; Print next character
.newline:
    call newline
    jmp .print
.done:
    pop ax
    pop si
    ret

;; Prints a string at the cursor position
;; Args:
;;  si - string
prints:
    mov ah, [attr]
    mov bx, [cursor]
    call puts
    mov [cursor], bx
    ret

;; Prints a character at the cursor position
;; Args:
;;  al - character
printc:
    mov ah, [attr]
    mov bx, [cursor]
    call putc
    inc word [cursor]
    ret

;; Clears the screen
;; Args:
cls:
    pusha
    push es

    mov ax, VIDMEM  ; Set es to the VIDMEM address
    mov es, ax

    mov ah, [attr]
    mov al, ' '     ; Clearing is just filling the screen with spaces
    xor bx, bx
    mov cx, (ROWS*COLS*2) ; Amount of bytes in the Video Buffer
.loop:
    cmp bx, cx      ; Have we written enough bytes?
    jg .done
    mov [es:bx], ax ; Write word to VIDMEM
    add bx, 2       ; Wrote 1 word = 2 bytes
    jmp .loop
.done:
    mov word [cursor], 0
    pop es
    popa
    ret

;; Moves the cursor down a line
;; Args:
;;  bx - cursor
;; Rets:
;;  bx - new cursor
newline:
    push ax
    push dx

    ;; We need to calculate this equation: cursor += COLS - (cursor % COLS)
    mov ax, bx  ; Store cursor in ax
    push ax     ; Store that on the stack
    mov dx, 0   ; Prepare dx for division
    mov bx, COLS; Number to divide ax by
    div bx      ; ax /= bx; dx = ax % bx; This gives us (cursor % COLS) in dx
    mov bx, COLS; Prepare bx for subtraction
    sub bx, dx  ; bx -= dx; This gives us COLS - dx
    pop ax      ; Restore old cursor position from stack
    add bx, ax  ; cursor += ax; ax is COLS - (cursor % COLS)

    pop dx
    pop ax
    ret

section .data
cursor: dw 0
attr: db 0x17

%endif
