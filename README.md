SystemVerilog ALU-Memory Verification Project
Overview
This repository contains a comprehensive SystemVerilog Verification Environment for an ALU-Memory Subsystem. The project demonstrates advanced verification methodologies, including Constrained Random Verification (CRV) and Object-Oriented Programming (OOP), to ensure the functional integrity of a hardware design
.
Design Under Test (DUT)
The DUT is a unified module (alu_mem) consisting of:
ALU: Supports arithmetic operations with parameterized data widths
.
Memory Unit: Includes internal registers for operands (A, B), operation codes (op), and execution triggers
.
Interface: A modular alu_mem_if connecting the testbench and design via specialized modports and clocking blocks to prevent race conditions
.
Verification Environment Architecture
The testbench follows a Layered Architecture to promote modularity and reusability
:
Generator: Generates randomized transactions, including specialized sequences for corner cases like Division by Zero and Overflow
.
Driver: Injects transactions into the virtual interface
.
Monitors: Divided into monitor_in (sampling inputs) and monitor_out (sampling DUT results) for precise data tracking
.
Scoreboard: Performs automated self-checking by comparing expected results against actual DUT outputs using Mailboxes and Queues
.
Environment & Test: Encapsulate all components and manage the simulation phases
.
Key Features
CRV (Constrained Random Verification): Used to reach high functional coverage
.
OOP Implementation: Extensive use of inheritance (e.g., good_tran extending transaction) and polymorphism
.
Dynamic Data Handling: Synchronization of data streams using SystemVerilog Mailboxes
.
How to Run
Ensure you have a SystemVerilog simulator (e.g., Vivado, Questa, or VCS).
Compile the files starting from the top module: tb_top.sv.
Run the simulation to see the scoreboard validation results.
Author
Yonatan Zvida - Junior FPGA / VLSI Engineer
.

--------------------------------------------------------------------------------
