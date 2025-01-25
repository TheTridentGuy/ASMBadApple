section .data
    byte_buf: db 0x00
    nl: db 0x0a
    frames: db 0x0e,0x1e,0x1f,0x0f,0x0f,0x6f,0x3e,0x3e,  0x0e,0x1e,0x1e,0x1e,0x2f,0x2f,0x3e,0x3e,  0x1c,0x3e,0x3e,0x1e,0x1e,0x1c,0x4c,0x7e,  0x60,0x71,0xf1,0xfb,0xfd,0xf7,0x67,0x07,  0x00,0x00,0x30,0x30,0x00,0x00,0x00,0x00
    frames_len: equ $ - frames
    nls: db 0x0a, 0x0a, 0x0a, 0x0a, 0x0a, 0x0a, 0x0a, 0x0a
    nls_len: equ $ - nls
    frame_delay: dq 0, 500000000

section .text
    global _start

_start:
    .inf:
    mov r12, 0 ; frame index
    .frame_loop:
        mov r13, 0b00000111 ; check for divisibility by 8
        and r13, r12
        jnz .finish_loop ; skip if not an 8th frame
        mov rax, 35 ; sys_nanosleep
        mov rdi, frame_delay
        mov rsi, 0
        syscall
        call write_nls
        .finish_loop:
            mov rdi, [frames+r12] ; first arg for write_line **REMEMBER TO DEREFERENCE**
            call write_line
            inc r12
            cmp r12, frames_len
            jl .frame_loop
    jmp .inf
    ; sys_exit with code 0
    mov rax, 60
    xor rdi, rdi
    syscall

write_nls:
    ; write some newlines
    mov rsi, nls
    mov rax, 1 ; sys_write
    mov rdi, 1 ; stdout
    mov rdx, nls_len ; the length of the string of newlines
    syscall
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
    