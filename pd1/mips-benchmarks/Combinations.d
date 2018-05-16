
Combinations.elf:     file format elf32-tradbigmips


Disassembly of section .text:

80020000 <main>:
80020000:	27bdffe0 	addiu	sp,sp,-32
80020004:	afbf001c 	sw	ra,28(sp)
80020008:	24050002 	li	a1,2
8002000c:	2404000a 	li	a0,10
80020010:	0c008021 	jal	80020084 <comb>
80020014:	00000000 	nop
80020018:	8fbf001c 	lw	ra,28(sp)
8002001c:	27bd0020 	addiu	sp,sp,32
80020020:	03e00008 	jr	ra
80020024:	00000000 	nop

80020028 <fact>:
80020028:	27bdfff0 	addiu	sp,sp,-16
8002002c:	afa40010 	sw	a0,16(sp)
80020030:	24020001 	li	v0,1
80020034:	afa2000c 	sw	v0,12(sp)
80020038:	8fa20010 	lw	v0,16(sp)
8002003c:	afa20008 	sw	v0,8(sp)
80020040:	10000008 	b	80020064 <fact+0x3c>
80020044:	00000000 	nop
80020048:	8fa3000c 	lw	v1,12(sp)
8002004c:	8fa20008 	lw	v0,8(sp)
80020050:	70621002 	mul	v0,v1,v0
80020054:	afa2000c 	sw	v0,12(sp)
80020058:	8fa20008 	lw	v0,8(sp)
8002005c:	2442ffff 	addiu	v0,v0,-1
80020060:	afa20008 	sw	v0,8(sp)
80020064:	8fa20008 	lw	v0,8(sp)
80020068:	28420002 	slti	v0,v0,2
8002006c:	1040fff6 	beqz	v0,80020048 <fact+0x20>
80020070:	00000000 	nop
80020074:	8fa2000c 	lw	v0,12(sp)
80020078:	27bd0010 	addiu	sp,sp,16
8002007c:	03e00008 	jr	ra
80020080:	00000000 	nop

80020084 <comb>:
80020084:	27bdffe0 	addiu	sp,sp,-32
80020088:	afbf001c 	sw	ra,28(sp)
8002008c:	afb00018 	sw	s0,24(sp)
80020090:	afa40020 	sw	a0,32(sp)
80020094:	afa50024 	sw	a1,36(sp)
80020098:	8fa40020 	lw	a0,32(sp)
8002009c:	0c00800a 	jal	80020028 <fact>
800200a0:	00000000 	nop
800200a4:	00408025 	move	s0,v0
800200a8:	8fa40024 	lw	a0,36(sp)
800200ac:	0c00800a 	jal	80020028 <fact>
800200b0:	00000000 	nop
800200b4:	0202001a 	div	zero,s0,v0
800200b8:	004001f4 	teq	v0,zero,0x7
800200bc:	00001010 	mfhi	v0
800200c0:	00008012 	mflo	s0
800200c4:	8fa30020 	lw	v1,32(sp)
800200c8:	8fa20024 	lw	v0,36(sp)
800200cc:	00621023 	subu	v0,v1,v0
800200d0:	00402025 	move	a0,v0
800200d4:	0c00800a 	jal	80020028 <fact>
800200d8:	00000000 	nop
800200dc:	0202001a 	div	zero,s0,v0
800200e0:	004001f4 	teq	v0,zero,0x7
800200e4:	00001010 	mfhi	v0
800200e8:	00001012 	mflo	v0
800200ec:	8fbf001c 	lw	ra,28(sp)
800200f0:	8fb00018 	lw	s0,24(sp)
800200f4:	27bd0020 	addiu	sp,sp,32
800200f8:	03e00008 	jr	ra
800200fc:	00000000 	nop

Disassembly of section .reginfo:

80020100 <.reginfo>:
80020100:	a001003c 	sb	at,60(zero)
	...

Disassembly of section .MIPS.abiflags:

80020118 <.MIPS.abiflags>:
80020118:	00002001 	movf	a0,zero,$fcc0
8002011c:	01010001 	movt	zero,t0,$fcc0
	...
80020128:	00000001 	movf	zero,zero,$fcc0
8002012c:	00000000 	nop

Disassembly of section .pdr:

00000000 <.pdr>:
   0:	80020000 	lb	v0,0(zero)
   4:	80000000 	lb	zero,0(zero)
   8:	fffffffc 	sdc3	$31,-4(ra)
	...
  14:	00000020 	add	zero,zero,zero
  18:	0000001d 	0x1d
  1c:	0000001f 	0x1f
  20:	80020028 	lb	v0,40(zero)
	...
  34:	00000010 	mfhi	zero
  38:	0000001d 	0x1d
  3c:	0000001f 	0x1f
  40:	80020084 	lb	v0,132(zero)
  44:	80010000 	lb	at,0(zero)
  48:	fffffffc 	sdc3	$31,-4(ra)
	...
  54:	00000020 	add	zero,zero,zero
  58:	0000001d 	0x1d
  5c:	0000001f 	0x1f

Disassembly of section .comment:

00000000 <.comment>:
   0:	4743433a 	c1	0x143433a
   4:	2028536f 	addi	t0,at,21359
   8:	75726365 	jalx	5c98d94 <main-0x7a38726c>
   c:	72792043 	0x72792043
  10:	6f646542 	0x6f646542
  14:	656e6368 	0x656e6368
  18:	204c6974 	addi	t4,v0,26996
  1c:	65203230 	0x65203230
  20:	31362e30 	andi	s6,t1,0x2e30
  24:	352d3829 	ori	t5,t1,0x3829
  28:	20352e33 	addi	s5,at,11827
  2c:	Address 0x000000000000002c is out of bounds.


Disassembly of section .gnu.attributes:

00000000 <.gnu.attributes>:
   0:	41000000 	bc0f	4 <main-0x8001fffc>
   4:	0f676e75 	jal	d9db9d4 <main-0x7264462c>
   8:	00010000 	sll	zero,at,0x0
   c:	00070401 	0x70401
