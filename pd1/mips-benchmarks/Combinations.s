	.file	1 "Combinations.c"
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
	li	$5,2			# 0x2
	li	$4,10			# 0xa
	jal	comb
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
	.globl	fact
	.set	nomips16
	.set	nomicromips
	.ent	fact
	.type	fact, @function
fact:
	.frame	$sp,16,$31		# vars= 8, regs= 0/0, args= 0, gp= 8
	.mask	0x00000000,0
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	addiu	$sp,$sp,-16
	sw	$4,16($sp)
	li	$2,1			# 0x1
	sw	$2,12($sp)
	lw	$2,16($sp)
	sw	$2,8($sp)
	b	$L4
	nop

$L5:
	lw	$3,12($sp)
	lw	$2,8($sp)
	mul	$2,$3,$2
	sw	$2,12($sp)
	lw	$2,8($sp)
	addiu	$2,$2,-1
	sw	$2,8($sp)
$L4:
	lw	$2,8($sp)
	slt	$2,$2,2
	beq	$2,$0,$L5
	nop

	lw	$2,12($sp)
	addiu	$sp,$sp,16
	j	$31
	nop

	.set	macro
	.set	reorder
	.end	fact
	.size	fact, .-fact
	.align	2
	.globl	comb
	.set	nomips16
	.set	nomicromips
	.ent	comb
	.type	comb, @function
comb:
	.frame	$sp,32,$31		# vars= 0, regs= 2/0, args= 16, gp= 8
	.mask	0x80010000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	addiu	$sp,$sp,-32
	sw	$31,28($sp)
	sw	$16,24($sp)
	sw	$4,32($sp)
	sw	$5,36($sp)
	lw	$4,32($sp)
	jal	fact
	nop

	move	$16,$2
	lw	$4,36($sp)
	jal	fact
	nop

	div	$0,$16,$2
	teq	$2,$0,7
	mfhi	$2
	mflo	$16
	lw	$3,32($sp)
	lw	$2,36($sp)
	subu	$2,$3,$2
	move	$4,$2
	jal	fact
	nop

	div	$0,$16,$2
	teq	$2,$0,7
	mfhi	$2
	mflo	$2
	lw	$31,28($sp)
	lw	$16,24($sp)
	addiu	$sp,$sp,32
	j	$31
	nop

	.set	macro
	.set	reorder
	.end	comb
	.size	comb, .-comb
	.ident	"GCC: (Sourcery CodeBench Lite 2016.05-8) 5.3.0"
