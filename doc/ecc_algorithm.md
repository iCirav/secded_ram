# ECC Algorithm Documentation

This document explains the **Hamming SECDED (Single Error Correct, Double Error Detect)** algorithm
used in the `secded_ram` project.

---

## 1. Hamming Code Overview

Hamming codes add **parity bits** to data words to detect and correct errors.

- **Data bits**: original data stored in RAM
- **Parity bits**: calculated using XOR across specific data bits
- **Global parity bit**: ensures even parity across the entire word

### Parity Bit Calculation

For an N-bit data word:

1. Insert parity bits at positions that are powers of 2 (1, 2, 4, 8, ...).  
2. Each parity bit covers positions in the data where the binary representation of the position has a 1 in the parity bit’s position.  
3. The **global parity bit** XORs all data bits and parity bits to detect double-bit errors.

---

## 2. SECDED Operation

- **Single-bit error**:
  - Syndrome calculation identifies the erroneous bit.
  - Bit is flipped to correct the data.

- **Double-bit error**:
  - Syndrome indicates an inconsistency.
  - Cannot correct, but is detected and flagged.

---

## 3. Example (8-bit Data Word)

