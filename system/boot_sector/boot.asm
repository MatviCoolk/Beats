org 0x7c00

; boot drive
mov [bootDisk], dl

; video mode
mov ah, 00h
mov al, 13h
int 10h

call diskRead
jmp loadedExtendedProgram

%include "/Users/MatviCoolk/Library/Mobile Documents/com~apple~CloudDocs/iCloud Drive/Sand Desert Beats/system/boot_sector/disk_read.asm"

times 510-($-$$) db 0
dw 0xaa55