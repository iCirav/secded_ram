# Memory Map for secded_ram

This document describes the RAM layout and bit assignments for the `secded_ram` project.

---

## 1. RAM Configuration

- Configurable **DATA_WIDTH**: 8-bit or 16-bit  
- Configurable **RAM_DEPTH**: default 256 words  

| Parameter      | Description                  |
|----------------|------------------------------|
| DATA_WIDTH     | Width of each RAM word       |
| RAM_DEPTH      | Number of words in RAM       |
| ECC_BITS       | 5 bits for 8-bit, 6 bits for 16-bit |

---

## 2. Data and ECC Storage

- Each RAM word has an associated ECC code:

| Width | Data Bits | ECC Bits | Total Bits |
|-------|-----------|----------|------------|
| 8-bit | 8         | 5        | 13         |
| 16-bit| 16        | 6        | 22         |

- ECC bits:
  - `p0..pN` – Hamming parity bits
  - `g` – global parity bit

---

## 3. Addressing

- Addresses: `0` to `RAM_DEPTH-1`  
- Access:
  - Write: provide `data_in` + `addr` + `write_en`
  - Read: provide `addr` + `read_en`
  - Output: `data_out`, `single_bit_error`, `double_bit_error`

---

## 4. Notes

- Single-bit errors are automatically corrected on read.  
- Double-bit errors are detected and flagged but **cannot be corrected**.  
- Supports both 8-bit and 16-bit modes via `DATA_WIDTH` parameter.
