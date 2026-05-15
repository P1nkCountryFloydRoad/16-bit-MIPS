# 16-bit MIPS Single-Cycle Processor

## 1. Design
This is a single-cycle RISC processor inspired by MIPS, scaled to a 16-bit instruction width with an 8-bit datapath. The processor supports three distinct instruction formats (R-Type, I-Type, and J-Type) across a 12-instruction ISA. The system utilizes a Harvard architecture with fully separated instruction and data memories to allow simultaneous instruction fetching and data access.