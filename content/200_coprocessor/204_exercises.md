---
title: '204 - Exercises'
weight: 204
---

#### Exercise 201

{{% centeredColumn 50 %}}
Try to get the example for the Hamming distance to work.
<br/>
<br/>
Make a comparison like the table in 202 where you compare your pure software implementation of the Hamming distance with the codesign.

{{% /centeredColumn %}}

#### Exercise 202

{{% centeredColumn 50 %}}
Transform the Hamming distance coprocessor to work on the <b>div</b> instruction in stead of the mul instruction.
{{% /centeredColumn %}}

#### Exercise 203

{{% centeredColumn 50 %}}
Make a new coprocessor that calculates the average of two integer numbers. If the result is non-integer, round it down. For example avg(32,16) = 24 and avg(3,4) = 3. Try to avoid using the <b>pcpi_wait</b> signal.

Compare a software-only version with a hardware/software codesign of the solution.

{{% /centeredColumn %}}