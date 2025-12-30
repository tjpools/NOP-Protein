# Assembly Protein (NASM)

This directory contains the x86-64 NASM implementation of the NOP benchmark.

## Purpose
Demonstrates how many NOP instructions can be executed in one second using raw assembly.

## Build Instructions
- Install NASM and GCC (for linking)
- Build: `nasm -f elf64 nop_benchmark.asm && gcc -no-pie -o nop_benchmark nop_benchmark.o`
- Run: `./nop_benchmark`

## Notes
- Minimal scaffolding, direct hardware access.
- Shows the lowest possible overhead for NOP execution.
