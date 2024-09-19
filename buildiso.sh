#!/bin/bash

ISO=$1

# Make empty floppy image
dd if=/dev/zero of=$ISO bs=512 count=2880 status=none

# Write boot sector
dd if=./bin/boot.bin of=$ISO bs=512 seek=0 conv=notrunc status=none

# TODO: generate superblock
# TODO: generate root directory
# TODO: write files to disk

# TODO: put kernel somewhere else
dd if=./bin/kernel.bin of=$ISO bs=512 seek=1 conv=notrunc status=none

