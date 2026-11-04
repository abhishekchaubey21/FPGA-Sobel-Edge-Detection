
# FPGA-Based Sobel Edge Detection Using Verilog HDL

## Overview

This project implements a hardware-based image processing system using **Verilog HDL** and FPGA-oriented architecture to perform Sobel Edge Detection on grayscale images.

The design processes image pixels using a streaming architecture, generates 3×3 pixel neighborhoods through line buffers, and applies horizontal and vertical Sobel convolution masks to identify edges.

The processed image is converted into a binary edge map, highlighting object boundaries and image structures.

## Key Features

- Hardware implementation of Sobel Edge Detection using Verilog HDL.
- 3×3 convolution-based image processing.
- Four-buffer architecture for pixel storage and neighborhood generation.
- Parallel computation of horizontal and vertical gradients (Gx and Gy).
- Gradient magnitude-based thresholding.
- AXI-Stream FIFO integration for output data buffering.
- Parameterized image width and pixel addressing.
- Testbench-based simulation with BMP image input and output.

## Architecture

The system consists of the following major modules:

1. **Top Image Processing Module (`top_imagep.v`)**
   - Integrates all processing blocks.
   - Manages input and output pixel streams.
   - Interfaces with the AXI-Stream FIFO.

2. **Control Block (`control_block.v`)**
   - Controls pixel buffering and read/write operations.
   - Generates 3×3 pixel neighborhoods.
   - Manages buffer switching and row synchronization.

3. **Data Buffer (`data_buffer.v`)**
   - Stores image pixel data.
   - Maintains read and write pointers.
   - Supplies neighboring pixels for convolution.

4. **Sobel Processing Engine (`mult_acm_sobel.v`)**
   - Applies horizontal and vertical Sobel operators.
   - Computes gradient components Gx and Gy.
   - Performs gradient-based thresholding.
   - Generates binary edge-detected pixels.

5. **Image Processing Testbench (`im_tb.v`)**
   - Reads the input BMP image.
   - Feeds pixel data into the processing module.
   - Captures processed pixel output.
   - Generates the output BMP image.

## Sobel Edge Detection

The design uses two 3×3 Sobel convolution kernels:

**Horizontal Gradient (Gx)**

```text
 1   0  -1
 2   0  -2
 1   0  -1
```

**Vertical Gradient (Gy)**

```text
 1   2   1
 0   0   0
-1  -2  -1
```

The gradient magnitude is calculated using:

\[
G = \sqrt{G_x^2 + G_y^2}
\]

The hardware implementation avoids the square-root operation and uses squared gradient thresholding:

\[
G_x^2 + G_y^2 > 4000
\]

Pixels satisfying the threshold are assigned white (`255`), while the remaining pixels are assigned black (`0`).

## Technology Stack

| Component | Technology |
|---|---|
| Hardware Description | Verilog HDL |
| Development Environment | Xilinx Vivado |
| Processing Architecture | FPGA-based Digital Logic |
| Image Format | BMP |
| Data Interface | AXI-Stream |
| Simulation | Verilog Testbench |

## Project Structure

```text
FPGA-Sobel-Edge-Detection/
│
├── control_block.v
├── data_buffer.v
├── im_tb.v
├── mult_acm_sobel.v
├── top_imagep.v
│
├── input_image.bmp
├── output_image.bmp
│
└── README.md
```

## Simulation

The project can be simulated using Xilinx Vivado.

### Steps

1. Create a new RTL project in Vivado.
2. Add all Verilog design files.
3. Add the image processing testbench.
4. Add or regenerate the required `fifo_generator_0` IP core with an 8-bit AXI-Stream data interface.
5. Update the input and output BMP file paths in the testbench.
6. Run behavioral simulation.
7. Observe the processed pixel stream and generated output BMP image.

**Note:** The testbench currently uses Windows-specific file paths. Update them according to your local system before simulation.

## Applications

- Real-time image processing.
- Computer vision systems.
- FPGA-based image enhancement.
- Object boundary detection.
- Industrial image inspection.
- Preprocessing for hardware-based machine vision systems.

## Future Improvements

- Implement configurable edge detection thresholds.
- Optimize resource utilization and processing latency.
- Support different image resolutions.
- Integrate a live camera input.
- Implement hardware acceleration for additional image processing algorithms.
- Deploy and test the design on an FPGA development board.

## Author

**Abhishek
