
Swap.elf:     file format elf32-tradbigmips


Disassembly of section .text:

80020000 <main>:
80020000:	27bdffd0 	addiu	sp,sp,-48
80020004:	afbf002c 	sw	ra,44(sp)
80020008:	24020005 	li	v0,5
8002000c:	afa20020 	sw	v0,32(sp)
80020010:	24020009 	li	v0,9
80020014:	afa20024 	sw	v0,36(sp)
80020018:	27a20020 	addiu	v0,sp,32
8002001c:	afa20018 	sw	v0,24(sp)
80020020:	27a20024 	addiu	v0,sp,36
80020024:	afa2001c 	sw	v0,28(sp)
80020028:	8fa5001c 	lw	a1,28(sp)
8002002c:	8fa40018 	lw	a0,24(sp)
80020030:	0c00801b 	jal	8002006c <swap>
80020034:	00000000 	nop
80020038:	8fa20018 	lw	v0,24(sp)
8002003c:	8c420000 	lw	v0,0(v0)
80020040:	afa20020 	sw	v0,32(sp)
80020044:	8fa2001c 	lw	v0,28(sp)
80020048:	8c420000 	lw	v0,0(v0)
8002004c:	afa20024 	sw	v0,36(sp)
80020050:	8fa30020 	lw	v1,32(sp)
80020054:	8fa20024 	lw	v0,36(sp)
80020058:	00621021 	addu	v0,v1,v0
8002005c:	8fbf002c 	lw	ra,44(sp)
80020060:	27bd0030 	addiu	sp,sp,48
80020064:	03e00008 	jr	ra
80020068:	00000000 	nop

8002006c <swap>:
8002006c:	27bdfff0 	addiu	sp,sp,-16
80020070:	afa40010 	sw	a0,16(sp)
80020074:	afa50014 	sw	a1,20(sp)
80020078:	8fa20010 	lw	v0,16(sp)
8002007c:	8c420000 	lw	v0,0(v0)
80020080:	afa20008 	sw	v0,8(sp)
80020084:	8fa20014 	lw	v0,20(sp)
80020088:	8c430000 	lw	v1,0(v0)
8002008c:	8fa20010 	lw	v0,16(sp)
80020090:	ac430000 	sw	v1,0(v0)
80020094:	8fa20014 	lw	v0,20(sp)
80020098:	8fa30008 	lw	v1,8(sp)
8002009c:	ac430000 	sw	v1,0(v0)
800200a0:	00000000 	nop
800200a4:	27bd0010 	addiu	sp,sp,16
800200a8:	03e00008 	jr	ra
800200ac:	00000000 	nop

Disassembly of section .reginfo:

800200b0 <.reginfo>:
800200b0:	a000003c 	sb	zero,60(zero)
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
  14:	00000030 	tge	zero,zero
  18:	0000001d 	0x1d
  1c:	0000001f 	0x1f
  20:	8002006c 	lb	v0,108(zero)
	...
  34:	00000010 	mfhi	zero
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
