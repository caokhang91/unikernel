.global _start
.extern idt_load
.section .text
_start:
    cli
    call idt_load
    call kernel_main
    hlt
