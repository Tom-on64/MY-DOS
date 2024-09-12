OUTPUT_FORMAT("binary")
OUTPUT_ARCH(i386)

SECTIONS {
    .text : {
        *(entry);
        *(.text);
    }

    .data : { *(.data); }
    .bss : { *(.bss); }
}

