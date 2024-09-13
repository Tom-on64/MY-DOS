%ifndef INPUT_S
%define INPUT_S

section .text

;; Gets a character from the user
;; Rets:
;;  ah - scan code
;;  al - input character
getc:
    xor ax, ax
    int 0x16
    ret

%endif
