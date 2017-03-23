; task6.asm     Contains realization of printf(...) in assembly language.
%include "printfex.asm"

section .text
        global  _start
_start:
        push    '$' 
        push    666
        push    3802
        push    256
        push    msg2
        mov     rdi, msg
        call    printfex

        mov     rax, 60d        ; syscall <- 60 (exit)
        syscall

section .data
msg     db      `Hello, %s world!%b %x %%Test%d\n %c \n`, 0
msg2    db      '---TO BE PASTED---', 0


