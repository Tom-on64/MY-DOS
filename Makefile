AS := nasm
LD := i686-elf-ld

BOOT_SRC := ./boot/boot.s
KERNEL_SRC := ./kernel/*.s
BIN := ./bin
ISO := ./mydos.iso

.PHONY: os run clean

os: dirs $(BIN)/boot.bin $(BIN)/kernel.bin
	dd if=/dev/zero of=$(ISO) bs=512 count=2880 status=none
	dd if=$(BIN)/boot.bin of=$(ISO) bs=512 seek=0 conv=notrunc status=none
	dd if=$(BIN)/kernel.bin of=$(ISO) bs=512 seek=1 conv=notrunc status=none

$(BIN)/boot.bin: $(BOOT_SRC)
	$(AS) -felf32 -o $(BIN)/boot.o $<
	$(LD) -T $(BOOT_SRC:.s=.ld) -o $@ $(BIN)/boot.o

$(BIN)/kernel.bin: $(KERNEL_SRC)
	$(AS) -felf32 -o $(BIN)/kernel.o ./kernel/kernel.s
	$(LD) -T ./kernel/kernel.ld -o $@ $(BIN)/kernel.o

dirs:
	[[ -d $(BIN) ]] || mkdir $(BIN)

run:
	qemu-system-x86_64\
		-drive format=raw,file=$(ISO),index=0,media=disk\
		-m 256M -accel tcg -monitor stdio\
		-rtc base=localtime,clock=host,driftfix=slew\
		-audiodev coreaudio,id=audio0 -machine pcspk-audiodev=audio0

clean:
	rm -rf ./bin
	rm -f $(ISO)

