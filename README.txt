REGISTERS:

'rax': scratch register used for 64-bit longs returned by functions
'eax': scratch register used for 32-bit ints returned by functions
'ax': scratch register used for 16-bit shorts returned by functions
'al': scratch register used for 8-bit chars returned by functions

'rcx': 64-bit scratch register used as a counter
'ecx': 32-bit scratch register used as a counter
'cl': 8-bit scratch register used as a counter

'rdx': general scratch register used for 64-bit longs
'edx': general scratch register used for 32-bit ints
'dl': general scratch register used for 16-bit chars

'rsi', 'rdi': 64-bit scratch registers for function parameters
'esi', 'edi': 32-bit scratch registers for function parameters

'rsp': 64-bit pointer to the current top element of the stack. Also known
as the "Stack Pointer". It is only used a small handful of times throughout
the program.

*** IMPORTANT ***
'rbp': 64-bit pointer used to represent the base of the stack. Also known
as the "Base Pointer". This is the most commonly used pointer in
the program.

INSTRUCTIONS:

'push': Decrements the stack pointer and stores the operand on the top of the
stack.

'pop  DESTINATION': Loads the value from the top of the stack and puts it into
the specified destination, then increments the stack pointer ('rsp').

'mov  A, B': Copy 'B' into 'A'. 'B' can be an immediate value, a register, or a
location in memory. 'A' can be a register or a location in memory, but not an
immediate value.

'movsx  A, B': Copy 'B' into 'A' and extend its size (8-bits) to either 16
or 32-bits. 'B' can be a register or a memory location. 'A' is a register.

'movzx  A, B': Copy 'B' into 'A' and extend its size. 'B' can be a register or a
memory location. 'A' is a register.

'add  A, B': Add 'B' to 'A' and store the result in 'A'. 'A' can be a
register or a memory location. 'B' can be an immediate value, a register, or a
memory location. HOWEVER, both operands cannot be memory locations.

'sub  A, B': Subtract 'B' from 'A' and store the result in 'A'. 'A' can be a
register or a memory location. 'B' can be an immediate value, a register, or a
memory location. HOWEVER, both operands cannot be memory locations.

'and  A, B': Performs a bitwise AND operation on 'A' and 'B', and then
stores the result in 'A'. 'B' can be an immediate value, a register, or a
memory location. 'A' can be a register or a memory location. HOWEVER, both
operands cannot be memory locations.

'sal  A, B': SAL = "Shift Arithmetic Left" -> Shifts the bits in 'A' to the left
by the number of bits specified by 'B' (the count operand).

'setne  DESTINATION': Always preceded by some kind of conditional
operator (i.e. AND). It takes the flag set by said conditional operator and
sets it to the destination (can either be a byte register or a byte in memory)
if it is NOT equal to it already.

'lea  A, [B]': LEA = "Load Effective Address" -> Gets the address of [B] and
stores it in 'A'. [B] is a memory address, and 'A' is a register.

'jmp': Transfers control to a separate part of the program ("jumps") without
storing return information.

'je INSTRUCTION': This is always preceded by a 'cmp  A, B' instruction. It
jumps to the specified instruction if the 'cmp  A, B' instruction found them to
be equal.

'jne  INSTRUCTION': This is always preceded by a 'cmp  A, B' instruction. It
jumps to the specified instruction if the 'cmp  A, B' instruction found them to
be NOT equal.

'jle  INSTRUCTION': This is always preceded by a 'cmp  A, B' instruction. It
jumps to the specified instruction if the 'cmp  A, B' instruction found 'B' to
be less than 'A'.

'ret': Transfers control of the program to the current function's return
address (this is just a 'return' statement). If the function in question is
to return some value, it will be loaded into one of the function return
registers ('rax' for 64-bit, 'eax' for 32-bit).

'cmp  A, B': Compares 'A' and 'B' by subtracting 'B' from 'A' and setting a flag
in the same manner as the 'sub  A, B' instruction.
