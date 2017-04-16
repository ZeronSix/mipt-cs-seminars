	.file	"unoptimized.c"
	.intel_syntax noprefix
	.section	.rodata
	.align 8
.LC0:
	.string	"A Clockwork Orange (UK Version).txt"
	.section	.data.rel.local,"aw",@progbits
	.align 8
	.type	FILENAME, @object
	.size	FILENAME, 8
FILENAME:
	.quad	.LC0
	.section	.rodata
.LC1:
	.string	"Error while reading file!"
.LC3:
	.string	"Total run time: %lg\n"
	.text
	.globl	main
	.type	main, @function
main:
.LFB2:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 4120144
	call	clock@PLT
	mov	QWORD PTR -24[rbp], rax
	lea	rax, -4096048[rbp]
	mov	edx, 4096000
	mov	esi, 0
	mov	rdi, rax
	call	memset@PLT
	lea	rax, -4120112[rbp]
	mov	edx, 24056
	mov	esi, 0
	mov	rdi, rax
	call	memset@PLT
	mov	QWORD PTR -4120120[rbp], 0
	mov	edi, 0
	call	time@PLT
	mov	edi, eax
	call	srand@PLT
	mov	rax, QWORD PTR FILENAME[rip]
	lea	rdx, -4120120[rbp]
	lea	rcx, -4096048[rbp]
	mov	rsi, rcx
	mov	rdi, rax
	call	load_wordbuf
	test	eax, eax
	je	.L2
	mov	rax, QWORD PTR stdout[rip]
	mov	rcx, rax
	mov	edx, 25
	mov	esi, 1
	lea	rdi, .LC1[rip]
	call	fwrite@PLT
.L2:
	mov	QWORD PTR -8[rbp], 0
	jmp	.L3
.L4:
	lea	rax, -4096048[rbp]
	mov	rdx, QWORD PTR -8[rbp]
	sal	rdx, 6
	add	rdx, rax
	lea	rax, -4120112[rbp]
	mov	rsi, rdx
	mov	rdi, rax
	call	ht_insert@PLT
	add	QWORD PTR -8[rbp], 1
.L3:
	mov	rax, QWORD PTR -4120120[rbp]
	cmp	QWORD PTR -8[rbp], rax
	jb	.L4
	mov	DWORD PTR -12[rbp], 0
	jmp	.L5
.L6:
	call	rand@PLT
	mov	ecx, eax
	mov	edx, 365650691
	mov	eax, ecx
	imul	edx
	sar	edx, 8
	mov	eax, ecx
	sar	eax, 31
	sub	edx, eax
	mov	eax, edx
	imul	eax, eax, 3007
	sub	ecx, eax
	mov	eax, ecx
	lea	rdx, -4096048[rbp]
	cdqe
	sal	rax, 6
	add	rdx, rax
	lea	rax, -4120112[rbp]
	mov	rsi, rdx
	mov	rdi, rax
	call	ht_search@PLT
	add	DWORD PTR -12[rbp], 1
.L5:
	cmp	DWORD PTR -12[rbp], 999999
	jbe	.L6
	call	clock@PLT
	mov	QWORD PTR -32[rbp], rax
	mov	rax, QWORD PTR -32[rbp]
	sub	rax, QWORD PTR -24[rbp]
	pxor	xmm0, xmm0
	cvtsi2sdq	xmm0, rax
	movsd	xmm1, QWORD PTR .LC2[rip]
	divsd	xmm0, xmm1
	movsd	QWORD PTR -40[rbp], xmm0
	mov	rax, QWORD PTR -40[rbp]
	mov	QWORD PTR -4120136[rbp], rax
	movsd	xmm0, QWORD PTR -4120136[rbp]
	lea	rdi, .LC3[rip]
	mov	eax, 1
	call	printf@PLT
	mov	eax, 0
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2:
	.size	main, .-main
	.section	.rodata
.LC4:
	.string	"unoptimized.c"
.LC5:
	.string	"filename"
.LC6:
	.string	"buf"
.LC7:
	.string	"r"
.LC8:
	.string	"%63s"
	.text
	.type	load_wordbuf, @function
load_wordbuf:
.LFB3:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 48
	mov	QWORD PTR -24[rbp], rdi
	mov	QWORD PTR -32[rbp], rsi
	mov	QWORD PTR -40[rbp], rdx
	cmp	QWORD PTR -24[rbp], 0
	jne	.L9
	lea	rcx, __PRETTY_FUNCTION__.2888[rip]
	mov	edx, 57
	lea	rsi, .LC4[rip]
	lea	rdi, .LC5[rip]
	call	__assert_fail@PLT
.L9:
	cmp	QWORD PTR -32[rbp], 0
	jne	.L10
	lea	rcx, __PRETTY_FUNCTION__.2888[rip]
	mov	edx, 58
	lea	rsi, .LC4[rip]
	lea	rdi, .LC6[rip]
	call	__assert_fail@PLT
.L10:
	mov	rax, QWORD PTR -24[rbp]
	lea	rsi, .LC7[rip]
	mov	rdi, rax
	call	fopen@PLT
	mov	QWORD PTR -16[rbp], rax
	cmp	QWORD PTR -16[rbp], 0
	jne	.L11
	mov	eax, 1
	jmp	.L12
.L11:
	mov	QWORD PTR -8[rbp], 0
	jmp	.L13
.L15:
	add	QWORD PTR -8[rbp], 1
.L13:
	cmp	QWORD PTR -8[rbp], 63999
	ja	.L14
	mov	rax, QWORD PTR -8[rbp]
	sal	rax, 6
	mov	rdx, rax
	mov	rax, QWORD PTR -32[rbp]
	add	rdx, rax
	mov	rax, QWORD PTR -16[rbp]
	lea	rsi, .LC8[rip]
	mov	rdi, rax
	mov	eax, 0
	call	__isoc99_fscanf@PLT
	cmp	eax, 1
	je	.L15
.L14:
	mov	rax, QWORD PTR -40[rbp]
	mov	rdx, QWORD PTR -8[rbp]
	mov	QWORD PTR [rax], rdx
	mov	rax, QWORD PTR -16[rbp]
	mov	rdi, rax
	call	fclose@PLT
	mov	eax, 0
.L12:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3:
	.size	load_wordbuf, .-load_wordbuf
	.section	.rodata
	.align 8
	.type	__PRETTY_FUNCTION__.2888, @object
	.size	__PRETTY_FUNCTION__.2888, 13
__PRETTY_FUNCTION__.2888:
	.string	"load_wordbuf"
	.align 8
.LC2:
	.long	0
	.long	1093567616
	.ident	"GCC: (Debian 6.3.0-12) 6.3.0 20170406"
	.section	.note.GNU-stack,"",@progbits
