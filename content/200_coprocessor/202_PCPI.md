---
title: '202 - Pico CoProcessor Interface (PCPI)'
weight: 202
---

In Chapter 1 we've used the PicoRV32 implementation of a RISC-V. This implementation has a number of interfaces to the outside world. The memory interface was already discussed. In this section the Pico CoProcessor Interface (PCPI) is handled.

## Multiplication coprocessor

To illustrate (the use of) a coprocessor, let's take the multiplication. In the previous section it is illustrated how the compiler jumped in to achieve multiplication. Depending on the factors, this might take a lot time. 

The **PicoRV32** comes with an example multiplier in hardware. The design is shown in the image below.

{{% multiHcolumn %}}
{{% column %}}
![hwdesign_mul](/img/200/pcpi_mul.png)

{{% /column %}}
{{% column %}}
By now, most of the signals of the PCPI interface should make sense. 
### Control path

* **pcpi_valid**: a single bit signal that indicates the instruction is valid;
* **pcpi_insn**: a 32-bit instruction. This instruction is fetched by the PicoRV32 and handed over to the coprocessor (if needed);
* **pcpi_ready**: a single bit signal that indicates the coprocessor is done;
* **pcpi_wait**: a single bit signal that indicates the coprocessor needs more time;
* **pcpi_wr**: a single bit write enable signal to the PicoRV32.

### Data path

* **pcpi_rs1**: a 32-bit bus containing the first factor;
* **pcpi_rs2**: a 32-bit bus containing the second factor;
* **pcpi_rd**: a 32-bit bus containing the product;

{{% /column %}}
{{% /multiHcolumn %}}

Consulting the [readme](https://github.com/YosysHQ/picorv32#pico-co-processor-interface-pcpi) file of the PicoRV32 learns: 

* the instruction that is implemented through the coprocessor should be **non-branching**;
* the **pcpi_valid** signal only goes on for *unsupported* instructions;
* the **pcpi_insn**, **pcpi_rs1** and **pcpi_rs2** fields are parsed by the PicoRV32;
* the PicoRV32 core can optionally decode the **pcpi_rd** field of the instruction and write the value from pcpi_rd to the respective register.
* <i>When no external PCPI core acknowledges the instruction within 16 clock cycles, then an illegal instruction exception is raised and the respective interrupt handler is called. **A PCPI core that needs more than a couple of cycles to execute an instruction, should assert pcpi_wait as soon as the instruction has been decoded successfully** and keep it asserted until it asserts pcpi_ready. This will prevent the PicoRV32 core from raising an illegal instruction exception</i>

If all of the above *rules* are obeyed (which they are in the example), the PicoRV32 can offload all the **mul** instructions to the coprocessor. This option should be enabled in the PicoRV32 through the *parameters*: **ENABLE_PCPI** and **ENABLE_MUL**.

{{< highlight vhdl >}}
    picorv32_inst00: component picorv32
        generic map(
			...
			ENABLE_PCPI => '1',
			ENABLE_MUL => '1',
			...
{{< /highlight >}}

## Balance

Running the code above, with the coprocessor present, gives the same result as the software-only variant. <b><i>Lucky us !!</i></b> :smiley:

Why should you go for one of both then ? That's an important question and/or decision. To have some arguments in calling the shots, numbers can come in handy.

|                               | software only | hardware + software |
|-------------------------------|--------------:|--------------------:|
| **filesize of .elf file** (bytes) | 5'460          | <span style="background-color: green; color: white; padding: 0px 50px">5'068</style>  |
| **duration of program** (CC)      | 467           | <span style="background-color: green; color: white; padding: 0px 50px">404</style>  |
| **required LUTs**                 | <span style="background-color: green; color: white; padding: 0px 50px">897</style>           | 1'205 |
| **required registers**            | <span style="background-color: green; color: white; padding: 0px 50px">574</style>           | 868  |

{{% centeredColumn 50 %}}
<ul>
<li>the software-only version needs more instruction memory. This makes sense as some additional, custom functions are generated to realise the multiplication.</li>
<li>the version with the coprocessor finishes the job quicker.</li>
<li>the software-only version requires less configurable resources (on FPGA)</li>
</ul>
{{% /centeredColumn %}}

With these arguments, better-informed decisions can be made.

* If the available instruction memory is of the utmost importance, some hardware offloading might be useful.
* For applications where the cost is the most important feature, having fewer hardware coprocessors might be interesting.