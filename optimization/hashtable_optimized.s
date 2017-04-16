	.file	"hashtable_optimized.c"
	.intel_syntax noprefix
	.text
	.type	hash, @function
hash:
.LFB2:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	push	rbx
	.cfi_offset 3, -24
	mov	QWORD PTR -16[rbp], rdi
#APP
# 9 "hashtable_optimized.c" 1
	.intel_syntax noprefix
	mov eax, 0
	mov r8, 0
	loop_cond:
	mov r8, 0
	movzx r8, byte ptr [rdi]
	test r8b, r8b
	je loop_end
	add eax, r8d
	mov r8d, eax
	sal r8d, 10
	add eax, r8d
	mov r8d, eax
	shr r8d, 6
	xor eax, r8d
	inc rdi
	jmp loop_cond
	loop_end:
	mov r8d, eax
	sal r8d, 3
	add eax, r8d
	mov r8d, eax
	shr r8d, 11
	xor eax, r8d
	mov r8d, eax
	sal r8d, 15
	add eax, r8d
	mov ebx, 3007
	mov edx, 0
	div ebx
	mov eax, edx
	
# 0 "" 2
#NO_APP
	nop
	pop	rbx
	pop	rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2:
	.size	hash, .-hash
	.globl	ht_search
	.type	ht_search, @function
ht_search:
.LFB3:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	mov	QWORD PTR -8[rbp], rdi
	mov	QWORD PTR -16[rbp], rsi
#APP
# 47 "hashtable_optimized.c" 1
	.intel_syntax noprefix
	mov r9, rdi
	mov r10, rsi
	mov rdi, r10
	call hash
	mov rax, [r9 + 8 * rax]
	searchloop_cond:
	test rax, rax
	je searchloop_end
	mov rdi, r10
	mov rsi, [rax+8]
	mov r11, rax
	call strcmp@PLT
	mov esi, eax
	mov rax, r11
	test esi, esi
	je searchloop_end
	mov rax, [rax]
	jmp searchloop_cond
	searchloop_end:
	
# 0 "" 2
#NO_APP
	nop
	pop	rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3:
	.size	ht_search, .-ht_search
	.globl	ht_insert
	.type	ht_insert, @function
ht_insert:
.LFB4:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 32
	mov	QWORD PTR -24[rbp], rdi
	mov	QWORD PTR -32[rbp], rsi
	mov	rdx, QWORD PTR -32[rbp]
	mov	rax, QWORD PTR -24[rbp]
	mov	rsi, rdx
	mov	rdi, rax
	call	ht_search
	test	rax, rax
	jne	.L4
	mov	esi, 16
	mov	edi, 1
	call	calloc@PLT
	mov	QWORD PTR -8[rbp], rax
	mov	rax, QWORD PTR -32[rbp]
	mov	rdi, rax
	call	hash
	mov	DWORD PTR -12[rbp], eax
	mov	rax, QWORD PTR -24[rbp]
	mov	edx, DWORD PTR -12[rbp]
	mov	rdx, QWORD PTR [rax+rdx*8]
	mov	rax, QWORD PTR -8[rbp]
	mov	QWORD PTR [rax], rdx
	mov	rax, QWORD PTR -8[rbp]
	mov	rdx, QWORD PTR -32[rbp]
	mov	QWORD PTR 8[rax], rdx
	mov	rax, QWORD PTR -24[rbp]
	mov	edx, DWORD PTR -12[rbp]
	mov	rcx, QWORD PTR -8[rbp]
	mov	QWORD PTR [rax+rdx*8], rcx
.L4:
	mov	eax, 0
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE4:
	.size	ht_insert, .-ht_insert
	.ident	"GCC: (Debian 6.3.0-12) 6.3.0 20170406"
	.section	.note.GNU-stack,"",@progbits
