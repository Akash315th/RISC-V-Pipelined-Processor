# RISC-V Pipelined Processor (Verilog)

## 📌 Overview

This project implements a 5-stage pipelined RISC-V processor using Verilog HDL. The design improves performance by executing multiple instructions simultaneously.

## ⚙️ Pipeline Stages

* Instruction Fetch (IF)
* Instruction Decode (ID)
* Execute (EX)
* Memory Access (MEM)
* Write Back (WB)

## 🚀 Features

* 32-bit RISC-V architecture (RV32I)
* Hazard Detection Unit
* Forwarding Unit
* Pipeline Registers
* Modular Verilog Design

## 🛠️ Tools Used

* Icarus Verilog
* GTKWave

## ▶️ Simulation

Run using:
iverilog -o output *.v
vvp output

## 📷 Output

(Add waveform screenshots here)

## 📚 Future Improvements

* Branch prediction
* Cache memory integration

## 👨‍💻 Author

Akash Kumar
