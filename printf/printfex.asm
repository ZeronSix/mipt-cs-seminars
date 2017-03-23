; printfex.asm  Formatted print function (printf(...) alternative)
section .bss
buffer  resb    64      ; output buffer

section .text

;---- HELPERS ----

;----------------------------;
; print_char - prints a char ;
;----------------------------;
; Entry - macro parameter    ;
; Exit - none                ;
; Destr - rax, rdi, rsi, rdx ;
;----------------------------;
%macro print_char 1
        mov     rax, 1   ; syscall <- 1 (write)
        mov     rdi, 1   ; fd      <- stdout(1)
        lea     rsi, %1  ; buf     <- [%1]
        mov     rdx, 1   ; count   <- 1
        syscall 
%endmacro

;---------------------------------------;
; print_number - prints a number        ;
;---------------------------------------;
; Entry - RAX (number), RSI (0b, 1d, 2h);
; Exit  - None                          ;
; Destr - R8, RDX, RAX, RBX, RSI,       ;
;         RAX                           ;
;---------------------------------------;
print_number:
        mov     r8, 0   ; r8 = 0
        mov     r9, 10  ; r9 = 10 (base for decimal)

.loop_begin:
        cmp     rsi, 0 
        je      .bin
        cmp     rsi, 1
        je      .dec
        cmp     rsi, 2
        je      .hex

.bin:
        mov     rdx, rax         ; rdx = rax
        and     rdx, 1           ; rdx &= 1
        shr     rax, 1           ; rax /= 2
        add     rdx, '0'         ; rdx += '0'
        jmp     .movtobuf
.dec:
        xor     rdx, rdx         ; rdx = 0
        div     r9               ; rax /= 10 [rdx %= 10]
        add     rdx, '0'         ; rdx += '0'
        jmp     .movtobuf
.hex:
        mov     rdx, rax
        and     rdx, 1111b 
        shr     rax, 4           ; rax /= 2
        cmp     rdx, 10          ; if (rdx < 10)
        jb      .hex_number      ;
        sub     rdx, 10          ; rdx += -10 + 'A'
        add     rdx, 'A'
        jmp     .movtobuf
.hex_number:
        add     rdx, '0'         ; rdx += '0'

.movtobuf:
        mov     [buffer+r8], rdx ; rbx = rdx
        inc     r8               ; i++
        cmp     rax, 0           ; if (r8 > 0)
        je      .loop2_begin
        jmp     .loop_begin
.loop2_begin:
        print_char [buffer+r8]   ; print_char(buffer[i])
        cmp     r8, 0            ; if (r8 == 0)
        je      .loop2_end       ;      goto.loop2_end
        dec     r8               ; r8--
        jmp     .loop2_begin     ; goto .loop2_begin
.loop2_end:
        ret

;---------------------------------------;
; printfex - printf extended            ;
;---------------------------------------;
; Entry - RDI (format string)           ;
; Exit  - none                          ;
;---------------------------------------;
printfex:
        push    rbp
        push    rbx
        mov     rbp, rsp

        mov     r8, 0           ; i = 0
        mov     r9, 0           ; r9 = 0 (argc)
.loop_begin:
        mov     r10, 0          ; c == '\0'
        cmp     byte [rdi+r8], r10b   ; if s[i] != '\0'
        je      .loop_end

        mov     r10, [percent]  ; c == '%'
        cmp     byte [rdi+r8], r10b
        jne     .regular_char 

.percent:
        inc     r8
        cmp     byte [rdi+r8], r10b
        je      .percent_percent
        mov     r10, 'd'
        cmp     byte [rdi+r8], r10b
        je      .percent_decimal 
        mov     r10, 'b'
        cmp     byte [rdi+r8], r10b
        je      .percent_binary 
        mov     r10, 'x'
        cmp     byte [rdi+r8], r10b
        je      .percent_hex 
        mov     r10, 's'
        cmp     byte [rdi+r8], r10b
        je      .percent_str 
        mov     r10, 'c'
        cmp     byte [rdi+r8], r10b
        je      .percent_char
        
.percent_percent:
        push    rdi   
        print_char [percent]
        pop     rdi
        jmp     .loop_inc
.percent_decimal:
        mov     rsi, 1
        jmp     .print_number
.percent_binary:
        mov     rsi, 0
        jmp     .print_number
.percent_hex:
        mov     rsi, 2
        jmp     .print_number
.print_number:
        push    r8
        push    r9
        push    rdi
        push    rsi
        mov     rax, [rbp+24+8*r9]
        call    print_number
        pop     rsi
        pop     rdi
        pop     r9
        pop     r8 
        inc     r9
        jmp     .loop_inc
.percent_str:
        push    rsi
        push    rdi
        push    r8
        mov     rsi, [rbp+24+8*r9]
        inc     r9
        mov     r8, 0
.strlen_loop_start:
        mov     r10, 0          ; c == '\0'
        cmp     byte [rsi+r8], r10b   ; if s[i] != '\0'
        je      .strlen_loop_end
        inc     r8
        jmp     .strlen_loop_start
.strlen_loop_end:
        mov     rax, 1
        mov     rdi, 1
        mov     rdx, r8
        syscall
        pop     r8
        pop     rdi
        pop     rsi
        jmp     .loop_inc
.percent_char:
        push    rsi
        push    rdi
        mov     r10, [rbp+24+8*r9]
        mov     [buffer], r10
        inc     r9
        print_char [buffer]
        pop     rdi
        pop     rsi
        jmp     .loop_inc

.regular_char:
        mov     r10, [rdi+r8]
        mov     [buffer], r10
        push    rdx
        push    rsi
        push    rdi
        print_char [buffer]
        pop     rdi
        pop     rsi
        pop     rdx
        
.loop_inc:
        inc     r8
        jmp     .loop_begin

.loop_end:
        pop     rbx
        pop     rbp
        ret

section .data
endl    db      `\n`
percent db      "%"
        
