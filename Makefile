BOOT=src/boot.asm
KERNEL=src/kernel.c
PAGING=src/lib/paging.asm
LINKER=src/linker.ld
KERNEL_OUT=build/os.bin


all: build

build: clean
	mkdir -p build
	nasm -f elf32 ${BOOT} -o build/boot.o
	nasm -f elf32 ${PAGING} -o build/paging.o
	gcc -m32 -ffreestanding -c ${KERNEL} -o build/kernel.o
	ld -m elf_i386 -T ${LINKER} -o ${KERNEL_OUT} build/boot.o build/paging.o build/kernel.o

clean:
	rm -rf build

run: build
	qemu-system-i386 -kernel ${KERNEL_OUT} -monitor stdio



