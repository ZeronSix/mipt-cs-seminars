; task6.asm     Contains realization of printf(...) in assembly language.
%include "printfex.asm"

section .text
        global  _start
_start:
        push    100d
        push    3802d
        push    msg3
        push    'I'
        mov     r9, '$'
        mov     r8,  0
        mov     rcx, 3802d
        mov     rdx, 256
        mov     rsi, msg2
        mov     rdi, msg
        call    printfex

        mov     rax, 60d        ; syscall <- 60 (exit)
        syscall

section .data
msg     db      `Hello, %s world!%o %x %%Test%d\n %c \n and %c %s %x %d %%`, 0
msg2    db      '---TO BE PASTED---', 0
msg3    db      'love', 0


