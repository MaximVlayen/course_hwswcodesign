---
title: '504 Project'
weight: 504
draft: true
---

The project within this course will have you designing an SOC that encodes sensor data to a QOI encoded image. As it would not be realistic to build the entire system, a number of compents will only be simulated: 

* **APB_mem_model**: this is model for the memory containing the instructions and data
* **APB_print_model**: this is model for the SD-card storage. For the sake of simplicity, it is assumed that all writes to **0x8000000** will automatically be handled. This is similar as the print model that was seen earlier.
* **APB_sensor_model**: this model simulates the camera. When an image is taken, it is stored in RAW format. The sensor autonomously stores its data starting from **0x40000008** onwards. On **0x40000000** the sensor writes the width of the image and on **0x40000004** the height is written.

![Example image](/img/500/project.png)

## Goals

This project is to be achieved in two steps: 

1. a software-only version, and 
0. a HW/SW codesign.

This first version (SW-only) will set the playing level. Additionally, this will help you in understanding the encoding scheme. The result of the first version will be a working implementation. This will allow you to *run the numbers* (latency, resource usage, throughput, ...).

When the first version is done, you choose which optimisations you're going to make. After these optimisations are approved, you'll set of to make the HW/SW codesign. You can use which ever technique you think is best for obtaining your optimisations.

Below you can find a number of resources that might come in handy.

### Resources

{{% multiHcolumn %}}
{{% column %}}&nbsp;{{% /column %}}
{{% column %}}
* [Link to the QOI specification](https://qoiformat.org/qoi-specification.pdf)
* [Example image, in 'sensor-data-format'](/src/project/data/example_image.dat)
{{% /column %}}
{{% column %}}&nbsp;{{% /column %}}
{{% /multiHcolumn %}}