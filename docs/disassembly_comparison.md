# Disassembly Comparison

## Purpose
This document explains how to compare disassembled binaries from C and Assembly implementations to understand performance differences and verify correctness.

## Quick Start

Run the comparison script:
```bash
./scripts/compare_disassembly.sh
```

This will:
1. Build both C and Assembly versions with appropriate optimizations
2. Generate disassembly listings in both Intel and AT&T syntax
3. Extract and compare the main functions side-by-side
4. Save all output to `docs/disassemblies/`

## Understanding the Output

### Files Generated

- **c_intel.txt** / **asm_intel.txt**: Full disassembly in Intel syntax (easier to read)
- **c_att.txt** / **asm_att.txt**: Full disassembly in AT&T syntax (GNU tools default)
- **main_comparison.txt**: Side-by-side comparison of main functions

### Intel vs AT&T Syntax

**Intel Syntax** (more readable):
```asm
mov rax, rbx        ; destination, source
add rcx, 10000
```

**AT&T Syntax** (GNU default):
```asm
movq %rbx, %rax     ; source, destination (reversed!)
addq $10000, %rcx   ; immediate values prefixed with $
```

## What to Look For

### 1. Loop Structure
Compare how loops are implemented:
- Are time checks inside or outside the NOP loop?
- How many instructions between time checks?
- What's the loop overhead?

### 2. Function Calls
Check syscall frequency:
- C version might call `time()` through libc
- Assembly version calls `time()` directly
- Batching reduces call frequency

### 3. Register Usage
- Which registers hold counters, time values, etc.?
- Are registers being saved/restored properly?
- Stack frame setup differences

### 4. Optimization Differences
- Compiler optimizations in C (loop unrolling, instruction reordering)
- Hand-optimized assembly patterns
- NOP batching via `%rep` directive

## Example Analysis: NOP Benchmark

### Problem Identified
Original assembly called `time()` every iteration:
```asm
.loop:
    nop
    inc rcx
    call time        ; ❌ Expensive syscall every iteration!
    ; ...
    jl .loop
```

### Solution Applied
Batch NOPs to reduce syscall overhead:
```asm
.loop:
    %rep 10000
        nop          ; Execute 10,000 NOPs
    %endrep
    add rcx, 10000
    call time        ; ✅ Only one syscall per 10,000 NOPs
    ; ...
    jl .loop
```

### Result
- **Before**: ~148M NOPs/second (syscall-bound)
- **After**: ~11B NOPs/second (NOP-bound)
- **Improvement**: ~74x faster, proving assembly can be the fastest

## Manual Disassembly Commands

If you need to examine specific sections:

```bash
# Disassemble a specific function
objdump -d -M intel binary | grep -A 100 "<function_name>:"

# Show all symbols
nm binary

# Show ELF headers
readelf -h binary

# Show program headers (segments)
readelf -l binary

# Show section headers
readelf -S binary

# Hexdump of .text section
objdump -s -j .text binary
```

## Using objdump Options

```bash
# Disassemble with source (if compiled with -g)
objdump -S binary

# Show full contents of all sections
objdump -D binary

# Display file headers
objdump -f binary

# Show relocation entries
objdump -r binary
```

## Comparing with diff

For detailed comparison:
```bash
# Compare main functions only
diff -u <(grep -A 50 "<main>:" docs/disassemblies/c_intel.txt) \
        <(grep -A 50 "<main>:" docs/disassemblies/asm_intel.txt)

# Compare full disassemblies
diff -u docs/disassemblies/c_intel.txt docs/disassemblies/asm_intel.txt
```

## Learning from Disassembly

### What Assembly Teaches Us About C

1. **Every operation has a cost**: The `time()` call generates multiple instructions
2. **Compiler optimizations matter**: Compare `-O0` vs `-O2` vs `-O3`
3. **Stack alignment**: Modern ABIs require 16-byte stack alignment
4. **Calling conventions**: Arguments in registers (rdi, rsi, rdx, rcx, r8, r9)

### What C Teaches Us About Assembly

1. **Higher-level patterns**: C compiler shows idiomatic instruction sequences
2. **Safe practices**: Stack management, register preservation
3. **Error handling**: How C runtime handles edge cases
4. **Standard conventions**: Following ABI for interoperability

## Troubleshooting

### Script Fails to Build
- Ensure `nasm` is installed: `sudo apt-get install nasm`
- Ensure `gcc` is installed: `sudo apt-get install build-essential`
- Check that source files exist in `c/` and `asm/` directories

### Disassemblies Look Wrong
- Verify binaries are not stripped: `file binary` should show "not stripped"
- Check that binaries are executable: `chmod +x binary`
- Ensure correct architecture: `readelf -h binary` should show "x86-64"

### Can't Find main Function
- Try searching for `_start` instead: `grep "<_start>:" disassembly.txt`
- Use `nm binary | grep main` to verify symbol exists
- Check if binary is statically or dynamically linked

## Further Reading

- **Intel® 64 and IA-32 Architectures Software Developer Manuals**
- **System V Application Binary Interface (AMD64)**
- **GNU Assembler (GAS) Documentation**
- **NASM Documentation**
- **ELF Format Specification**

## Related Workflows

- [Binary Reconstruction Workflow](binary_reconstruction_workflow.md) - Verify ELF format understanding
- `readelf`, `objdump`, `nm` man pages - Deep dive into binary analysis tools
