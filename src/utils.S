.globl delay
#.globl makes it available to access by ld, avaible outside of it
#delay is a symbol

delay:
    subs x0, x0, #1
    bne delay
    ret

#subs: Subtract without carry command but changes the condition flags depending on the result
#cond is an optional condition code
#sub rd, rn , (operand2/imm12)
#rd is the destination register
#rn is the register with the first operator
#operand2 is the flexible second operand, imm12 is any value between 0-4095
#so it takes x0, subtracts 1, and throws it back int x0
#x0 is general purpose and for 64 bit calculations
#bne: Branch if Not Equal, it branches based off the flag set by subs
#subs checks the condition if x0 is equal to zero, the it triggers the cond flag
#zzz if not bne jumps to the beginning again
# returns from subroutine, branches unconditionally to an address in a register, defaults to x30 if absent

.globl put32
put32:
    str w1, [x0]
    ret


.globl get32
get32:
    ldr w0, [x0]
    ret

#(ldr/str) , Rt, [Rn,Rm]
#ldr is load register,str is store registore
#Rt specifies the register to load or store
#rn specifies the register on which the memory address is based
#Rm specifies the register containing a value to be used as the offset
