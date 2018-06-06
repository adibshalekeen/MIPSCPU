
SumArray.elf:     file format elf32-tradbigmips


Disassembly of section .text:

80020000 <main>:
80020000:	27bdffc8 	addiu	sp,sp,-56
80020004:	afa00008 	sw	zero,8(sp)
80020008:	afa0000c 	sw	zero,12(sp)
8002000c:	afa00008 	sw	zero,8(sp)
80020010:	1000000a 	b	8002003c <main+0x3c>
80020014:	00000000 	nop
80020018:	8fa20008 	lw	v0,8(sp)
8002001c:	00021080 	sll	v0,v0,0x2
80020020:	27a30008 	addiu	v1,sp,8
80020024:	00621021 	addu	v0,v1,v0
80020028:	8fa30008 	lw	v1,8(sp)
8002002c:	ac430008 	sw	v1,8(v0)
80020030:	8fa20008 	lw	v0,8(sp)
80020034:	24420001 	addiu	v0,v0,1
80020038:	afa20008 	sw	v0,8(sp)
8002003c:	8fa20008 	lw	v0,8(sp)
80020040:	2842000a 	slti	v0,v0,10
80020044:	1440fff4 	bnez	v0,80020018 <main+0x18>
80020048:	00000000 	nop
8002004c:	afa00008 	sw	zero,8(sp)
80020050:	1000000c 	b	80020084 <main+0x84>
80020054:	00000000 	nop
80020058:	8fa20008 	lw	v0,8(sp)
8002005c:	00021080 	sll	v0,v0,0x2
80020060:	27a30008 	addiu	v1,sp,8
80020064:	00621021 	addu	v0,v1,v0
80020068:	8c420008 	lw	v0,8(v0)
8002006c:	8fa3000c 	lw	v1,12(sp)
80020070:	00621021 	addu	v0,v1,v0
80020074:	afa2000c 	sw	v0,12(sp)
80020078:	8fa20008 	lw	v0,8(sp)
8002007c:	24420001 	addiu	v0,v0,1
80020080:	afa20008 	sw	v0,8(sp)
80020084:	8fa20008 	lw	v0,8(sp)
80020088:	2842000a 	slti	v0,v0,10
8002008c:	1440fff2 	bnez	v0,80020058 <main+0x58>
80020090:	00000000 	nop
80020094:	8fa2000c 	lw	v0,12(sp)
80020098:	27bd0038 	addiu	sp,sp,56
8002009c:	03e00008 	jr	ra
800200a0:	00000000 	nop
	...

Disassembly of section .reginfo:

800200b0 <.reginfo>:
800200b0:	a000000c 	sb	zero,12(zero)
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
	...
  14:	00000038 	0x38
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
