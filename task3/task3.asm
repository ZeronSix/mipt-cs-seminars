; task3.asm     Contains functions that convert numbers
;               to their string representations

section .bss
buffer  resb    64               ; output buffer


section .text
        global _start

_start:
        mov     rax, 3082
        call    print_dec 

        mov     rax, 3082
        call    print_bin 

        mov     rax, 3802
        call    print_hex

        mov     rax, 60         ; syscall <- 60 (exit)         
        mov     rdi, 0          ; exit(0)
        syscall

;---------------------------------------|
; print_char - prints a character.      |
;---------------------------------------|
; Entry - RBX (character)               |
; Exit - None                           |
; Destr - RDI, RSI, RDX, RAX            |
;---------------------------------------|
print_char:
        push    rbx
        mov     rax, 1         ; syscall <- 1
        mov     rdi, 1         ; fd      <- stdout(1)
        mov     rsi, rsp       ; buf     <- [rsp]
        mov     rdx, 1         ; count   <- 1
        pop     rbx
        syscall 
        ret


;---------------------------------------|
; print_dec - converts a number to its  |
;              string representation.   |
;---------------------------------------|
; Entry - RAX (number)                  |
; Exit  - none                          |
; Destr - R8, R9, RDX, RAX, RBX         |
;---------------------------------------|
print_dec:
        mov     r8, 0
        mov     r9, 10           ; base = 10

.loop_begin:
        xor     rdx, rdx         ; rdx = 0
        div     r9               ; rax /= 10 [rdx %= 10]
        add     rdx, '0'         ; rdx += '0'
        mov     [buffer+r8], rdx ; rbx = rdx
        inc     r8               ; i++
        cmp     rax, 0           ; if (r8 > 0)
        je      .loop2_begin
        jmp     .loop_begin
.loop2_begin:
        mov     rbx, [buffer+r8]
        call    print_char       ; print_char(buffer[i])
        cmp     r8, 0
        je      .loop2_end
        dec     r8
        jmp     .loop2_begin
.loop2_end:
        mov     rbx, `\n`
        call    print_char

        ret

;---------------------------------------|
; print_bin - converts a number to its  |
;              string representation.   |
;---------------------------------------|
; Entry - RAX (number)                  |
; Exit  - none                          |
; Destr - R8, R9, RDX, RAX, RBX         |
;---------------------------------------|
print_bin:
        mov     r8, 0
        mov     r9, 2            ; base = 2

.loop_begin:
        xor     rdx, rdx         ; rdx = 0
        div     r9               ; rax /= 10 [rdx %= 10]
        add     rdx, '0'         ; rdx += '0'
        mov     [buffer+r8], rdx ; rbx = rdx
        inc     r8               ; i++
        cmp     rax, 0           ; if (r8 > 0)
        je      .loop2_begin
        jmp     .loop_begin
.loop2_begin:
        mov     rbx, [buffer+r8]
        call    print_char       ; print_char(buffer[i])
        cmp     r8, 0
        je      .loop2_end
        dec     r8
        jmp     .loop2_begin
.loop2_end:
        mov     rbx, `\n`
        call    print_char

        ret

;---------------------------------------|
; print_hex - converts a number to its  |
;              string representation.   |
;---------------------------------------|
; Entry - RAX (number)                  |
; Exit  - none                          |
; Destr - R8, R9, RDX, RAX, RBX         |
;---------------------------------------|
print_hex:
        mov     r8, 0
        mov     r9, 16           ; base = 16

.loop_begin:
        xor     rdx, rdx         ; rdx = 0
        div     r9               ; rax /= 10 [rdx %= 10]
        cmp     rdx, 10          ; if (rdx >= 10)
        jb      .number
        sub     rdx, 10
        add     rdx, 'A'
        jmp     .movtobuf
.number:
        add     rdx, '0'         ; rdx += '0'
.movtobuf:
        mov     [buffer+r8], rdx ; rbx = rdx
        inc     r8               ; i++
        cmp     rax, 0           ; if (r8 > 0)
        je      .loop2_begin
        jmp     .loop_begin
.loop2_begin:
        mov     rbx, [buffer+r8]
        call    print_char       ; print_char(buffer[i])
        cmp     r8, 0
        je      .loop2_end
        dec     r8
        jmp     .loop2_begin
.loop2_end:
        mov     rbx, `\n`
        call    print_char

        ret

