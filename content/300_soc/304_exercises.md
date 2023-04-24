---
title: '304 - Exercises'
weight: 304
---

#### Exercise 301

{{% centeredColumn 50 %}}
Try to get the example for the counter-enforced SoC to work.
{{% /centeredColumn %}}

#### Exercise 302

{{% centeredColumn 50 %}}
Make a <b>new</b> (as in: don't modify the dummy) component that can calculated the Hamming distance of two values.
<br/>
<br/>
Make a comparison like the table in 202 where you compare your pure software implementation of the Hamming distance with the codesign.
{{% /centeredColumn %}}

#### Exercise 303

{{% centeredColumn 50 %}}
Make a new component that calculates the sine of a positive angle. The angle is provided as natural number (no decimals), in degrees and can be up to 10 bits.
<br/>
<br/>
<b>To prevent decimal numbers</b>, the resulting value should be multiplied with 1'000'000. The remaining decimal digits can be dropped. Hence the result should fit in 20 bits.
<br/>
<br/>
<b>Negative numbers</b> should be represented in <a href="https://en.wikipedia.org/wiki/Two%27s_complement" target="_blank">two's complement</a>.

<br/><br/>Some examples:
<img src="/img/300/sinetable.png"/>

<center><b>PROTIP:</b> work <u>smart</u>, not <u>hard</u> !!</center>

{{% /centeredColumn %}}