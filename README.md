# Unikernel

🧠 A reactive AI-capable unikernel OS with BIOS/UEFI Limine bootloader.

## Features

- Minimal kernel with VGA output and input
- Integrated AI prompt + memory filesystem
- Limine multiboot2 + ISO boot (BIOS & UEFI)
- Build & run via `make bios` / `make uefi`

## Build

```bash
make bios        # or make uefi
make run-bios    # run with QEMU
```
