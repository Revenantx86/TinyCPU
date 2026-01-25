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

### 2. The Register File
**The "Scratchpad"** 📝
The CPU needs a fast place to write down numbers while working on them. This module is a small bank of memory cells (Registers).
- **Function:** It allows the CPU to read two numbers at the same time (to add them) and write one new result back.
- **Challenge:** You must ensure you only write data when the `Write Enable` signal is ON.

### 3. The Program Counter (PC)
**The "Finger on the Page"** ☝️
As a computer runs a program, it needs to know which line of code it is currently reading. The PC is simply a counter that holds the memory address of the *current* instruction.
- **Normal Operation:** Increments by 1 every clock cycle (`PC = PC + 1`).
- **Jumps:** To loop or skip code, we force the PC to a specific number (`PC = Target`).

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