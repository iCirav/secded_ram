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

Data: d7 d6 d5 d4 d3 d2 d1 d0
ECC: p4 p3 p2 p1 p0
SECDED: g (global parity)


- `p0..p4` are parity bits for Hamming code
- `g` is the global parity bit
- Upon reading:
  - Calculate syndrome: XOR of stored ECC and computed ECC
  - If syndrome == 0 and global parity matches → no error
  - If syndrome != 0 and global parity mismatches → single-bit error (corrected)
  - If syndrome == 0 and global parity mismatches → double-bit error (flagged)

---

## 4. References

- Hamming, R. W., *Error Detecting and Error Correcting Codes*, 1950.
- https://en.wikipedia.org/wiki/Hamming_code
