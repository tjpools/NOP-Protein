# SpigotAsm: π Spigot Algorithm Exploration

## Overview
This project explores the Rabinowitz-Wagon spigot algorithm for π (pi) through both C and x86-64 NASM assembly implementations. It demonstrates the process of validating, debugging, and reconstructing binaries at a low level, including round-trip binary extraction and reconstruction.

## Achievements
- **Assembly Debugging:** Reviewed and corrected a NASM implementation of the Rabinowitz-Wagon spigot algorithm for π, ensuring correct digit extraction and output.
- **Validation:** Verified the correctness of both the C and fixed assembly implementations by running the binaries and confirming the output matches the expected digits of π.
- **Workspace Hygiene:** Cleaned up the workspace to retain only essential files: the C source, compiled binary, and pseudocode.
- **Binary Inspection:** Used `objdump` to disassemble the compiled binary in both AT&T and Intel syntax, saving the output for inspection.
- **Binary Round-Trip:** Demonstrated that a Linux ELF executable can be faithfully reconstructed from its hex dump using `xxd`, confirming the reconstructed binary is identical and functional.
- **ELF Format Understanding:** Discussed the structure of ELF binaries and the process of reconstructing executables from raw binary data.

## Key Files
- `pi_spigot.c`: C implementation of the spigot algorithm for π.
- `pi_spigot`: Compiled binary, outputs digits of π.
- `pi_spigot_pseudocode.txt`: Pseudocode for the algorithm.
- `pi_spigot_objdump.txt`: Disassembly (AT&T syntax).
- `pi_spigot_objdump_intel.txt`: Disassembly (Intel syntax).
- `pi_spigot.hex`: Hex dump of the binary.
- `pi_spigot_reconstructed`: Binary reconstructed from hex dump.

## How to Reconstruct the Binary
1. **Extract hex dump:**
   ```bash
   xxd pi_spigot > pi_spigot.hex
   ```
2. **Reconstruct binary:**
   ```bash
   xxd -r pi_spigot.hex pi_spigot_reconstructed
   ```
3. **Compare binaries:**
   ```bash
   cmp pi_spigot pi_spigot_reconstructed
   ```
4. **Run reconstructed binary:**
   ```bash
   chmod +x pi_spigot_reconstructed
   ./pi_spigot_reconstructed
   ```

## Lessons Learned
- Correct stack alignment and calling conventions are crucial in assembly.
- The ELF format allows for reliable binary reconstruction from raw data.
- Disassembly in both AT&T and Intel syntax aids in low-level inspection and debugging.

## Credits
- Rabinowitz-Wagon spigot algorithm for π.
- Tools: NASM, GCC, objdump, xxd, cmp, chmod, bash.

---
This project demonstrates a full cycle of algorithm implementation, binary inspection, and executable reconstruction, providing a practical reference for low-level systems programming and reverse engineering.
