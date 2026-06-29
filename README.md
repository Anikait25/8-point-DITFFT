# 8-bit DIT FFT using Finite State Machine (FSM) (Synthesis & Simulation)

## Overview

This project implements an **8-point Radix-2 Decimation-in-Time Fast Fourier Transform (DIT-FFT)** using **Verilog HDL** with a **Finite State Machine (FSM)-based control architecture**. The design is developed for both **functional simulation** and **FPGA synthesis**, where the FFT computation is controlled sequentially through multiple states.

Instead of processing all butterfly operations in parallel, the FSM manages each stage of the FFT, making the design more resource-efficient and suitable for hardware implementation.

---

## Features

* 8-point Radix-2 DIT FFT
* FSM-controlled sequential execution
* Synthesizable Verilog HDL design
* Functional simulation and FPGA synthesis
* Fixed-point arithmetic
* Three-stage butterfly computation
* Twiddle factor lookup table (ROM)
* Resource-efficient architecture

---

## Architecture

```text
                 +----------------------+
                 |     Input Samples    |
                 +----------+-----------+
                            |
                            v
                  +------------------+
                  |   FSM Controller |
                  +--------+---------+
                           |
      +--------------------+--------------------+
      |                    |                    |
      v                    v                    v
 Stage 1             Stage 2             Stage 3
Butterflies         Butterflies         Butterflies
      |                    |                    |
      +--------------------+--------------------+
                           |
                           v
                 Frequency Domain Output
```

The FSM controls the execution of each FFT stage by transitioning through predefined states, ensuring correct sequencing of butterfly operations.

---

## FSM States

The controller progresses through the following states:

| State      | Description                                |
| ---------- | ------------------------------------------ |
| **IDLE**   | Waits for reset completion or start signal |
| **LOAD**   | Loads the 8 input samples                  |
| **STAGE1** | Executes Stage 1 butterfly operations      |
| **STAGE2** | Executes Stage 2 butterfly operations      |
| **STAGE3** | Executes Stage 3 butterfly operations      |
| **OUTPUT** | Stores or outputs the FFT results          |
| **DONE**   | Indicates completion of FFT computation    |

---

## Project Structure

```text
8-bit-DITFFT-FSM/
│
├── rtl/
│   ├── dit_fft_fsm.v
│   ├── butterfly.v
│   ├── complex_multiplier.v
│   ├── twiddle_rom.v
│   ├── controller_fsm.v
│   └── ...
│
├── tb/
│   └── tb_dit_fft_fsm.v
│
├── synthesis/
│   ├── constraints.xdc
│   ├── utilization_report.pdf
│   ├── timing_report.pdf
│   └── rtl_schematic.pdf
│
├── sim/
│   ├── run.do
│   └── waveform.do
│
├── docs/
│   ├── architecture.png
│   ├── fsm_state_diagram.png
│   ├── rtl_schematic.png
│   └── waveform.png
│
└── README.md
```

---

## Tools Used

### Design

* Verilog HDL

### Simulation

* ModelSim / QuestaSim

### Synthesis

* Xilinx Vivado
* Intel Quartus Prime

---

## Running the Simulation

### Compile

```tcl
vlog *.v
```

### Simulate

```tcl
vsim tb_dit_fft_fsm
run -all
```

### View Waveforms

```tcl
add wave *
run -all
```

---

## Synthesis

The design is fully synthesizable.

Typical synthesis flow:

1. Create a new FPGA project.
2. Add all RTL files.
3. Specify the top module.
4. Add FPGA constraints (.xdc).
5. Run:

   * RTL Elaboration
   * Synthesis
   * Implementation
   * Timing Analysis
   * Bitstream Generation (optional)

---

## Inputs

* Clock
* Reset
* Start signal
* Eight 8-bit input samples

---

## Outputs

* FFT Real Output
* FFT Imaginary Output
* Done signal

---

## Verification

The design is verified using:

* Functional simulation
* FSM state transition verification
* Butterfly computation validation
* RTL elaboration
* Synthesis
* Resource utilization analysis
* Timing analysis

---

## Simulation Results

Simulation verifies:

* Correct FSM state transitions
* Sequential execution of FFT stages
* Proper butterfly computations
* Accurate FFT output generation

Typical waveform signals include:

```text
clk
reset
start
current_state
next_state
input_data
stage1_data
stage2_data
stage3_data
fft_real
fft_imag
done
```

---

## Applications

* Digital Signal Processing (DSP)
* Wireless Communication
* OFDM Systems
* Spectrum Analysis
* Audio Processing
* Image Processing

---

## Future Improvements

* Parameterized FFT size (16/32/64-point)
* Pipelined FSM architecture
* Streaming data interface (AXI-Stream)
* Higher-precision arithmetic
* SystemVerilog/UVM-based verification
* ASIC implementation

---

## Author

**Anikait Sarkar**

B.E. Electronics and Communication Engineering

RTL Design | FPGA Design | Digital Design | VLSI

---

## License

This project is intended for educational, research, and learning purposes.
