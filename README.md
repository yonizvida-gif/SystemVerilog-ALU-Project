# SystemVerilog ALU-Memory Verification Project

## 📌 Overview
This repository contains a comprehensive, **Object-Oriented Programming (OOP)** based SystemVerilog Verification Environment for an ALU-Memory Subsystem. The project demonstrates advanced Pre-Silicon verification methodologies, including **Constrained Random Verification (CRV)**, **Assertion-Based Verification (ABV)**, and **Functional Coverage** analysis to ensure hardware integrity.

---

## 🛠️ Design Under Test (DUT)
The `alu_mem` module integrates an ALU and a Register Bank.
* **ALU:** Arithmetic operations (ADD, SUB, MUL, DIV).
* **Memory Unit:** Operands (A, B), Opcode, and Execution trigger.
* **Interface:** Modular `alu_mem_if` with modports and clocking blocks.

![System Specification](image/ALU_Memory_Spec.png)

*Figure: Technical specification of the ALU-Memory Subsystem.*

---

## 🏗️ Verification Environment Architecture
The environment follows a layered, modular architecture:
* **Generator:** Randomized transactions with constraints (e.g., div_zero_tran).
* **Driver:** Stimulus injection into the virtual interface.
* **Monitors:** Independent `monitor_in` and `monitor_out` for precise tracking.
* **Scoreboard:** Real-time self-checking via Mailboxes.

![Architecture Diagram](image/Environment_Architecture.png)
*Figure: Layered Verification Environment Architecture.*

---

## 🛡️ Assertion-Based Verification (ABV)
We implemented Concurrent Assertions (SVA) to monitor:
* **Protocol Checks:** Handshake and timing enforcement (`|->`, `|=>`).
* **Arithmetic Integrity:** Division-by-zero validation (`0xDEAD`).
* **Stability:** Register bank reserved bits and idle output stability.

![Assertion Coverage](image/Assertion_Results.png)
*Figure: Assertion-based verification pass/fail status.*

---

## 📈 Coverage-Driven Verification (CDV)
Verification quality is measured through:
* **Code Coverage:** Statement, branch, and toggle coverage.
* **Functional Coverage:** Opcode coverage, cross-coverage, and bins analysis.

![Coverage Report](image/Coverage_Summary.png)
*Figure: Functional and Code coverage metrics summary.*

---

## 📊 Simulation Results
1. **Automated Verification:** Zero mismatches recorded in the Scoreboard.
2. **Waveform Debugging:** Verdi analysis confirms signal timing and logic validity.

![Waveform Analysis](image/Waveform.png)
*Figure: Waveform analysis demonstrating synchronous data transfer.*

---

## 🚀 Key Features
* **CRV:** Maximizes test space exploration.
* **OOP Implementation:** Inheritance and polymorphism.
* **Coverage-Driven Closure:** Metric-based completion.

---

## 💻 Tools
* **Simulation:** Synopsys VCS
* **Analysis:** Verdi GUI (Waveforms, Coverage Reports)








# SystemVerilog ALU & Register-Bank Verification Environment

## Overview

This project demonstrates the development of a complete Object-Oriented SystemVerilog verification environment for an ALU and Register-Bank subsystem.

The verification environment was built from scratch using industry-standard verification concepts, including Constrained-Random Verification (CRV), Assertion-Based Verification (ABV), Functional Coverage, Code Coverage, and self-checking mechanisms.

The primary goal was to verify RTL functionality, identify design bugs, and achieve verification closure through coverage-driven methodologies.

---

## Design Under Test (DUT)

The DUT consists of:

### ALU

Supports arithmetic operations:

* Addition (ADD)
* Subtraction (SUB)
* Multiplication (MUL)
* Division (DIV)

### Register Bank

Stores:

* Operand A
* Operand B
* Opcode
* Execute control signal

The ALU and Register Bank are integrated into a single subsystem that receives commands, executes operations, and generates results.

---

## Verification Environment Architecture

A modular OOP-based verification environment was developed using SystemVerilog classes and Mailbox-based communication.

### Components

* **Generator**

  * Creates constrained-random and directed transactions.
  * Supports specialized scenarios such as division-by-zero testing.

* **Driver**

  * Converts transactions into DUT stimulus.
  * Drives signals through the virtual interface.

* **Input Monitor**

  * Captures DUT inputs.
  * Sends observed transactions to the Scoreboard.

* **Output Monitor**

  * Captures DUT outputs.
  * Tracks actual DUT behavior.

* **Scoreboard**

  * Implements automatic result checking.
  * Compares expected and actual results.
  * Reports mismatches and functional errors.

* **Coverage Collector**

  * Collects functional coverage.
  * Tracks opcode combinations and corner cases.

Communication between components is implemented using SystemVerilog Mailboxes.

---

## Verification Methodology

### Constrained-Random Verification (CRV)

The environment generates randomized transactions while enforcing legal DUT constraints.

Verification included:

* 20,000+ constrained-random transactions
* Directed corner-case scenarios
* Error-injection testing
* Division-by-zero validation

This approach maximized state-space exploration and improved bug detection efficiency.

---

## Assertion-Based Verification (SVA)

SystemVerilog Assertions were implemented to verify:

* Protocol correctness
* Timing relationships
* Division-by-zero behavior
* Output stability requirements
* Register-bank integrity

Assertions enabled automatic detection of protocol and functional violations during simulation.

---

## Coverage-Driven Verification

### Functional Coverage

Implemented using:

* Covergroups
* Coverpoints
* Cross Coverage

Coverage models tracked:

* Opcode execution
* Input combinations
* Corner-case scenarios
* Functional interactions

### Code Coverage

Measured using Synopsys VCS:

* Statement Coverage
* Branch Coverage
* Toggle Coverage

### Coverage Closure

Results achieved:

* 100% Functional Coverage
* 100% Code Coverage

---

## RTL Debug and Bug Discovery

The verification environment successfully identified and isolated multiple RTL design issues during development.

### Examples of Bugs Found

* Functional RTL logic errors
* Opcode handling issues
* Corner-case execution failures
* Protocol and timing violations

More than 5 functional RTL bugs were detected, debugged, and resolved throughout the verification process.

---

## Simulation Results

### Verification Metrics

* 20,000+ CRV transactions executed
* 5+ functional RTL bugs identified and debugged
* 100% functional coverage achieved
* 100% code coverage achieved
* Zero Scoreboard mismatches after verification closure

---

## Tools

### Verification

* SystemVerilog
* Object-Oriented Programming (OOP)
* Constrained-Random Verification (CRV)
* SystemVerilog Assertions (SVA)

### Simulation & Debug

* Synopsys VCS
* Synopsys Verdi

---

## Key Skills Demonstrated

* Design Verification
* Verification Planning
* Constrained-Random Verification
* Assertion-Based Verification
* Functional Coverage
* Code Coverage
* Coverage Closure
* RTL Debug
* Object-Oriented SystemVerilog
* Self-Checking Testbench Architecture
* Mailbox-Based Communication
* Scoreboard Development

