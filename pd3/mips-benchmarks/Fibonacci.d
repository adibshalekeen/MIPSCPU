
Fibonacci.elf:     file format elf32-tradbigmips


Disassembly of section .text:

80020000 <main>:
80020000:	27bdffe0 	addiu	sp,sp,-32
80020004:	afbf001c 	sw	ra,28(sp)
80020008:	2404000a 	li	a0,10
8002000c:	0c008009 	jal	80020024 <fib>
80020010:	00000000 	nop
80020014:	8fbf001c 	lw	ra,28(sp)
80020018:	27bd0020 	addiu	sp,sp,32
8002001c:	03e00008 	jr	ra
80020020:	00000000 	nop

80020024 <fib>:
80020024:	27bdffe0 	addiu	sp,sp,-32
80020028:	afbf001c 	sw	ra,28(sp)
8002002c:	afb00018 	sw	s0,24(sp)
80020030:	afa40020 	sw	a0,32(sp)
80020034:	8fa20020 	lw	v0,32(sp)
80020038:	28420002 	slti	v0,v0,2
8002003c:	10400004 	beqz	v0,80020050 <fib+0x2c>
80020040:	00000000 	nop
80020044:	8fa20020 	lw	v0,32(sp)
80020048:	1000000d 	b	80020080 <fib+0x5c>
8002004c:	00000000 	nop
80020050:	8fa20020 	lw	v0,32(sp)
80020054:	2442ffff 	addiu	v0,v0,-1
80020058:	00402025 	move	a0,v0
8002005c:	0c008009 	jal	80020024 <fib>
80020060:	00000000 	nop
80020064:	00408025 	move	s0,v0
80020068:	8fa20020 	lw	v0,32(sp)
8002006c:	2442fffe 	addiu	v0,v0,-2
80020070:	00402025 	move	a0,v0
80020074:	0c008009 	jal	80020024 <fib>
80020078:	00000000 	nop
8002007c:	02021021 	addu	v0,s0,v0
80020080:	8fbf001c 	lw	ra,28(sp)
80020084:	8fb00018 	lw	s0,24(sp)
80020088:	27bd0020 	addiu	sp,sp,32
8002008c:	03e00008 	jr	ra
80020090:	00000000 	nop
	...

Disassembly of section .reginfo:

800200a0 <.reginfo>:
800200a0:	a0010014 	sb	at,20(zero)
	...

Disassembly of section .MIPS.abiflags:

800200b8 <.MIPS.abiflags>:
800200b8:	00002001 	movf	a0,zero,$fcc0
800200bc:	01010001 	movt	zero,t0,$fcc0
	...
800200c8:	00000001 	movf	zero,zero,$fcc0
800200cc:	00000000 	nop

Disassembly of section .pdr:

00000000 <.pdr>:
   0:	80020000 	lb	v0,0(zero)
   4:	80000000 	lb	zero,0(zero)
   8:	fffffffc 	sdc3	$31,-4(ra)
	...
  14:	00000020 	add	zero,zero,zero
  18:	0000001d 	0x1d
  1c:	0000001f 	0x1f
  20:	80020024 	lb	v0,36(zero)
  24:	80010000 	lb	at,0(zero)
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
