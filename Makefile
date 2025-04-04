KERNEL_ELF = kernel.elf
LIMINE_DIR = limine
SRC = src/kernel.c src/fs.c src/vga.c src/isr.c src/idt.c src/keyboard.c src/ai.c
OBJ = $(SRC:.c=.o) boot/boot.o

CC = x86_64-elf-gcc
LD = x86_64-elf-ld
CFLAGS = -O2 -Wall -ffreestanding -m64 -fno-pie -fno-stack-protector -Iinclude
LDFLAGS = -T boot/linker.ld -nostdlib

all: bios

$(KERNEL_ELF): $(OBJ)
	$(LD) $(LDFLAGS) -o $@ $^

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

boot/boot.o: boot/boot.S
	$(CC) $(CFLAGS) -c $< -o $@

bios: $(KERNEL_ELF) config/limine.cfg
	mkdir -p iso_root/boot
	cp $(KERNEL_ELF) iso_root/boot/
	cp config/limine.cfg $(LIMINE_DIR)/limine.sys $(LIMINE_DIR)/limine-cd.bin iso_root/
	xorriso -as mkisofs \
		-b limine-cd.bin -no-emul-boot -boot-load-size 4 -boot-info-table \
		iso_root -o bios.iso
	$(LIMINE_DIR)/limine-deploy bios.iso

uefi: $(KERNEL_ELF) config/limine.cfg
	mkdir -p iso_root/boot
	cp $(KERNEL_ELF) iso_root/boot/
	cp config/limine.cfg $(LIMINE_DIR)/limine.sys $(LIMINE_DIR)/limine-cd.bin $(LIMINE_DIR)/limine-eltorito-efi.bin iso_root/
	xorriso -as mkisofs \
		-b limine-cd.bin -no-emul-boot -boot-load-size 4 -boot-info-table \
		--efi-boot limine-eltorito-efi.bin \
		-efi-boot-part --efi-boot-image --protective-msdos-label \
		iso_root -o efi.iso
	$(LIMINE_DIR)/limine-deploy efi.iso

run-bios:
	qemu-system-x86_64 -cdrom bios.iso -boot d

run-uefi:
	qemu-system-x86_64 -cdrom efi.iso

clean:
	rm -f *.o $(KERNEL_ELF) bios.iso efi.iso
	rm -rf iso_root
