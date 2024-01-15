---
title: '503 ASCON project'
weight: 503
draft: true
---

As it is an official holiday, there is no lesson on **May first**. However it will be the deadline for the first part of the project. 

The first part is a pure software implementation of ASCON hash. The functionality should be triggered upon this function:

{{< highlight c >}}
void ascon_hash(uint32_t * digest, uint32_t * message, uint8_t mlen);
{{< /highlight >}}

* The maximum value for length is 255. This means that the input can be 255 x 32 bits = 8160 bits which is 1020 bytes.
* All parameters (rate, capacity, ...) are the default numbers.

{{% notice note %}}
For this first part the **C-code** has to be uploaded to toledo, together with your self-defined **optimalisation** targets (in a simple text file).
{{% /notice %}}

The second part is a hardware/software co-design of ASCON hash. You can choose your own optimalisation-targets (smaller area, smaller binary size, bigger throughput, ...) and you have *unlimited budget* (with respect to resources). 

* 
