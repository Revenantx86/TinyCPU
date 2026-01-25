# 🎓 8-Bit CPU Design Training

Welcome to your CPU design roadmap! 🚀

The goal of this project is to build a fully functional 8-bit processor from scratch using Verilog. You will design the hardware modules one by one, and this repository's automated system (CI/CD) will test your code every time you push to GitHub.

**The Rule:**
- 🟢 **Green Check:** Your hardware works. Move to the next module.
- 🔴 **Red Cross:** Something is wrong. Check the logs, fix the bug, and push again.

---

## 🏗️ The Architecture (Your Building Blocks)

A CPU is like a factory with different departments handling specific jobs. You will build these departments in the following order:

### 1. The ALU (Arithmetic Logic Unit)
**The "Calculator"** 🧮
The ALU is the muscles of the CPU. It doesn't "think"; it just does the math you tell it to do. It takes two numbers, performs an operation, and outputs the result.
- **Inputs:** `Operand A`, `Operand B`, `Opcode` (e.g., 0 for Add, 1 for Sub).
- **Outputs:** `Result`, `Zero Flag` (tells us if the answer is 0).

### 📝 Assignment 1: The ALU Specification

**Objective:** Create a module named `alu` in `src/alu.v` that performs arithmetic and logic operations.

### Port Definitions
| Direction | Name | Width | Description |
| :--- | :--- | :--- | :--- |
| Input | `operand_a` | 8-bit | First number |
| Input | `operand_b` | 8-bit | Second number |
| Input | `opcode` | 3-bit | Selects the operation (see table below) |
| Output | `result` | 8-bit | The output of the operation |
| Output | `zero` | 1-bit | Should be **1** if `result` is 0, otherwise **0** |

### Opcode Table (The Rules)
Your ALU must support these 8 operations based on the `opcode` input:

| Opcode (Binary) | Operation | Description |
| :--- | :--- | :--- |
| `000` | **ADD** | `result = operand_a + operand_b` |
| `001` | **SUB** | `result = operand_a - operand_b` |
| `010` | **AND** | `result = operand_a & operand_b` |
| `011` | **OR** | `result = operand_a \| operand_b` |
| `100` | **XOR** | `result = operand_a ^ operand_b` |
| `101` | **NOT** | `result = ~operand_a` (Ignore operand_b) |
| `110` | **SHL** | `result = operand_a << 1` (Shift Left by 1) |
| `111` | **SHR** | `result = operand_a >> 1` (Shift Right by 1) |

---

### 2. The Register File
**The "Scratchpad"** 📝
The CPU needs a fast place to write down numbers while working on them. This module is a small bank of memory cells (Registers).
- **Function:** It allows the CPU to read two numbers at the same time (to add them) and write one new result back.
- **Challenge:** You must ensure you only write data when the `Write Enable` signal is ON.

## 📝 Assignment 2: The Register File

**Objective:** Create a module named `regfile` in `src/regfile.v`.

**Concept:**
This is the CPU's short-term memory. It contains **8 registers** (numbered 0 to 7).
- It has **two read ports** (A and B), so the ALU can request two numbers at once.
- It has **one write port**, so we can save a result back to a register.
- **Important:** Reading happens instantly (Asynchronous). Writing happens ONLY on the rising edge of the clock (Synchronous) and ONLY if `write_enable` is 1.

### Port Definitions
| Direction | Name | Width | Description |
| :--- | :--- | :--- | :--- |
| Input | `clk` | 1-bit | Clock signal |
| Input | `reset` | 1-bit | Synchronous Reset (Sets all registers to 0) |
| Input | `we` | 1-bit | Write Enable (1 = Allow writing, 0 = Read only) |
| Input | `r_addr_a` | 3-bit | Address for Read Port A (Selects R0-R7) |
| Input | `r_addr_b` | 3-bit | Address for Read Port B (Selects R0-R7) |
| Input | `w_addr` | 3-bit | Address to write data into |
| Input | `w_data` | 8-bit | The data to save |
| Output | `r_data_a` | 8-bit | Output data from Port A |
| Output | `r_data_b` | 8-bit | Output data from Port B |

