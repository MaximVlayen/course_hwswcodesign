---
title: '106 - Exercises'
weight: 106
---

Below are a number of programming exercises. The aim is that you **1)** prepare a working setup, and **2)** that you refresh you low-level C programming skills. In the exercises where inputs are required, these **inputs can be hardcoded** as we have no means of inputting data to the processor.

#### Exercise 101
{{% centeredColumn 50 %}}
For this exercise you should simply try to get the examples of this chapter to work.
<ol>
    <li>create a Vivado project</li>
    <li>import the picorv32.v description </li>
    <li>import the testbench and the memory model</li>
    <li>generate the .hex file</li>
    <li>run the simulation</li>
    <li>parse the output</li>
</ol>
As FPGA device, you can pick a <b>ZYNQ XC7Z020-1CLG400C</b>. An even better solution is to pick the <b>PYNQ-Z2 board</b> in case you have the board drivers installed.
{{% /centeredColumn %}}

#### Exercise 102

{{% centeredColumn 50 %}}
For this exercise you will re-organise the memory map. In stead of writing all output to <b>0x10000000</b> to the file, update the design so it writes all output to <b>0x80000000</b> to the file. 
{{% /centeredColumn %}}

#### Exercise 103

{{% centeredColumn 50 %}}
Write a firmware function <b>get_hamming_weight()</b> that can calculate the Hamming weight of a value. 

Print the Hamming weight to the output.
{{< highlight C >}}
unsigned int get_hamming_weight(unsigned int x);
{{< /highlight >}}

Determine how long it takes (in clock cycles) to perform the calculation !!

{{% /centeredColumn %}}

#### Exercise 104

{{% centeredColumn 50 %}}
Write a firmware function <b>get_hamming_distance()</b> that can calculate the Hamming distance between two values.

Print the Hamming distance to the output.
{{< highlight C >}}
unsigned int get_hamming_distance(unsigned int x, unsigned int y);
{{< /highlight >}}

Determine how long it takes (in clock cycles) to perform the calculation !!

{{% /centeredColumn %}}

#### Exercise 105

{{% centeredColumn 50 %}}
Write a firmware function <b>get_factorial()</b> that calculates the factorial of an unsigned integer.

Print the result to the output.
{{< highlight C >}}
unsigned int get_factorial(unsigned int x);
{{< /highlight >}}

Determine how long it takes (in clock cycles) to perform the calculation !!

{{% /centeredColumn %}}

#### Exercise 105

{{% centeredColumn 50 %}}
Write a firmware function <b>convert()</b> that converts Temperature from Fahrenheit to degrees Celsius. The result may be rounded down.

Print the result to the output.
{{< highlight C >}}
unsigned int convert(unsigned int x);
{{< /highlight >}}

Determine how long it takes (in clock cycles) to perform the calculation !!

{{% notice note %}}
(<b>0F</b> − 32) × 5/9 = -17,78&nbsp;<b>°C</b>
{{% /notice %}}

{{% /centeredColumn %}}
