	.file	1 "Fibonacci.c"
	.section .mdebug.abi32
	.previous
	.nan	legacy
	.module	fp=32
	.module	oddspreg
	.abicalls
	.option	pic0
	.text
	.align	2
	.globl	main
	.set	nomips16
	.set	nomicromips
	.ent	main
	.type	main, @function
main:
	.frame	$sp,32,$31		# vars= 0, regs= 1/0, args= 16, gp= 8
	.mask	0x80000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	addiu	$sp,$sp,-32
	sw	$31,28($sp)
	li	$4,10			# 0xa
	jal	fib
	nop

	lw	$31,28($sp)
	addiu	$sp,$sp,32
	j	$31
	nop

	.set	macro
	.set	reorder
	.end	main
	.size	main, .-main
	.align	2
	.globl	fib
	.set	nomips16
	.set	nomicromips
	.ent	fib
	.type	fib, @function
fib:
	.frame	$sp,32,$31		# vars= 0, regs= 2/0, args= 16, gp= 8
	.mask	0x80010000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	addiu	$sp,$sp,-32
	sw	$31,28($sp)
	sw	$16,24($sp)
	sw	$4,32($sp)
	lw	$2,32($sp)
	slt	$2,$2,2
	beq	$2,$0,$L4
	nop

	lw	$2,32($sp)
	b	$L5
	nop

$L4:
	lw	$2,32($sp)
	addiu	$2,$2,-1
	move	$4,$2
	jal	fib
	nop

	move	$16,$2
	lw	$2,32($sp)
	addiu	$2,$2,-2
	move	$4,$2
	jal	fib
	nop

	addu	$2,$16,$2
$L5:
	lw	$31,28($sp)
	lw	$16,24($sp)
	addiu	$sp,$sp,32
	j	$31
	nop

	.set	macro
	.set	reorder
	.end	fib
	.size	fib, .-fib
	.ident	"GCC: (Sourcery CodeBench Lite 2016.05-8) 5.3.0"
