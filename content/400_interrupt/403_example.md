---
title: '403 - Example'
weight: 403
---

This page gives a hands-on example of using interrupts with the PicoRV32.

## HARDWARE

### RISC-V instantiation 

{{% multiHcolumn %}}
{{% column %}}

At the instantiation, the following additional mappings need to be made:

* ENABLE_IRQ ... to '1'
* ENABLE_IRQ_QREGS ... to '1'
* ENABLE_IRQ_TIMER ... to '1'
* MASKED_IRQ ... to x"00000000"
* LATCHED_IRQ ... to x"FFFFFFFF"
* PROGADDR_RESET ... to x"00000000"
* PROGADDR_IRQ ... to x"00000010"

These settings: 

* enable the IRQ
* ensures the IRQs are **not masked-out**
* set the reset vector
* set the IRQ handler

Interrupts can be given through signal **irq**, and the ack's come at the **eoi** signal.

{{% /column %}}
{{% column %}}
![example](/img/400/screenshot_example_1.png)
{{% /column %}}
{{% /multiHcolumn %}}


## SOFTWARE

### PicoRV32 custom instructions

The PicoRV32 has a handful of custom instructions. To make the assembly-code (a bit) more readable some custom instructions and register-names have been defined. These can be found in **custom_ops.S** from the [PicoRV32 Github repository](https://github.com/YosysHQ/picorv32/blob/master/firmware/custom_ops.S).

* **picorv32_getq_insn()**: copy q-register to gp-register
* **picorv32_setq_insn()**: copy gp-register to q-register
* **picorv32_retirq_insn()**: return from interrupt and re-enable interrupts
* **picorv32_maskirq_insn()**: write a new value to the irq mask register and reads the old value (The "IRQ Mask" register contains a bitmask of masked (disabled) interrupts).
* **picorv32_waitirq_insn()**: pause execution until an interrupt becomes pending
* **picorv32_timer_insn()**: reset the timer counter to a new value.

{{% notice note %}}
More info [here](https://github.com/YosysHQ/picorv32#custom-instructions-for-irq-handling).
{{% /notice %}}

### Reset vector

The **start.S** assembly file that has been used up until now, needs to be extended.

{{% multiHcolumn %}}
{{% column %}}
{{< highlight c >}}
reset_vec:
	// no more than 16 bytes here !
    // enable all interrupts
	picorv32_maskirq_insn(zero, zero)
    // jump to start function
	j start
{{< /highlight >}}
{{% /column %}}
{{% column %}}

* The reset vector can not contain more than 16 instructions. Otherwise, exceeding the 0x10 offset of the **PROGADDR_IRQ**, will overwrite the IRQ vector.
* All the interrupts are enabled (by setting their **mask-value** to zero).
* A jump to <span style="background-color: #DAE8FC; color: #6C8EBF">&nbsp;start&nbsp;</span> is made.
{{% /column %}}

{{% /multiHcolumn %}}

### Interrupt handler

The **start.S** assembly file that has been used up until now, needs to be extended some more.


{{% multiHcolumn %}}
{{% column %}}
{{< highlight c >}}
.balign 16
irq_vec:
	/* save registers, by copying through x1 and x2 */
	picorv32_setq_insn(q2, x1)
	picorv32_setq_insn(q3, x2)

	lui x1, %hi(irq_regs)
	addi x1, x1, %lo(irq_regs)

	picorv32_getq_insn(x2, q0)
	sw x2,   0*4(x1)

	picorv32_getq_insn(x2, q2)
	sw x2,   1*4(x1)

	picorv32_getq_insn(x2, q3)
	sw x2,   2*4(x1)

	sw x3,   3*4(x1)
	sw x4,   4*4(x1)
	sw x5,   5*4(x1)
	sw x6,   6*4(x1)
	sw x7,   7*4(x1)
	sw x8,   8*4(x1)
	sw x9,   9*4(x1)
	sw x10, 10*4(x1)
	sw x11, 11*4(x1)
	sw x12, 12*4(x1)
	sw x13, 13*4(x1)
	sw x14, 14*4(x1)
	sw x15, 15*4(x1)
	sw x16, 16*4(x1)
	sw x17, 17*4(x1)
	sw x18, 18*4(x1)
	sw x19, 19*4(x1)
	sw x20, 20*4(x1)
	sw x21, 21*4(x1)
	sw x22, 22*4(x1)
	sw x23, 23*4(x1)
	sw x24, 24*4(x1)
	sw x25, 25*4(x1)
	sw x26, 26*4(x1)
	sw x27, 27*4(x1)
	sw x28, 28*4(x1)
	sw x29, 29*4(x1)
	sw x30, 30*4(x1)
	sw x31, 31*4(x1)

	/* call interrupt handler C function */
	lui sp, %hi(irq_stack)
	addi sp, sp, %lo(irq_stack)

	/* arg0 = address of regs */
	lui a0, %hi(irq_regs)
	addi a0, a0, %lo(irq_regs)

	/* arg1 = interrupt type */
	picorv32_getq_insn(a1, q1)

	/* call to C function */
	jal ra, irq


	/* restore registers */
	/* new irq_regs address returned from C code in a0 */
	addi x1, a0, 0

	lw x2,   0*4(x1)
	picorv32_setq_insn(q0, x2)

	lw x2,   1*4(x1)
	picorv32_setq_insn(q1, x2)

	lw x2,   2*4(x1)
	picorv32_setq_insn(q2, x2)

	lw x3,   3*4(x1)
	lw x4,   4*4(x1)
	lw x5,   5*4(x1)
	lw x6,   6*4(x1)
	lw x7,   7*4(x1)
	lw x8,   8*4(x1)
	lw x9,   9*4(x1)
	lw x10, 10*4(x1)
	lw x11, 11*4(x1)
	lw x12, 12*4(x1)
	lw x13, 13*4(x1)
	lw x14, 14*4(x1)
	lw x15, 15*4(x1)
	lw x16, 16*4(x1)
	lw x17, 17*4(x1)
	lw x18, 18*4(x1)
	lw x19, 19*4(x1)
	lw x20, 20*4(x1)
	lw x21, 21*4(x1)
	lw x22, 22*4(x1)
	lw x23, 23*4(x1)
	lw x24, 24*4(x1)
	lw x25, 25*4(x1)
	lw x26, 26*4(x1)
	lw x27, 27*4(x1)
	lw x28, 28*4(x1)
	lw x29, 29*4(x1)
	lw x30, 30*4(x1)
	lw x31, 31*4(x1)

	picorv32_getq_insn(x1, q1)
	picorv32_getq_insn(x2, q2)
	picorv32_retirq_insn()
{{< /highlight >}}
{{% /column %}}
{{% column %}}

As a reminder: 

* register **x0** contains a hard-wired value of 0x00000000
* register **x1** contains the return address
* register **x2** contains the stack pointer (sp)
* register **x3** is for general purpose (gp)
* register **x4** contains the thread pointer (tp)

<hr/>

First of all, it has to be made sure that the interrupt handler starts at address 0x00000010. This can be done with ```.balign 16```.

Next, the copying of the *state* has to be done. All the copies need to be made to the <span style="background-color: #FFF2CC; color: #D6B656">&nbsp;interrupt registers&nbsp;</span>. This happens in these steps:

* backup of registers **x1** and **x2**
  * backup registers **x1** and **x2** to q2 and q3
  * load the address of <span style="background-color: #FFF2CC; color: #D6B656">&nbsp;interrupt registers&nbsp;</span> in **x1**
  * copy registers **q0**, **q2** and **q3** to <span style="background-color: #FFF2CC; color: #D6B656">&nbsp;interrupt registers&nbsp;</span> by using **relative addressing** (offsets against the value that is stored in **x1**), through **x2**
* backup of registers **x3** .. **x31**
  * copy the registers to <span style="background-color: #FFF2CC; color: #D6B656">&nbsp;interrupt registers&nbsp;</span> by using **relative addressing** (offsets against the value that is stored in **x1**), through **x2**

When everything is safely backed up, it's time to call the actual instructions for handling the interrupt. This is a **C-function**: 

{{< highlight c >}}
uint32_t *irq(uint32_t *regs, uint32_t irqs)
{{< /highlight >}}

Before a **call** to this function can be made, the **stack pointer (sp)** is changed to use the <span style="background-color: #D5E8D4; color: #82B366">&nbsp;interrupt stack&nbsp;</span>.

The two arguments that are passed to the **irq** function need to be stored in **a0** and **a1**. These arguments are set, prior to performing the jump-and-link to the actual function.

The *restore* of the *state* is done in a similar fashion as the backup. When everything is tidied up, the 'return-from-interrupt' function is called: **picorv32_retirq_insn()**.

{{% /column %}}
{{% /multiHcolumn %}}

The actual C-code for the interrupt handler can be downloaded from the PicoRV32 Github repository ([irq.c](https://github.com/YosysHQ/picorv32/blob/master/firmware/irq.c)).


{{% multiHcolumn %}}
{{% column %}}
### Interrupt registers
{{< highlight c >}}
irq_regs:
	// registers are saved to this memory region during interrupt handling
	// the program counter is saved as register 0
	.fill 32,4
{{< /highlight >}}
{{% /column %}}
{{% column %}}
### Interrupt stack
{{< highlight c >}}
	// stack for the interrupt handler
	.fill 128,4
irq_stack:
{{< /highlight >}}
{{% /column %}}
{{% /multiHcolumn %}}

## Simulation

With these modifications to hardware and software, the simulation should be able to show the working, interrupt-able processor.