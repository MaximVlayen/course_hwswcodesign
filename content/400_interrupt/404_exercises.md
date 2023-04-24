---
title: '404 - Exercises'
weight: 404
---

#### Exercise 401

{{% centeredColumn 50 %}}
Try to get the <b>example</b> to work.
{{% /centeredColumn %}}


#### Exercise 402

{{% centeredColumn 50 %}}
Determine how much time it takes for handling a single interrupt.
{{% /centeredColumn %}}

#### Exercise 403

{{% centeredColumn 50 %}}
Start from the example of the counter in [302](http://localhost:1313/hwswcodesign-course/300_soc/302_counter/). Have the peripheral trigger an interrupt when the count reaches **100'000'000**. Given that a clock cycle takes 10 ns. an interrupt should be triggered every (10 ns/CC x 100'000'000 CC) second. Meanwhile the processor is in an endless loop that prints something.
When the interrupt comes, handle it accordingly and reset the counter.
{{% /centeredColumn %}}