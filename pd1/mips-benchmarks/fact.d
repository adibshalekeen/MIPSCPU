
fact.elf:     file format elf32-tradbigmips


Disassembly of section .text:

80020000 <main>:
80020000:	27bdffd8 	addiu	sp,sp,-40
80020004:	afbf0024 	sw	ra,36(sp)
80020008:	afa00018 	sw	zero,24(sp)
8002000c:	10000008 	b	80020030 <main+0x30>
80020010:	00000000 	nop
80020014:	8fa40018 	lw	a0,24(sp)
80020018:	0c008015 	jal	80020054 <factorial>
8002001c:	00000000 	nop
80020020:	afa2001c 	sw	v0,28(sp)
80020024:	8fa20018 	lw	v0,24(sp)
80020028:	24420001 	addiu	v0,v0,1
8002002c:	afa20018 	sw	v0,24(sp)
80020030:	8fa20018 	lw	v0,24(sp)
80020034:	2842000a 	slti	v0,v0,10
80020038:	1440fff6 	bnez	v0,80020014 <main+0x14>
8002003c:	00000000 	nop
80020040:	00001025 	move	v0,zero
80020044:	8fbf0024 	lw	ra,36(sp)
80020048:	27bd0028 	addiu	sp,sp,40
8002004c:	03e00008 	jr	ra
80020050:	00000000 	nop

80020054 <factorial>:
80020054:	27bdffe0 	addiu	sp,sp,-32
80020058:	afbf001c 	sw	ra,28(sp)
8002005c:	afa40020 	sw	a0,32(sp)
80020060:	8fa20020 	lw	v0,32(sp)
80020064:	14400004 	bnez	v0,80020078 <factorial+0x24>
80020068:	00000000 	nop
8002006c:	24020001 	li	v0,1
80020070:	10000009 	b	80020098 <factorial+0x44>
80020074:	00000000 	nop
80020078:	8fa20020 	lw	v0,32(sp)
8002007c:	2442ffff 	addiu	v0,v0,-1
80020080:	00402025 	move	a0,v0
80020084:	0c008015 	jal	80020054 <factorial>
80020088:	00000000 	nop
8002008c:	00401825 	move	v1,v0
80020090:	8fa20020 	lw	v0,32(sp)
80020094:	70621002 	mul	v0,v1,v0
80020098:	8fbf001c 	lw	ra,28(sp)
8002009c:	27bd0020 	addiu	sp,sp,32
800200a0:	03e00008 	jr	ra
800200a4:	00000000 	nop
	...

Disassembly of section .reginfo:

800200b0 <.reginfo>:
800200b0:	a000001c 	sb	zero,28(zero)
	...

Disassembly of section .MIPS.abiflags:

800200c8 <.MIPS.abiflags>:
800200c8:	00002001 	movf	a0,zero,$fcc0
800200cc:	01010001 	movt	zero,t0,$fcc0
	...
800200d8:	00000001 	movf	zero,zero,$fcc0
800200dc:	00000000 	nop

Disassembly of section .pdr:

00000000 <.pdr>:
   0:	80020000 	lb	v0,0(zero)
   4:	80000000 	lb	zero,0(zero)
   8:	fffffffc 	sdc3	$31,-4(ra)
	...
  14:	00000028 	0x28
  18:	0000001d 	0x1d
  1c:	0000001f 	0x1f
  20:	80020054 	lb	v0,84(zero)
  24:	80000000 	lb	zero,0(zero)
  28:	fffffffc 	sdc3	$31,-4(ra)
	...
  34:	00000020 	add	zero,zero,zero
  38:	0000001d 	0x1d
  3c:	0000001f 	0x1f

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
