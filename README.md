# NOP Benchmark Project

## Purpose
This project benchmarks how many 'nop' (no operation) instructions can be executed in a set time period across different languages and environments. It helps compare the scaffolding, support, and performance overhead of each language for a minimal workload.

## Structure
- asm/: x86-64 NASM assembly implementation
- c/: C implementation
- cpp/: C++ implementation
- python/: Python implementation
- rust/: Rust implementation
- julia/: Julia implementation
- results/: Store timing results and comparisons

## How to Use
Each subdirectory contains:
- Source code for the nop benchmark
- Build/run instructions
- Notes on dependencies

## Methodology
- Each program runs a loop of 'nop' or equivalent for a set duration or count.
- Timing is measured and results are stored in results/.
- Compare the ease of setup, code complexity, and performance.

## Next Steps
1. Implement the NASM x86-64 nop benchmark in asm/
2. Repeat for other languages
3. Collect and compare results
