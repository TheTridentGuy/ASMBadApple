section .data
    byte_buf: db 0x00
    nl: db 0x0a
    frames: db 0xf0, 0xf0, 0xf0, 0xf0, 0x0f, 0x0f, 0x0f, 0x0f
    frames_len: equ $ - frames

section .text
    global _start

_start:
    mov r12, 0 ; frame index
    call write_nls
    .frame_loop:
        mov rdi, [frames+r12] ; first arg for write_line **REMEMBER TO DEREFERENCE**
        call write_line
        inc r12
        cmp r12, frames_len
        jl .frame_loop
    ; sys_exit with code 0
    mov rax, 60
    xor rdi, rdi
    syscall

write_nls:
    ; write some newlines
    mov r8, 25
    .write_nl_loop:
        mov rdi, nl
        call write
        dec r8
        jnz .write_nl_loop
    ret

write_line:
    ; write out a byte as a string, i.e. 01010101b -> "00000000"
    mov r8, rdi ; save argument rdi into r8
    mov r10, 8 ; loop counter
    .write_loop:
        ; check whether to write a 1 or a 0
        mov r9, r8
        and r9, 0b10000000 ; check if the most significant bit is 1
        jz .write_zero ; write a zero if the result of the and operation is false
        jmp .write_one
        ; represent a zero
        .write_zero:
            mov byte [byte_buf], 0x2e
            jmp .write_loop_next
        ; represent a one
        .write_one:
            mov byte [byte_buf], 0x23
            jmp .write_loop_next
        ; iterate again if r10 > 0
        .write_loop_next:
            ; finish writing:
            mov rdi, byte_buf
            call write
            mov rdi, byte_buf ; write twice for more square output
            call write
            shl r8, 1 ; shift r8 to the right by 1
            dec r10
            jnz .write_loop
    mov rdi, nl
    call write
    ret

write:
    ; sys_write 1 byte from rdi
    mov rsi, rdi ; grab value to print from rdi
    mov rax, 1 ; sys_write
    mov rdi, 1 ; stdout
    mov rdx, 1 ; 1 byte
    syscall
    ret
    