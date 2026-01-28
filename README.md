# UART Transmitter Design in VHDL

**Course:** CEG3155 – Digital Systems II  
**Institution:** University of Ottawa  
**Term:** Fall 2023  

## Overview
This project implements a **UART (Universal Asynchronous Receiver-Transmitter) transmitter** in **VHDL**. The design enables serial communication between an FPGA and a computer by transmitting structured debug messages encoded in ASCII format.  

The UART transmitter is integrated with a **traffic light controller**, allowing real-time debugging by sending system state information over a serial interface.

---

## Objectives
- Design and implement a complete UART transmitter in VHDL  
- Encode and transmit data using ASCII serial communication  
- Generate standard UART baud rates using a configurable baud rate generator  
- Control data transmission using finite state machines (FSMs)  
- Verify functionality through simulation and waveform analysis  

---

## System Architecture
The UART transmitter consists of the following main components:

### 1. ASCII Encoding
- Serial data format:
  - 1 start bit (`0`)
  - 8 data bits (LSB first)
  - 1 stop bit (`1`)
- Characters are transmitted sequentially to form debug messages

### 2. Address Decoder
- Selects UART registers through a shared data bus
- Implemented using:
  - 4-to-1 multiplexer
  - 2-to-1 multiplexer
- Simplified due to transmitter-only implementation

### 3. Transmitter Registers
- **TDR (Transmit Data Register):** Stores 8-bit parallel data  
- **TSR (Transmit Shift Register):** 9-bit shift register for serial output  
- **TSR Control FSM:** Controls loading, shifting, and transmission timing using the `TDRE` flag

### 4. Baud Rate Generator
- Converts system clock into UART-compatible baud rates
- Supports standard rates ranging from **300 to 38,400 bps**
- Uses clock division and selection logic

### 5. UART FSM
- 48-state finite state machine
- Controls:
  - Debug message selection
  - Character sequencing
  - UART readiness checking
- Each message consists of 5 ASCII characters plus a carriage return

### 6. Traffic Light Controller Integration
- UART outputs debug messages reflecting traffic light states
- Enables monitoring of controller behavior via serial terminal

---

## Tools and Hardware
- Quartus II (Student / Web Edition)
- Altera DE2-115 FPGA Board
- USB-Blaster
- ModelSim / Quartus Simulator

---

## Verification
- Functional simulation performed in Quartus
- Verified:
  - Correct baud rate timing
  - Proper start and stop bit behavior
  - Correct serial bit order on `TxD`
  - FSM-controlled message transmission
- Waveform analysis confirms correct UART operation

---

## Challenges and Debugging
- Initial issues with the baud rate generator due to incorrect clock connections
- Resolved by decoupling control registers from the baud clock
- Highlighted the importance of clock-domain separation in UART designs

---

## Repository Structure
```text
├── src/
│   ├── UART.vhd
│   ├── UART_FSM.vhd
│   ├── BaudRateGenerator.vhd
│   ├── TDR.vhd
│   ├── TSR.vhd
│   └── AddressDecoder.vhd
├── sim/
│   └── waveforms/
├── top.vhd
└── README.md
