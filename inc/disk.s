%ifndef DISK_S
%define DISK_S

;; TODO: Don't use BIOS interrupts

section .text

;; Internal setup function
;; Args:
;;  ax - LBA address low
;;  bx - LBA address high
;;  cx - Sector count
;;  di - Destination
_setupPacket:
    mov byte [DAPACK.packsize], 16  ; 16 bytes
    mov byte [DAPACK.zero], 0       ; Always zero
    mov word [DAPACK.seccount], cx  ; Sector count
    mov word [DAPACK.destaddr], di  ; Destination address
    mov word [DAPACK.destpage], 0   ; Destination page (Always zero)
    mov word [DAPACK.lba_low], ax   ; Lba address low word
    mov word [DAPACK.lba_hi], ax    ; Lba address high word
    mov dword [DAPACK.lba_big], 0   ; Extra LBA bytes (Unused)
    ret

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
    mov es, si          ; Clear es
    mov si, DAPACK      ; Disk Address Packet
    call _setupPacket   ; Setup the packet with correct values
    mov ah, 0x42        ; Read sectors (Extension)
    int 0x13

    pop es
    pop si
    pop ax
    ret

;; Writes sectors to the disk
;; Args:
;;  ax - LBA address low
;;  bx - LBA address high
;;  cx - Sector count
;;  dl - Drive number
;;  di - Destination
;; Rets:
;;  CF = 1 - Write failed
diskWrite:
    push ax
    push si
    push es

    xor si, si
    mov es, si          ; Clear es
    mov si, DAPACK      ; Disk Address Packet
    call _setupPacket   ; Setup the packet with correct values
    mov ah, 0x43        ; Write sectors (Extension)
    int 0x13

    pop es
    pop si
    pop ax
    ret

section .data
DAPACK:         ; Disk Address Packet
.packsize: db 16; Packet size in bytes
.zero:     db 0 ; Always zero
.seccount: dw 0 ; Sector count (Some BIOSes may limit this to a max of 127)
.destaddr: dw 0 ; Destination
.destpage: dw 0 ; Memory page
.lba_low:  dw 0 ; LBA Address low word
.lba_hi:   dw 0 ;             high word
.lba_big:  dd 0 ; More bytes only for BIG LBA's (>4B)

%endif
