%ifndef STRING_S
%define STRING_S

;; Compares two strings
;; Args: str1, str2
;; Rets: eax = result
%macro strcmp 2
    push si
    push di
    push cx

    mov si, %1
    mov di, %2
    mov cx, -1
    xor eax, eax
    repe cmpsb
    seta al
    sbb ax, ax

    pop cx
    pop di
    pop si
%endmacro

;; Copies a string into a buffer
;; Args: src, dest
%macro strcpy 2
    push si
    push di
    push ax
    push cx

    mov si, %1  ; Source string
    mov di, %2  ; Destination buffer
    mov cx, -1  ; Max value
    xor al, al  ; Null byte
    repne scasb ; Search for terminating null byte
    not cx      ; Invert cx to get string length
    mov di, %2  ; Go back
    rep movsb   ; Copy string

    pop cx
    pop ax
    pop di
    pop si
%endmacro

;; TODO:
;; Concatonates two strings
strcat: ret

;; Gets the length of a string
;; Args: string
;; Rets: ax = length
%macro strlen 1
    push di
    push cx
    
    xor ax, ax  ; Clear ax
    mov di, %1  ; Put string pointer in di
    mov cx, -1  ; Set cx to max value
    repne scasb ; Since al = 0x00, we scan for a null byte
    not cx      ; Gets the length
    dec cx      ; Account for null byte
    mov ax, cx  ; Store length in ax

    pop cx
    pop di
%endmacro


;; Sets a region of memory to the same byte
;; Args: value, length, destination
%macro memset 3
    mov al, %1
    mov cx, %2
    mov di, %3
    rep stosb
%endmacro

;; Copies a region of memory to another
;; Args: source, destination, length
%macro memcpy 3
    mov si, %1
    mov di, %2
    mov cx, %3
    rep movsb
%endmacro

%endif
