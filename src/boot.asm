bits 32
section .multiboot
	dd 0x1BADB002	; magic number
	dd 0x0			; flags
	dd - (0x1BADB002 + 0x0)	; checksum

section .text

%include "src/lib/gdt.asm"

global start
extern main
extern pg_start

start:   
	cli
	lgdt [gdt_descriptor]
	mov eax, cr0
	or eax, 0x1
	mov cr0, eax
	jmp CODE_SEG:.setcs
	.setcs:
	mov ax, DATA_SEG
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	mov ss, ax
	mov ebp, 0x90000
	mov esp, ebp
	call pg_start
	call main
	hlt

