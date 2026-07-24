# Simple MBIST (Memory Built-In Self-Test) Controller

A simple **Memory Built-In Self-Test (MBIST)** controller implemented in **Verilog HDL** to demonstrate the fundamental concepts of **Design for Testability (DFT)**. This project models an MBIST architecture capable of automatically writing, reading, and verifying data stored in an SRAM using a finite state machine (FSM).

The project is intended for educational purposes to help understand the internal operation of MBIST before using commercial DFT tools.

---

# Project Overview

This project consists of:

* A 16×8-bit SRAM behavioral model
* A 4-state MBIST finite state machine
* A data checker for memory verification
* Fault injection support
* A simulation testbench
* Waveform verification using GTKWave

---

# Features

* 4-State FSM-based MBIST Controller
* 16×8 SRAM Behavioral Model
* Automatic Address Generation
* Fixed Test Pattern Generator (`8'hAA`)
* Read & Compare Checker
* PASS / FAIL Status Reporting
* Fault Injection Support
* Simulation Testbench

---

# System Architecture

The MBIST system consists of four main components:

* **MBIST Controller** – Generates memory addresses and controls the test sequence.
* **SRAM** – A 16×8-bit memory under test.
* **Checker** – Compares the read data with the expected test pattern.
* **Fault Injection Logic** – Simulates memory faults for verification.

---

# FSM Description

The MBIST controller operates through four sequential states.

| State | Name              | Description                                                                                                                                                                         |
| :---: | ----------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **0** | **IDLE**          | Initial idle state. All control signals are cleared (`we = 0`, `done = 0`, `fail = 0`), and the address counter is reset to zero. The controller waits until `test_en` is asserted. |
| **1** | **WRITE_PATTERN** | The controller writes the fixed test pattern (`8'hAA`) into every SRAM location. The write enable signal is asserted while the address counter increments from 0 to 15.             |
| **2** | **READ_COMPARE**  | The controller reads each memory location and compares the returned data with the expected pattern (`8'hAA`). If any mismatch is detected, the `fail` flag is permanently asserted. |
| **3** | **DONE**          | The memory test is completed. The `done` signal is asserted, and the final PASS/FAIL result remains available until `test_en` is deasserted, returning the FSM to the IDLE state.   |

---

# Test Pattern

The MBIST uses a fixed test pattern:

```verilog
8'hAA
```

Binary representation:

```text
10101010
```

This pattern is sufficient for demonstrating the basic write/read/compare operation and detecting simple memory faults.

---

# Expected Simulation Results

The waveform should demonstrate:

* FSM transitions:

  * IDLE
  * WRITE_PATTERN
  * READ_COMPARE
  * DONE
* Address counter increments from **0 to 15**
* SRAM receives the test pattern `8'hAA`
* Memory contents are read back correctly
* `done` is asserted after the test completes
* `fail` remains **0** during normal operation

---

# Fault Injection

The testbench supports fault injection using:

```verilog
fault[1:0]
```

Example fault modes:

| Fault | Description      |
| :---: | ---------------- |
|   00  | Normal operation |
|   01  | Bit flip         |
|   10  | Stuck-at-0       |
|   11  | Stuck-at-1       |

Whenever the read data differs from the expected pattern, the controller asserts:

```verilog
fail <= 1'b1;
```

---

# Verification Results

## Test Case 1 — Normal Operation

* Test pattern successfully written
* Read data matches expected value
* `fail = 0`
* `done = 1`

**Result:** PASS

---

## Test Case 2 — Fault Injection

* Memory fault injected
* Data mismatch detected
* `fail = 1`
* `done = 1`

**Result:** FAIL (Expected)

