#!/bin/bash

ISO=$1

# Make empty floppy image
dd if=/dev/zero of=$ISO bs=512 count=2880 status=none

# Write boot sector
dd if=./bin/boot.bin of=$ISO bs=512 seek=0 conv=notrunc status=none

# Generate superblock
echo -n '' > ./bin/superblock.bin               # Empty file
echo -ne "MYDOS-FS" >> ./bin/superblock.bin     # Filesytem Name
echo -ne "\x02\x00" >> ./bin/superblock.bin     # Root directory location
dd if=./bin/superblock.bin of=$ISO bs=512 seek=1 conv=notrunc status=none

# Generate root directory
kernellen=$(stat -f "%z" ./bin/kernel.bin)
echo -n '' > ./bin/rootdir.bin
echo -ne "kernel.bin" >> ./bin/rootdir.bin      # Filename
echo -ne "\x30" >> ./bin/rootdir.bin            # Flags 00110000
echo -ne "\x02" >> ./bin/rootdir.bin            # File size
echo -ne "\x03\x00" >> ./bin/rootdir.bin        # File location
dd if=./bin/rootdir.bin of=$ISO bs=512 seek=2 conv=notrunc status=none

dd if=./bin/kernel.bin of=$ISO bs=512 seek=3 conv=notrunc status=none

