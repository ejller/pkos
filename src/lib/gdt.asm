gdt_start:
	; gdt_null
	dd 0x0
	dd 0x0

gdt_code:
	; base - 0x0
	; limit - 0xffff
	dw 0xffff		; Limit bits 0-15
	dw 0x0			; Base bits 0-15
	db 0x0			; Base bits 16-23
	db 10011010b	; Flags
	db 11001111b	; Limit bits 16-19
	db 0x0  		; Base bits 24-31

gdt_data:
	dw 0xffff		; Limit bits 0-15
	dw 0x0 			; Base bits 0-15
	db 0x0			; Base bits 16-23
	db 10010010b	; Flags
	db 11001111b	; Limit bits 16-19
	db 0x0			; Base bits 24-31

gdt_end:	

gdt_descriptor:
	dw gdt_end - gdt_start - 1	; Size of GDT
	dd gdt_start

; Constants
CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start