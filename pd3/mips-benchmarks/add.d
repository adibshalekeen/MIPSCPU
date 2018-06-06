
add.elf:     file format elf32-tradbigmips


Disassembly of section .text:

80020000 <main>:
80020000:	27bdffe8 	addiu	sp,sp,-24
80020004:	24020003 	li	v0,3
80020008:	afa20008 	sw	v0,8(sp)
8002000c:	24020002 	li	v0,2
80020010:	afa2000c 	sw	v0,12(sp)
80020014:	afa00010 	sw	zero,16(sp)
80020018:	8fa30008 	lw	v1,8(sp)
8002001c:	8fa2000c 	lw	v0,12(sp)
80020020:	00621021 	addu	v0,v1,v0
80020024:	afa20010 	sw	v0,16(sp)
80020028:	8fa20010 	lw	v0,16(sp)
8002002c:	27bd0018 	addiu	sp,sp,24
80020030:	03e00008 	jr	ra
80020034:	00000000 	nop
	...

Disassembly of section .reginfo:

80020040 <.reginfo>:
80020040:	a000000c 	sb	zero,12(zero)
	...

Disassembly of section .MIPS.abiflags:

80020058 <.MIPS.abiflags>:
80020058:	00002001 	movf	a0,zero,$fcc0
8002005c:	01010001 	movt	zero,t0,$fcc0
	...
80020068:	00000001 	movf	zero,zero,$fcc0
8002006c:	00000000 	nop

Disassembly of section .pdr:

00000000 <.pdr>:
   0:	80020000 	lb	v0,0(zero)
	...
  14:	00000018 	mult	zero,zero
  18:	0000001d 	0x1d
  1c:	0000001f 	0x1f

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
