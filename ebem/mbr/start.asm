start:
	mov ax, 0x0203  ; function 2, mode 3
	mov dx, 0x0000  ; top-left corner
	int 0x10        ; move cursor to top-left corner

	mov ax, 0x0103  ; function 1, mode 3
	mov cx, 0x0607  ; default cursor
	int 0x10        ; set default cursor

	mov ax, 0x0003  ; function 0, mode 3
	int 0x10        ; change video mode

	.int13hBasic:
		mov bp, bx
		mov cl, 4
		shl bp, cl
		add bp, partitionTableStart - 16 + 1

		mov ax, 0x0201              ; Function 02h, read only 1 sector
		mov bx, 0x7c00              ; Buffer for read starts at 7C00
		mov dx, 0             ; DL = Disk Drive
		mov dh, 0
		mov cx, 2

		int 13h
		jnb .checkForCorrectLaunch

	.resetDisk:
		mov ah, 0                  ; Function 0x00
		mov dx, [savedDX]
		int 13h                    ; Reset disk
		jmp .int13hBasic                ; Try again

	.checkForCorrectLaunch:
		mov cx, 0
		cmp byte [bootSector], 0
		je .noBootCode              ; No bootloader code
		cmp word [bootSector + 510], 0xAA55
		jne .noBootMark             ; Missing bootable mark

	.launch:
		mov dx, [savedDX]
		jmp bootSector

	.noBootMark:
		mov si, infoString
		call printString
		call .bootPrint
		mov si, markString
		call printString
		jmp $

	.noBootCode:
		mov si, warnString
		call printString
		call .bootPrint
		mov si, codeString
		call printString
		jmp $

	.bootPrint:
	    mov si, noBootString
	    call printString