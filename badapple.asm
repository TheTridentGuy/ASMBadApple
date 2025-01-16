global _start

section .data
    frames db 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff

section .text
_start:
    ; sys_exit
    mov rax, 60
    xor rdi, rdi
    syscall