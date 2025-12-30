; nop_benchmark.asm
; x86-64 NASM program to count NOPs executed in a fixed time
; Uses Linux syscalls only (no printf)

section .data
    msg db "NOPs executed: ", 0
    msglen equ $-msg
    ; numstr and numstrlen removed, restore dynamic output
    newline db 10, 0

section .bss
    nops resq 1
    numbuf resb 32      ; buffer for number string

section .text
    global main
    extern time

main:
    sub rsp, 8
    mov rdi, 0
    call time
    mov rbx, rax        ; start time


    mov rcx, 0          ; nop counter
.loop:
    nop
    inc rcx
    mov rdi, 0
    call time
    sub rax, rbx
    cmp rax, 1
    jl .loop            ; loop until at least 1 second has elapsed

    mov [nops], rcx     ; store the NOP count

    ; Debug: Use a fixed test value for output
    ; Only write the static message for debug

    mov rax, 1          ; sys_write
    mov rdi, 1          ; stdout
    mov rsi, msg
    mov rdx, msglen
    syscall

    ; Convert NOP count to string
    mov rax, [nops]         ; NOP count
    mov rbx, 10
    lea rdi, [numbuf+31]    ; pointer to end of buffer
    mov byte [rdi], 0       ; null terminator (not needed for write, but safe)
    mov rcx, 0              ; digit count
.numloop:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    test rax, rax
    jnz .numloop

    mov rax, 1              ; sys_write
    mov rdi, 1              ; stdout
    mov rsi, rdi            ; clear rsi
    lea rsi, [numbuf+31]
    sub rsi, rcx            ; rsi = start of number string
    mov rdx, rcx            ; length
    syscall

    mov rax, 1              ; sys_write
    mov rdi, 1              ; stdout
    mov rsi, newline
    mov rdx, 1
    syscall

    add rsp, 8
    ret
    test rax, rax
