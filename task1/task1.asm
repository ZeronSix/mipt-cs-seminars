section .text
        global  _start
_start:
        mov     rax, 1          ; syscall 1 is write
        mov     rdi, 1          ; file handle 1 is stdout
        mov     rsi, msg        ; pointer to output string
        mov     rdx, msg_len    ; output string length
        syscall             

        mov     rax, 60         ; syscall 60 is exit
        mov     rdi, 0          ; exit code 0
        syscall

section .data
msg     db      "Hello, world!", 10
msg_len equ     $-msg               ; len = strlen(msg);

