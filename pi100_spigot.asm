; pi100_spigot.asm
;
; x86-64 NASM, Linux, Intel syntax.
; Computes and prints 100 digits of pi using an integer spigot algorithm.
; No floating point, no external libraries.
;
; Canonical first 100 digits of pi (for comparison):
; 3.
; 1415926535 8979323846 2643383279 5028841971 6939937510
; 5820974944 5923078164 0628620899 8628034825 3421170679
;
; Build:
;   nasm -f elf64 -g -F dwarf pi100_spigot.asm -o pi100_spigot.o
;   ld -o pi100_spigot pi100_spigot.o
;
; Run:
;   ./pi100_spigot

%define NDIGITS      100
%define ARR_LEN      (10*NDIGITS/3+1)
%define SYS_write    1
%define SYS_exit     60
%define STDOUT       1

section .data
pi_output:      times (2 + NDIGITS + 2) db 0

section .bss
a_array:        resd ARR_LEN
carry:          resq 1
num:            resq 1
predigit:       resd 1
nines_count:    resd 1
i_outer:        resd 1
j_inner:        resd 1
digit:          resd 1
idx_out:        resd 1
tmp_q:          resq 1

section .text
global _start

_start:
    xor     eax, eax
    mov     dword [j_inner], eax
init_array_loop:
    mov     eax, [j_inner]
    cmp     eax, ARR_LEN
    jge     init_array_done
    mov     ecx, 2
    mov     edx, [j_inner]
    mov     [a_array + rdx*4], ecx
    inc     dword [j_inner]
    jmp     init_array_loop
init_array_done:
    mov     dword [predigit], 0
    mov     dword [nines_count], 0
    mov     dword [i_outer], 0
    mov     dword [idx_out], 0
    mov     byte [pi_output], '3'
    mov     byte [pi_output + 1], '.'
outer_loop:
    mov     eax, [i_outer]
    cmp     eax, NDIGITS
    jge     outer_done
    mov     qword [carry], 0
    mov     eax, ARR_LEN
    dec     eax
    mov     [j_inner], eax
inner_loop:
    mov     eax, [j_inner]
    cmp     eax, 1
    jl      inner_done
    mov     ecx, eax
    mov     esi, eax
    mov     edx, esi
    mov     eax, [a_array + rdx*4]
    movsx   rax, eax
    imul    rax, rax, 10
    mov     r8, [carry]
    imul    r8, rcx
    add     rax, r8
    lea     ebx, [ecx*2 + 1]
    mov     rbx, rbx
    xor     rdx, rdx
    div     rbx
    mov     edx, [j_inner]
    mov     [a_array + rdx*4], rdx      ; a[j] = remainder
    mov     [carry], rax                ; carry = quotient
    dec     dword [j_inner]
    jmp     inner_loop
inner_done:
    ; Final step for a[0]
    mov     eax, [a_array]
    imul    eax, 10
    add     eax, [carry]
    mov     edx, eax
    mov     ecx, 10
    div     ecx
    mov     [a_array], edx         ; a[0] = x % 10
    mov     edx, eax               ; edx = d = x / 10
    mov     eax, [predigit]
    cmp     edx, 9
    je      case_d_eq_9
    cmp     edx, 10
    je      case_d_eq_10
    jmp     case_d_other
    mov     eax, [nines_count]
    inc     eax
    mov     [nines_count], eax
    jmp     outer_next
case_d_eq_10:
    mov     eax, [predigit]
    inc     eax
    call    emit_digit_from_eax
    mov     eax, [nines_count]
    mov     edx, eax
emit_zero_loop:
    cmp     edx, 0
    je      emit_zero_done
    mov     eax, 0
    call    emit_digit_from_eax
    dec     edx
    jmp     emit_zero_loop
emit_zero_done:
    mov     dword [predigit], 0
    mov     dword [nines_count], 0
    jmp     outer_next
case_d_other:
    mov     eax, [predigit]
    call    emit_digit_from_eax
    mov     eax, [nines_count]
    mov     edx, eax
emit_nine_loop:
    cmp     edx, 0
    je      emit_nine_done
    mov     eax, 9
    call    emit_digit_from_eax
    dec     edx
    jmp     emit_nine_loop
emit_nine_done:
    mov     [predigit], ecx
    mov     dword [nines_count], 0
    jmp     outer_next
outer_next:
    inc     dword [i_outer]
    jmp     outer_loop
outer_done:
    mov     eax, [predigit]
    inc     eax
    call    emit_digit_from_eax
    mov     eax, [nines_count]
    mov     edx, eax
final_zero_loop:
    cmp     edx, 0
    je      final_zero_done
    mov     eax, 0
    call    emit_digit_from_eax
    dec     edx
    jmp     final_zero_loop
final_zero_done:
    mov     eax, NDIGITS
    add     eax, 2
    mov     edx, eax
    mov     byte [pi_output + rdx], 10
    mov     ecx, NDIGITS
    add     ecx, 3
    mov     eax, SYS_write
    mov     edi, STDOUT
    mov     rsi, pi_output
    mov     edx, ecx
    syscall
    mov     eax, SYS_exit
    xor     edi, edi
    syscall
emit_digit_from_eax:
    push    rbx
    push    rcx
    push    rdx
    mov     ecx, [idx_out]
    add     ecx, 2
    add     al, '0'
    mov     rbx, pi_output
    mov     [rbx + rcx], al
    mov     eax, [idx_out]
    inc     eax
    mov     [idx_out], eax
    pop     rdx
    pop     rcx
    pop     rbx
    ret
