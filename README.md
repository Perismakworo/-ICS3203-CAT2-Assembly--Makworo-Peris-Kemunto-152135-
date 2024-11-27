# **ICS3203-CAT2-Assembly-Makworo-Peris-Kemunto-152135**

This repository contains the solutions to the practical tasks assigned in the Assembly Language Programming CAT 2, demonstrating mastery of control flow, array manipulation, modular programming, and hardware simulation concepts.

---

## **Table of Contents**
1. [Task 1: Control Flow and Conditional Logic](#task-1-control-flow-and-conditional-logic)
2. [Task 2: Array Manipulation with Looping and Reversal](#task-2-array-manipulation-with-looping-and-reversal)
3. [Task 3: Modular Program for Factorial Calculation](#task-3-modular-program-for-factorial-calculation)
4. [Task 4: Data Monitoring and Control Using Port-Based Simulation](#task-4-data-monitoring-and-control-using-port-based-simulation)

---

## **Task 1: Control Flow and Conditional Logic**
**Objective:**  
Develop a program that accepts a number from the user and categorizes it as `POSITIVE`, `NEGATIVE`, or `ZERO` using conditional and unconditional branching.

### **Features**
- Utilizes **both conditional and unconditional jumps** to efficiently handle classification.
- Prompts the user to input a number, processes it, and displays the appropriate category.

### **Commands to Compile and Run**
```bash
cd Task1
nasm -f elf32 task1.asm -o task1.o -g
ld -m elf_i386 task1.o -o task1
./task1
```

### **Challenges and Insights**
- Gaining a solid understanding of **branching mechanics** to manage program flow was crucial.
- Carefully managed jumps (`je`, `jg`, `jl`, `jmp`) to ensure accurate classification without disrupting execution.

---

## **Task 2: Array Manipulation with Looping and Reversal**
**Objective:**  
Create a program that accepts an array of integers, reverses it in place using loops, and outputs the reversed array.

### **Features**
- **In-place Reversal:** The array is manipulated directly, avoiding the use of additional memory.
- **Loop-Based Reversal:** Efficiently swaps elements using loop constructs.
- Comprehensive comments explain the reversal process and pointer manipulation.

### **Commands to Compile and Run**
```bash
cd Task2
nasm -f elf32 task2.asm -o task2.o -g
ld -m elf_i386 task2.o -o task2
./task2
```

### **Challenges and Insights**
- Reversing the array in place required meticulous management of **pointer arithmetic** to prevent memory access errors.
- Handling direct memory operations while maintaining code clarity was a key focus.

---

## **Task 3: Modular Program for Factorial Calculation**
**Objective:**  
Implement a program that computes the factorial of a user-input number using a modular design with subroutines.

### **Features**
- **Subroutine-Based Design:** Factorial calculation is delegated to a separate, reusable function.
- **Stack Management:** Demonstrates proper handling of registers using the stack.
- The final result is stored in a general-purpose register (`eax`).

### **Commands to Compile and Run**
```bash
cd Task3
nasm -f elf32 task3.asm -o task3.o -g
ld -m elf_i386 task3.o -o task3
./task3
```

### **Challenges and Insights**
- Preserving and restoring register states during recursive subroutine calls was critical.
- Demonstrated the importance of the stack in managing **function state** and ensuring reliable execution.

---

## **Task 4: Data Monitoring and Control Using Port-Based Simulation**
**Objective:**  
Simulate a program that monitors sensor data and takes appropriate actions based on predefined thresholds.

### **Features**
- Simulates sensor data to trigger various control actions:
  - **Motor Activation:** Activates the motor if the sensor value is moderate.
  - **Alarm Trigger:** Sets off an alarm if the sensor value exceeds the threshold.
  - **Motor Shutdown:** Stops the motor when the sensor value is below a certain level.
- Direct manipulation of **memory-mapped locations** to simulate hardware control.

### **Commands to Compile and Run**
```bash
cd Task4
nasm -f elf32 task4.asm -o task4.o -g
ld -m elf_i386 task4.o -o task4
./task4
```

### **Challenges and Insights**
- Simulating hardware behavior required a deep understanding of how **memory-mapped I/O** operates.
- Balancing control logic with efficient memory manipulation techniques was an insightful experience.

---

## **Author**
- **Name:** Makworo Peris Kemunto 
- **Admission Number:** 152135  

This repository demonstrates a clear grasp of assembly programming concepts, modular design, and memory management techniques. Feel free to reach out with any questions or suggestions!
