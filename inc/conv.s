%ifndef CONV_S
%define CONV_S

;; TODO: different bases? (probably not)
;; Converts an ASCII string to a number
;; Args:
;;  si - string
;; Rets:
;;  cx - number
atoi:
    push ax
    push si
    xor cx, cx
    xor ax, ax  ; Clear ax, because we cant add only al
.loop:
    lodsb
    cmp al, '0'
    jl .done
    cmp al, '9'
    jg .done
    sub al, '0'
    imul cx, cx, 10
    add cx, ax
    jmp .loop
.done:
    pop si
    pop ax
    ret
    
;; TODO: itoa()

%endif
