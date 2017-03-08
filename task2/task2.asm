; task2.asm     reads a number in a bin, dec or hex representation. Input: 0/1/3 number

section .bss 
        mode    resb 1          ; read mode
        num_buf resb 8          ; number buffer

section .text
        global  _start

_start:
        ; Reading mode
        mov     rax, 0          ; syscall 0 (write)
        mov     rdi, 0          ; fd    <- stdin (0)
        mov     rsi, mode       ; buf   <- mode
        mov     rdx, 1          ; count <- 1
        syscall
        
        ; Read number
        mov     rax, 0          ; syscall 0 (write)
        mov     rdi, 0          ; fd    <- stdin (0)
        mov     rsi, num_buf    ; buf   <- num_buf
        mov     rdx, 8          ; count <- 1
        syscall

        dec     rax             ; 
        mov     rdx, rax        ; buf_len = read(...) - 1

        ; convert to str
        movzx   rax, byte [mode]     ; rax = *mode
        mov     rdi, num_buf    ; rdi = num_buf
        call str_to_num         

        mov     r8, rax         ; tmp = str_to_num(..)

        mov     rax, 60         ; syscall 60 (exit)
        mov     rdi, r8         ; return tmp
        syscall

;------------------------------------------------------|
; str_to_num - converts str to number and returns it   |
;------------------------------------------------------|
; Entry - RAX (number base, 0 - bin, 1 - dec, 2 - hex) |
;         RDI (input buffer)                           |
;         RDX (input buffer len)                       |
; Exit  - RAX                                          |
; Destr - R8, R9, r10, r11                             |
;-------------------------------------------------------
str_to_num:
        cmp     rax, '0'        ; if (base_code == BIN)
        jz      .bin
        cmp     rax, '1'        ; if (base_code == DEC)
        jz      .dec
        jmp     .hex            ; else // base_code == HEX
               
.bin:
        mov     r8, 2           ; base = 2 
        jmp     .for_init
.dec:
        mov     r8, 10          ; base = 10
        jmp     .for_init
.hex:
        mov     r8, 16          ; base = 16

.for_init:
        mov     r10, 0          ; num = 0
        mov     r9, 0           ; i = 0
.for_cond:
        cmp     r9, rdx         ; i != buf_len
        jb      .for_body 
        jmp     .for_end
.for_body:
        movzx   r11, byte [rdi+r9]   ; c = num_buf[r9]
        cmp     r11, 'A'        ; if (num_buf[r9] > 'A')
        jae     .add_letter
        sub     r11, '0'        ; c -= '0'
        jmp     .mul
.add_letter:
        sub     r11, 'A'        ; c = c - 'A' + 10
        add     r11, 10         ;
.mul:

        imul    r10, r8         ; num *= base
        add     r10, r11        ; num += c

        inc     r9              ; i++
        jmp     .for_cond

.for_end:
        mov     rax, r10        ; return num
        ret
