# NanoRISCV-C2
**Ultra-Compact 2-Stage RISC-V Core for Embedded Control**

## Overview
NanoRISCV-C2 is a custom, hardware-efficient 2-stage pipelined processor core implementing a subset of the RISC-V (RV32I) instruction set architecture. Designed specifically for embedded and IoT control products (like sensor nodes and edge controllers), this core minimizes pipeline depth, forwarding paths, and hazard logic to drastically reduce silicon area and power consumption.

## Core Specifications
* **Architecture:** 32-bit RISC-V (RV32I Subset)
* **Pipeline Depth:** 2 Stages
  * **Stage 1 (IF):** Instruction Fetch (Program Counter, PC Adder, Instruction Memory)
  * **Stage 2 (EX/MEM/WB):** Decode, Execute, Data Memory Access, and Register Writeback
* **Hazard Handling:** Zero-forwarding design. Control hazards (taken branches and JAL) are resolved in Stage 2, triggering a 1-cycle synchronous pipeline flush (inserts a `NOP: 0x00000013` into the IF/EX register).
* **Instruction Memory:** 128 x 32-bit (512 Bytes), word-aligned asynchronous read.
* **Data Memory:** 256 x 32-bit (1 KB), byte-addressed, synchronous write / asynchronous read.
* **Register File:** 32 x 32-bit general-purpose registers (dual asynchronous read, synchronous write). Register `x0` is hardwired to zero.

## Supported Instruction Set (RV32I Subset)
| Format | Instructions | Functionality |
| :--- | :--- | :--- |
| **R-Type** | `ADD`, `SUB`, `AND`, `OR`, `XOR`, `SLL`, `SRL` | Standard arithmetic and logical operations |
| **I-Type** | `ADDI`, `LW` | Immediate arithmetic and Word load from memory |
| **S-Type** | `SW` | Word store to memory |
| **B-Type** | `BEQ` | Branch if equal |
| **U-Type** | `LUI` | Load upper immediate |
| **J-Type** | `JAL` | Jump and link |

## FPGA Implementation Results
Synthesized and implemented using **Xilinx Vivado 2025.2** for the **AMD Xilinx Kintex-7 (`xc7k70tfbv676-1`)** target.

* **Target Clock:** 50 MHz (20 ns period)
* **Max Estimated Clock:** ~60.6 MHz (Worst Negative Slack: 3.510 ns)
* **Worst Hold Slack:** +0.063 ns

**Resource Utilization:**
* **Slice LUTs:** 429 / 41,000 (1.05%)
* **LUTRAM (Distributed RAM):** 172 / 13,400 (1.28%)
* **Slice Registers (FFs):** 33 / 82,000 (0.04%)
* **I/O Pins:** 34 / 300 (11.33%)
* **DSP / Block RAM:** 0 (Highly logic-efficient)

**Power Consumption:**
* **Total On-Chip Power:** 0.084 W
* **Dynamic Power:** 0.002 W
* **Device Static Power:** 0.081 W

## CPI & Performance Analysis
The core's efficiency was validated against a 5,000-instruction trace dataset targeting a typical embedded workload mix (41.7% ALU, 25.2% Load/Store, 19% Branch, 14% Jump). 

* **Mean Cycles Per Instruction (CPI):** 1.372
* **Single-Cycle Execution:** 68.5% of instructions execute in exactly 1 cycle.
* **Branch Penalty:** A taken `BEQ` or `JAL` costs 1 extra flush cycle. Analysis shows taken branches average 2.01 cycles, while untaken branches execute in 1.15 cycles.

## Repository Structure
* **`/Architecture`**: Data flow diagrams and internal pipeline block diagrams.
* **`/Design Modules`**: Verilog RTL source codes for all components (ALU, Control Unit, Pipeline Registers, Register File, etc.) and the top-level integration module.
* **`/Schematics`**: RTL and synthesized schematic exports from Vivado.
* **`/Testbenches and simulations`**: Verilog testbenches for individual module verification and the top-level integration test, along with waveform screenshots.
* **`/constraits`**: Xilinx Design Constraints (`.xdc`) files including the 50 MHz clock definition.
* **`/reports`**: Post-implementation Vivado reports (Utilization, Timing, and Power).
* **`NanoRISC-V C2.xpr`**: The main Xilinx Vivado project file.

## Getting Started
1. Clone this repository to your local machine.
2. Open **Xilinx Vivado** (built on 2025.2).
3. Select **Open Project** and navigate to the `NanoRISC-V C2.xpr` file.
4. Run Behavioral Simulation on `tb_NanoRISCV_C2.v` to observe the pipeline execution, memory writes, and branch flushing on the waveform viewer.
