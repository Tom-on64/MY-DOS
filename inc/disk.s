%ifndef DISK_S
%define DISK_S

;; TODO: Don't use BIOS interrupts

section .text
;; Reads sectors from the disk
;; Args:
;;  ax - LBA address low
;;  bx - LBA address high
;;  cx - Sector count
;;  dl - Drive number
;;  di - Destination
;; Rets:
;;  CF = 1 - Read failed
diskRead:
    push ax
    push si
    push es

    xor si, si
    mov es, si      ; Clear es
    mov si, DAPACK  ; Disk Address Packet

    mov word [DAPACK.d_lba], ax     ; Lba address low word
    mov word [DAPACK.d_lba+2], ax   ; Lba address high word
    mov word [DAPACK.blkcount], cx  ; Sector count
    mov word [DAPACK.destaddr], di  ; Destination address
    mov ah, 0x42        ; Read sectors (Extension)
    int 0x13

    pop es
    pop si
    pop ax
    ret

;; Writes sectors to the disk
;; TODO:
diskWrite: ret

section .data
DAPACK:         ; Disk Address Packet
    db 16       ; Packet size in bytes
    db 0        ; Always zero
.blkcount: dw 0 ; Block/sector count (Some BIOSes may limit this to a max of 127)
.destaddr: dw 0 ; Destination
    dw 0       ; Memory page
.d_lba: dd 0    ; LBA Address
    dd 0        ; More bytes only for BIG LBA's (>4B)

%endif
