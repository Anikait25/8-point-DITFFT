# 8-bit DIT FFT (Synthesis & Simulation)

## Overview

This project presents an **8-point Radix-2 Decimation-in-Time Fast Fourier Transform (DIT-FFT)** implemented in **Verilog HDL**. The design has been developed for both **functional simulation** and **FPGA synthesis**, demonstrating a hardware-efficient implementation of the FFT algorithm using fixed-point arithmetic.

The project verifies the functionality through simulation and validates hardware compatibility through synthesis reports.

---

## Features

* 8-point Radix-2 DIT FFT
* Synthesizable Verilog HDL design
* Functional simulation
* FPGA-compatible architecture
* Fixed-point arithmetic implementation
* Butterfly-based processing stages
* Twiddle factor ROM
* RTL synthesis and resource utilization analysis

---

## FFT Architecture

```text
          8 Input Samples
                 │
                 ▼
      Stage 1 Butterfly Units
                 │
                 ▼
      Stage 2 Butterfly Units
                 │
                 ▼
      Stage 3 Butterfly Units
                 │
                 ▼
        FFT Frequency Output
```

The FFT computation is performed in three butterfly stages, where each stage combines data using predefined twiddle factors.

---

## Project Structure

```text
8-bit-DITFFT/
│
├── rtl/
│   ├── dit_fft.v
│   ├── butterfly.v
│   ├── complex_multiplier.v
│   ├── twiddle_rom.v
│   └── ...
│
├── tb/
│   └── tb_dit_fft.v
│
├── synthesis/
│   ├── constraints.xdc
│   ├── synthesis_report.pdf
│   └── utilization_report.pdf
│
├── sim/
│   ├── run.do
│   └── waveform.do
│
├── docs/
│   ├── architecture.png
│   ├── rtl_schematic.png
│   └── waveform.png
│
└── README.md
```

---

## Development Tools

### Design & Simulation

* ModelSim / QuestaSim

### Synthesis

* Xilinx Vivado
* Intel Quartus Prime (with minor modifications if required)

---

## Running the Simulation

### Compile

```tcl
vlog *.v
```

### Simulate

```tcl
vsim tb_dit_fft
run -all
```

### Display Waveforms

```tcl
add wave *
run -all
```

---

## Synthesis

The design is fully synthesizable and can be targeted to FPGA devices.

Typical synthesis flow:

1. Create a new FPGA project.
2. Add all RTL source files.
3. Set the top-level module.
4. Add the constraint (.xdc) file.
5. Run:

   * RTL Elaboration
   * Synthesis
   * Implementation
   * Bitstream Generation (optional)

---

## Inputs

* Clock
* Reset
* Eight input samples (8-bit fixed-point)

---

## Outputs

* FFT Real Output
* FFT Imaginary Output

The outputs represent the frequency-domain components corresponding to the input sequence.

---

## Verification

The design has been verified through:

* Functional simulation
* Waveform analysis
* RTL elaboration
* Synthesis without errors
* Resource utilization reports
* Timing analysis

---

## Synthesis Results

The synthesis process generates:

* RTL schematic
* Technology schematic
* Resource utilization report
* Timing report
* Critical path analysis

Typical resources include:

* Lookup Tables (LUTs)
* Flip-Flops (FFs)
* DSP Blocks (if complex multiplication is mapped to DSPs)
* I/O Pins
* Clock resources

---

## Simulation Results

Simulation validates:

* Correct butterfly operations
* Stage-by-stage FFT computation
* Real and imaginary output generation
* Proper reset and clock behavior

Example waveform signals:

```text
clk
reset
input_sample[7:0]
stage1_data
stage2_data
stage3_data
fft_real
fft_imag
```

---

## Applications

* Digital Signal Processing (DSP)
* OFDM Transceivers
* Wireless Communication
* Audio Processing
* Image Processing
* Radar Signal Processing
* Spectrum Analysis

---

## Future Improvements

* 16-point, 32-point, and 64-point FFT support
* Pipelined FFT architecture
* Runtime-configurable FFT size
* Floating-point implementation
* High-speed streaming interface (AXI-Stream)
* SystemVerilog/UVM-based verification
* ASIC synthesis support

---

## Author

**Anikait Sarkar**

B.E. Electronics and Communication Engineering

RTL Design | FPGA Design | Digital Design | VLSI

---

## License

This project is intended for educational, research, and learning purposes.
