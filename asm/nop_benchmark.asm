; nop_benchmark.asm
; x86-64 NASM program to count NOPs executed in a fixed time
; Uses Linux syscalls only (no printf)
;
; Performance Strategy:
; - Batch 10,000 NOPs per time check to reduce syscall overhead
; - Only check time after executing a batch, not after each NOP
; - This dramatically reduces the number of expensive time() calls

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
    ; Proper stack frame setup
    push rbp
    mov rbp, rsp
    sub rsp, 8          ; Align stack to 16 bytes
    
    ; Get start time
    mov rdi, 0
    call time
    mov rbx, rax        ; start time in rbx

    mov rcx, 0          ; nop counter

.loop:
    ; Execute batch of 10,000 NOPs
    ; This reduces time() syscall overhead by 10,000x
    %rep 10000
        nop
    %endrep
    add rcx, 10000      ; Add batch count to counter
    
    ; Check if 1 second has elapsed
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

    ; Write the number string
    mov rax, 1              ; sys_write
    mov rdi, 1              ; stdout
    mov rsi, numbuf+31
    sub rsi, rcx            ; rsi = start of number string
    mov rdx, rcx            ; length
    syscall

    ; Write newline
    mov rax, 1              ; sys_write
    mov rdi, 1              ; stdout
    mov rsi, newline
    mov rdx, 1
    syscall

    ; Clean up and return
    add rsp, 8
    mov rbp, rsp
    pop rbp
    xor eax, eax            ; return 0
    ret

; Mark stack as non-executable for security
section .note.GNU-stack noalloc noexec nowrite progbits