### Implementation Details
- Define the memory as an array: `reg [7:0] registers [0:7];`
- **Reset:** If `reset` is high, loop through all 8 registers and set them to 0.
- **Write:** If `we` is high (and not reset), write `w_data` into `registers[w_addr]`.

### 3. The Program Counter (PC)
**The "Finger on the Page"** ☝️
As a computer runs a program, it needs to know which line of code it is currently reading. The PC is simply a counter that holds the memory address of the *current* instruction.
- **Normal Operation:** Increments by 1 every clock cycle (`PC = PC + 1`).
- **Jumps:** To loop or skip code, we force the PC to a specific number (`PC = Target`).

## 📝 Assignment 3: The Program Counter (PC)

**Objective:** Create a module named `pc` in `src/pc.v`.

**Concept:**
The PC tells the computer which line of code to run next.
- **Normal Mode:** It acts like a standard counter. If we are at line 5, the next line is 6.
- **Jump Mode:** Sometimes we need to "GOTO" a specific line (like in a loop or function call). If the `jump_en` signal is ON, the PC stops counting and forces itself to a new number provided by the input.

**Simplification Note:** To keep this project easy, our PC will be **8-bit**. This means our computer can only have 256 lines of code maximum (Addresses 0 to 255). Real CPUs usually have 32-bit or 64-bit PCs.

### Port Definitions
| Direction | Name | Width | Description |
| :--- | :--- | :--- | :--- |
| Input | `clk` | 1-bit | Clock signal |
| Input | `reset` | 1-bit | Synchronous Reset (Sets PC to 0) |
| Input | `jump_en` | 1-bit | Jump Enable (1 = Load new address, 0 = Count up) |
| Input | `jump_addr`| 8-bit | The target address to jump to |
| Output | `pc_out` | 8-bit | The current instruction address |

### Implementation Details
- On the rising edge of `clk`:
    1. If `reset` is 1, `pc_out` becomes 0.
    2. Else if `jump_en` is 1, `pc_out` becomes `jump_addr`.
    3. Else, `pc_out` becomes `pc_out + 1`.

### 4. Instruction Memory
**The "Instruction Manual"** 📖
This is where the program code lives. The CPU asks for the instruction at a specific address (provided by the PC), and this memory block sends back the raw binary code (machine code) for that instruction.

### 5. The Control Unit
**The "Brain"** 🧠
This is the manager. It looks at the binary code coming from Memory and figures out what to do.
- **Logic:** If it sees binary `0010`, it decides: *"Okay, that is an ADD instruction. I need to turn on the ALU, select Register 1 and Register 2, and tell the Register File to save the answer."*
- **Output:** It sends control signals (wires) to all other blocks to coordinate them.

---

## 📂 Project Structure

- **`src/`**: This is where you write your Verilog code (e.g., `alu.v`, `regfile.v`).
- **`tb/`**: This contains the "Testbenches" (The Exams). These files test your designs.
- **`.github/`**: The automated testing robot. (Do not edit this folder).

---

## 🛠️ How to Work

1.  **Pick a Module:** Start with the ALU.
2.  **Write the Code:** Create the file in the `src/` folder.
3.  **Test Locally (Optional):** If you have Icarus Verilog installed, run:
    ```bash
    iverilog -o sim_result src/alu.v tb/tb_alu.v
    vvp sim_result
    ```
4.  **Push to GitHub:**
    ```bash
    git add .
    git commit -m "Finished the ALU"
    git push
    ```
5.  **Check Your Grade:** Go to the **Actions** tab on this repository.
    - If it's **Green**, you passed! Move to the next module.
    - If it's **Red**, click on it to see why it failed.

---

### 💡 Pro Tips
- **Draw before you code:** Sketch the inputs and outputs on paper before writing `module ...`.
- **Read the error logs:** The simulation output will tell you exactly *what time* the error happened.
- **Keep it Simple:** Build exactly what is required for the 8-bit spec. Don't overcomplicate it.