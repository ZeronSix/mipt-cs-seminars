; task5.asm     Contains function that sums its arguments until 0 is met.

section .text
        global _start
_start:
        push     0
        push     5
        push     10
        push     15
        push     20
        push     7
        push     8
        call     sum_func


        mov     rax, 60     ; syscall <- 60 (exit (rdi))
        syscall
        
;-------------------------------------------------
; sum_func - sums its arguments until 0 is met.  |
;------------------------------------------------|
; Entry - stack                                  |
; Exit  - rdi                                    |
;------------------------------------------------|
sum_func:
        push    rbp
        push    r9
        push    r10
        mov     rbp, rsp

        mov     r9, 24           ; offset = 24
        mov     r10, 0           ; sum = 0
.loop:
        cmp     word [rsp+r9], 0 ; if stack[offset] == 0
        je      .sum_exit

        add     r9, 8            ; offset += 8
        add     r10, [rsp+r9]    ; sum += stack[offset]
        jmp     .loop
.sum_exit:
        mov     rdi, r10         ; return sum

        pop     r10
        pop     r9
        pop     rbp
        ret 
        
