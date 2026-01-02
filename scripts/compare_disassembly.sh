#!/bin/bash
# Compare C and Assembly disassemblies to understand differences

set -e

echo "=== Disassembly Comparison Tool ==="
echo ""

# Build C version
echo "[1/4] Building C version..."
cd c
gcc -O2 -o nop_benchmark nop_benchmark.c
cd ..

# Build Assembly version
echo "[2/4] Building Assembly version..."
cd asm
nasm -f elf64 nop_benchmark.asm
gcc -no-pie -o nop_benchmark nop_benchmark.o
cd ..

# Generate disassemblies
echo "[3/4] Generating disassemblies..."
mkdir -p docs/disassemblies

objdump -d -M intel c/nop_benchmark > docs/disassemblies/c_intel.txt
objdump -d -M att c/nop_benchmark > docs/disassemblies/c_att.txt
objdump -d -M intel asm/nop_benchmark > docs/disassemblies/asm_intel.txt
objdump -d -M att asm/nop_benchmark > docs/disassemblies/asm_att.txt

# Compare main functions
echo "[4/4] Extracting main function comparisons..."
echo "=== C version (Intel syntax) ===" > docs/disassemblies/main_comparison.txt
grep -A 50 "<main>:" docs/disassemblies/c_intel.txt >> docs/disassemblies/main_comparison.txt || true

echo "" >> docs/disassemblies/main_comparison.txt
echo "=== Assembly version (Intel syntax) ===" >> docs/disassemblies/main_comparison.txt
grep -A 50 "<main>:" docs/disassemblies/asm_intel.txt >> docs/disassemblies/main_comparison.txt || true

echo ""
echo "✅ Disassembly comparison complete!"
echo ""
echo "Generated files:"
echo "  - docs/disassemblies/c_intel.txt     (C with Intel syntax)"
echo "  - docs/disassemblies/c_att.txt       (C with AT&T syntax)"
echo "  - docs/disassemblies/asm_intel.txt   (Assembly with Intel syntax)"
echo "  - docs/disassemblies/asm_att.txt     (Assembly with AT&T syntax)"
echo "  - docs/disassemblies/main_comparison.txt (Side-by-side main functions)"
echo ""
echo "To view the comparison:"
echo "  cat docs/disassemblies/main_comparison.txt"
echo ""
echo "To see full disassemblies:"
echo "  less docs/disassemblies/c_intel.txt"
echo "  less docs/disassemblies/asm_intel.txt"
