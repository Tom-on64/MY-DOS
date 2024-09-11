AS := nasm

include make.config

SRC := ./src/boot.s
ISO := mydos.iso

.PHONY: os clean

os: $(OBJ)
	$(AS) -fbin -o $(ISO) $(SRC)

run:
	qemu-system-x86_64\
		-drive format=raw,file=$(ISO),index=0,media=disk\
		-m 256M -accel tcg -monitor stdio\
		-rtc base=localtime,clock=host,driftfix=slew\
		-audiodev coreaudio,id=audio0 -machine pcspk-audiodev=audio0

clean:
	rm -rf ./bin
	rm -f ./**/*.o

