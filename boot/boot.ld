OUTPUT_FORMAT("binary")
OUTPUT_ARCH(i386)

SECTIONS {
    /* Bootloader location */
    . = 0x7c00;

    /* Text and Data segments */
    .text : { *(.text); }
    .data : { *(.data); }

    /* Make sure bootloader is 512 Bytes and has the boot signature */
    . = 0x7C00 + 510;
    .sign : { *(.sign); }
}

