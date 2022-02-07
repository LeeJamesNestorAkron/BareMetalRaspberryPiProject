#include "mm.h"

.section ".text.boot"
//Everything defined in boot.S goes in the .text.boot section
//this section is defined at the beggining of the kernel image by the linker script

.globl _start
_start:
    mrs x0, mpidr_el1
    and x0,x0, #0xFF
    cbz x0, master
    b proc_hang

//mrs: mrs (Rn, coproc_register) 
//mrs: Load a value from a system register to a general purpose register
//Arm destination register, must not be PC
//coproc_register, name of the coprocessor register
//mpidr_el1 is the processor ID system register
//and: Do the logical AND operation, strips the last
//op: Rd, Rn, Operand2
//op is AND,ORR logical OR, EOR, logical exclusive OR, BIC, logical AND NOT, ORN, logical OR NOT(thumb only)
//Rd is the destination register
//Rn is the register onling the first operand
//Operand2 is a flexible second operand
//FF is 255, (fifteen ones, fifteen sixteens)
//This strips the last byte from the value from the mpidr_el1 register
//CBZ: Compares the result of the previously done operation to zero and jump to the label if yielded true
//CBZ: Compare and Branch on Zero, or CBNZ: Compare and brancy on non-zero
//CBZ Rn, label
//rn is the register holding the operand
//label is the branch destination
//b is an unconditional branch to a process

master:
    adr x0, bss_begin
    adr x1, bss_end
    sub x1,x1,x0
    bl memzero

    mov sp, #LOW_MEMORY
    bl kernel_main
    b proc_hang
//ADR: generate a register-relative address in the destination register, for a label defined in a storage map
//ADR Rd,label
//rd is the destination register to load
// a symbol defined by a field directive, label specifies an offset from the base register which is defined using the MAP directive
//MAP: a base-register
//FIELD describes a space within a storage map that has bee ndefined using the map directive
//bl, branch with a label
//mov: move a value between registers, ro a constant to a register
//b conditionless branch
//Throw a pointer to the beginning of bss, and one to the end of bss then clean it out with memzero
//sp is the stack pointer, we aim it at kernel main, and then branch to proccess hanging

proc_hang:
    wfe
    b proc_hang