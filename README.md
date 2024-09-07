# 16-Bit RISC Pipeline Microprocessor

## Introduction
Welcome to the repository for our EE309: Microprocessor Systems project at IIT Bombay. This repository documents the design and implementation of a 16-bit RISC pipeline microprocessor. The project focused on creating a CPU with a six-stage pipeline architecture based on the RISC principles, optimizing both performance and efficiency.

## Core Concepts Implemented
### Pipeline
The project features a six-stage pipeline architecture that improves CPU performance by executing multiple instructions simultaneously. The stages include:
- Instruction Fetch (IF)
- Instruction Decode (ID)
- Register Read (RR)
- Execute (EX)
- Memory Access (MEM)
- Write Back (WB)

To manage the hazards that arise from this approach, we implemented forwarding and stalling techniques to ensure smooth pipeline operation.

### RISC Architecture
Our microprocessor follows the RISC architecture, using simple, fixed-length instructions to enable efficient pipelining and faster execution compared to CISC architectures.

## The Six Stages of Pipelining
1. **Instruction Fetch (IF)**: The next instruction is fetched from memory.
2. **Instruction Decode (ID)**: The fetched instruction is decoded and prepared for execution.
3. **Register Read (RR)**: Register values are read and any hazards are addressed using forwarding or stalling.
4. **Execute (EX)**: The Arithmetic Logic Unit (ALU) performs the required operation.
5. **Memory Access (MEM)**: The instruction either reads from or writes to memory.
6. **Write Back (WB)**: The result of the instruction is written back to the register file.

## Handling Hazards
### Data Hazards
We used data forwarding and stalling techniques to resolve data hazards effectively, ensuring that the pipeline does not stall unnecessarily.

### Control Hazards
Control hazards, arising from branching and jump instructions, were managed with a dynamic branch predictor. Incorrect predictions triggered a recovery process that flushed incorrect instructions.

## Datapath Design
The pipeline includes several core components, such as:
- Instruction Decoder
- Control Unit
- Arithmetic and Logic Unit (ALU)
- Memory Management Unit (MMU)
- Hazard control units

These components were carefully designed and integrated to optimize performance and minimize hazards.

## Team Members
- Jatin Kumar
- Hrishikesh S
- Suyash Jitendra Majhi
- Arnav Agrawal

## Documentation
For more detailed information, refer to the following:

- [Problem Statement](https://github.com/brycisliova/RISC-Processor-Design/blob/main/EE309-Project-pipelined-RISC-IITB-statement.pdf)
- [Project Report](https://github.com/brycisliova/RISC-Processor-Design/blob/main/Team_ID_10_EE309_Report.pdf)

## Conclusion
This project demonstrates the design and implementation of a 16-bit RISC pipeline microprocessor, highlighting key concepts in CPU architecture and hazard management.

Feel free to use this repository for reference, but please avoid directly copying the code. It's your learning process—challenge yourself, understand the concepts, and get better!
