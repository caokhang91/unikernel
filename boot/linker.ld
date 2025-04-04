ENTRY(_start)
SECTIONS {
    . = 0x100000;
    .text : { *(.text*) }
    .rodata : { *(.rodata*) }
    .data : { *(.data*) }
    .bss : { *(.bss*) }
    .context : ALIGN(0x1000) { *(.context*) }
    .memory : ALIGN(0x1000) { *(.memory*) }
}
