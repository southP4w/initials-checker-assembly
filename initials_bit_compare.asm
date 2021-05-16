%include "io64.inc" ; SASM built-in 64-bit I/O macros for NASM and GCC

; *** NOTE: Please run this program on a Linux machine or VM for best results.
; The program must be run in the NASM x64 Setting ***

; Declaring programmer-defined functions:
global chartobin
global checkinput

; Declaring main function:
global main

; Referencing C functions from the C Standard Library and Standard I/O:
extern exit
extern fgets
extern getline
extern malloc
extern perror
extern printf
extern putchar
extern puts
extern stdin

; String constants:
  section .data
greet_user:                 db "My initials:", 0
int_identifier:             db "%d", 0
arrow_and_char_identifier:  db " -> %c", 0
null_buffer_error:          db "Unable to allocate buffer", 0
you_entered:                db "You entered: ", 0
similar_bits_to_big_S:      db "Bits in common with 'S': %d", 0
similar_bits_to_little_s:   db "Bits in common with 's': %d", 0
similar_bits_to_big_P:      db "Bits in common with 'P': %d", 0
similar_bits_to_little_p:   db "Bits in common with 'p': %d", 0

; *** PLEASE SEE THE ATTACHED README.txt FILE FOR MORE INFORMATION REGARDING
; REGISTERS, THEIR NAMES, AND THEIR PURPOSE, AS WELL AS INSTRUCTIONS AND
; WHAT THEY DO ***

; *** Program begins here ***
  section .text
; The main function
main:
        push    rbp
        mov     rbp, rsp
        mov     rdx, qword [rbp-24]   ; pass a char pointer to 'rdx'
        mov     rcx, qword [rbp-8]    ;
        mov     rax, qword [rbp-16]   ; pass an unsigned int to 'checkinput'
        mov     rsi, rcx  ; copy the buffer into 'rsi'

        ; 'checkinput' takes 'rsi' as one of its three parameters
        call    checkinput
        mov     eax, 0
        ret

; Function for converting a character to its binary-string form.
chartobin:
        push    rbp
        mov     rbp, rsp
        mov     dword [rbp-20], edi ; 'edi' currently stores the character to be converted
        mov     qword [rbp-32], rsi ; the array of chars for the bits of the char in 'edi'to be compared to:
        mov     dword [rbp-4], 0  ; Initialize a loop counter to 0...
        jmp     .iterate_bitshift_loop  ; ...and get ready to shift_bits:
        ; Shift to the left and print the previous bit in the bit-string:
        .shift_bits:
        mov     eax, dword [rbp-4]
        mov     edx, dword [rbp-20]
        mov     ecx, eax
        ; SAL = "Shift Arithmetic Left"
        sal     edx, cl   ; The counting operator currently resides in 'cl'
        mov     eax, edx  ; Copy the counter into eax
        and     eax, 128  ; Bitwise 'AND' the counter with a system call (Hex literal 0x80 on Linux)
        setne   cl
        mov     eax, dword [rbp-4]
        movsx   rdx, eax
        mov     rax, qword [rbp-32]
        add     rax, rdx
        mov     edx, ecx
        mov     byte [rax], dl
        add     dword [rbp-4], 1
        ; Iterate the loop to retrieve the value of the next bit:
        .iterate_bitshift_loop:
        cmp     dword [rbp-4], 7
        jle     .shift_bits
        ; Exit the function, returning the binary string:
        pop     rbp
        ret

; Function for checking user input
checkinput:
        sub     rsp, 144
        mov     qword [rbp-120], rdi
        mov     qword [rbp-128], rsi
        mov     qword [rbp-136], rdx
        ; Convert 'S' to a binary-string:
        lea     rax, [rbp-78] ; Load the effective address of [rbp-78] and store it in 'rax',
        mov     rsi, rax      ; then copy it into 'rsi'.
        ; Move 'D' into register 'edi' and call 'chartobin' to convert it to a binary string:
        mov     edi, 83 ; 'S'
        call    chartobin

        ; Convert 's' to a binary-string:
        lea     rax, [rbp-86] ; Load the effective address of [rbp-86] and store it in 'rax',
        mov     rsi, rax      ; then copy it into 'rsi'.
        ; Move 'd' into register 'edi' and call 'chartobin' to convert it to a binary string:
        mov     edi, 115  ; 's'
        call    chartobin

        ; Convert 'P' to a binary-string:
        lea     rax, [rbp-94] ; Load the effective address of [rbp-94] and store it in 'rax',
        mov     rsi, rax      ; then copy it into 'rsi'.
        ; Move 'G' into register 'edi' and call 'chartobin' to convert it to a binary string:
        mov     edi, 80 ; 'P'
        call    chartobin

        ; Convert 'p' to a binary-string:
        lea     rax, [rbp-102]  ; Load the effective address of [rbp-94] and store it in 'rax',
        mov     rsi, rax        ; then copy it into 'rsi'.
        ; Move 'g' into register 'edi' and call 'chartobin' to convert it to a binary string:
        mov     edi, 112  ; 'p'
        call    chartobin

        ; Greet user with my initials and their binary-strings:
        mov     edi, greet_user
        call    puts
        ; Begin loop for 'S' binary-string:
        mov     dword [rbp-4], 0
        jmp     .loop_my_big_S

        ; Print the current bit in the loop of the 'S' binary-string:
        .print_current_bit_big_S:
        mov     eax, dword [rbp-4]
        movzx   eax, byte [rbp-78+rax]
        mov     esi, eax
        mov     edi, int_identifier
        mov     eax, 0
        call    printf
        add     dword [rbp-4], 1

        ; Looping through (or out of) the binary-string form of 'S':
        .loop_my_big_S:
        cmp     dword [rbp-4], 7
        jle     .print_current_bit_big_S
        mov     esi, 83   ; Move 'S' into 32-bit register 'esi'
        mov     edi, arrow_and_char_identifier
        mov     eax, 0
        call    printf
        ; Begin loop for 's' binary-string:
        mov     dword [rbp-8], 0
        NEWLINE   ; \n for formatting purposes
        jmp     .loop_my_little_s

        ; Print the current bit in the loop of the 's' binary-string:
        .print_current_bit_little_s:
        mov     eax, dword [rbp-8]
        movzx   eax, byte [rbp-86+rax]
        mov     esi, eax
        mov     edi, int_identifier
        mov     eax, 0
        call    printf
        add     dword [rbp-8], 1

        ; Looping through (or out of) the binary-string form of 's':
        .loop_my_little_s:
        cmp     dword [rbp-8], 7
        jle     .print_current_bit_little_s
        mov     esi, 115  ; Move 's' into 32-bit register 'esi'
        mov     edi, arrow_and_char_identifier
        mov     eax, 0
        call    printf
        ; Begin loop for 'P' binary-string:
        mov     dword [rbp-12], 0
        NEWLINE ; \n for formatting purposes
        jmp     .loop_my_big_P

        ; Print the current bit in the loop of the 'P' binary-string:
        .print_current_bit_big_P:
        mov     eax, dword [rbp-12]
        movzx   eax, byte [rbp-94+rax]
        mov     esi, eax
        mov     edi, int_identifier
        mov     eax, 0
        call    printf
        add     dword [rbp-12], 1
        ; Looping through (or out of) the binary-string form of 'P'
        .loop_my_big_P:
        cmp     dword [rbp-12], 7
        jle     .print_current_bit_big_P
        mov     esi, 80   ; Move 'P' into 32-bit register 'esi'
        mov     edi, arrow_and_char_identifier
        mov     eax, 0
        call    printf
        ; Begin loop for 'p' binary-string:
        mov     dword [rbp-16], 0
        NEWLINE ; \n for formatting purposes
        jmp     .prompt_user_for_input

        ; Print the current bit in the loop of the 'p' binary-string:
        .print_current_bit_little_p:
        mov     eax, dword [rbp-16]

        movzx   eax, byte [rbp-102+rax]
        mov     esi, eax
        mov     edi, int_identifier
        mov     eax, 0
        ; Begin loop for 'p' binary-string:
        call    printf
        add     dword [rbp-16], 1

        ; Finish printing the binary-strings of MY initials and get ready for
        ; user input:
        .prompt_user_for_input:
        cmp     dword [rbp-16], 7
        jle     .print_current_bit_little_p
        mov     esi, 112  ; Move 'p' into 32-bit register 'esi'
        mov     edi, arrow_and_char_identifier
        mov     eax, 0
        call    printf
        NEWLINE ; \n for formatting purposes

        ; Allocate memory for the buffer.
        mov     rax, qword [rbp-128]
        NEWLINE ; \n for formatting purposes
        mov     rdi, rax
        call    malloc      ; Dynamically allocate memory for input using malloc
        mov     qword [rbp-120], rax
        mov     rax, qword [rbp-120]
        test    rax, rax
        jne     .get_input_check_for_q_Q

        ; If the buffer is null, print an error message and exit with an error
        ; code of 1:
        mov     edi, null_buffer_error
        call    perror
        mov     edi, 1
        call    exit      ; C 'exit()' function

        ; It is at this point that the user's input is compared to my initials.
        ; 'stdin' must be passed as a memory address in the form of
        ; a qword (64-bit long):
        .get_input_check_for_q_Q:
        mov     rdx, qword [stdin]      ; Pass the 64-bit input to register 'rdx'
        lea     rcx, [rbp-128]          ; Load the effective address of [rbp-128] into 'rcx'
        lea     rax, [rbp-120]          ; Load the effective address of [rbp-120] into 'rax'
        mov     rsi, rcx                ; Move 'rcx' (currently storing [rbp-128]) into 'rsi'
        mov     rdi, rax                ; Move 'rax' (currently storing [rbp-120]) into 'rdi'
        call    getline                 ; Call the C 'getline()' function
        sub     rax, 1                  ; Subtract 1 from the user's input size to account for '\0' at end of string
        mov     qword [rbp-136], rax

        ; Before checking for matching bits, the program must first see if the
        ; user entered the word "quit" (ignoring case), and if they did, call
        ; the exit function to terminate the program:

        ; Check for the letters 'q' or 'Q':
        mov     rax, qword [rbp-120]
        movzx   eax, byte [rax]
        ; compare the 8-bit char at the first location to 'q':
        cmp     al, 113 ; 'q'
        je      .check_for_u_U
        mov     rax, qword [rbp-120]
        movzx   eax, byte [rax]
        ; compare the 8-bit char at the first location to 'Q':
        cmp     al, 81  ; 'Q'

        ; Check for the letters 'u' or 'U':
        .check_for_u_U:
        mov     rax, qword [rbp-120]
        add     rax, 1
        movzx   eax, byte [rax]
        ; compare the 8-bit char at the second location to 'u'
        cmp     al, 117 ; 'u'
        je      .check_for_i_I
        mov     rax, qword [rbp-120]
        add     rax, 1
        movzx   eax, byte [rax]
        ; compare the 8-bit char at the second location to 'U'
        cmp     al, 85  ; 'U'

        ; Check for the letters 'i' or 'I':
        .check_for_i_I:
        mov     rax, qword [rbp-120]
        add     rax, 2
        movzx   eax, byte [rax]
        ; compare the 8-bit char at the third location to 'i'
        cmp     al, 105 ; 'i'
        je      .check_for_t_T
        mov     rax, qword [rbp-120]
        add     rax, 2
        movzx   eax, byte [rax]
        ; compare the 8-bit char at the third location to 'I'
        cmp     al, 73  ; 'I'

        ; Check for the letters 't' or 'T':
        .check_for_t_T:
        mov     rax, qword [rbp-120]
        add     rax, 3
        movzx   eax, byte [rax]
        ; compare the 8-bit char at the fourth location to 't'
        cmp     al, 116 ; 't'
        je      .terminate_program
        mov     rax, qword [rbp-120]
        add     rax, 3
        movzx   eax, byte [rax]
        ; compare the 8-bit char at the fourth location to 'T'
        cmp     al, 84  ; 'T'
        jne     .user_initials_to_binary
        ; If the user entered "quit" (case insensitive), terminate program
        ; with exit code 0:
        .terminate_program:
        mov     edi, 0
        call    exit
        ; Done getting user input.

        ; Initialize the buffer array with the characters entered by setting
        ; the user's first initial to the first element of the array, and their
        ; last initial to the second element of the array:
        .user_initials_to_binary:
        mov     rax, qword [rbp-120]
        movzx   eax, byte [rax]
        mov     byte [rbp-53], al
        ; Set the user's last initial to the second element of the buffer array:
        mov     rax, qword [rbp-120]
        movzx   eax, byte [rax+1]
        mov     byte [rbp-54], al

        ; At this point, the program counts up the matching bits between both
        ; cases of my initials and their own, and prints them out for the
        ; user to see in the console:
        mov     dword [rbp-20], 0   ; Set the number of matching bits to 0
        ; Convert the user's first initial to its binary-string form:
        movsx   eax, byte [rbp-53]
        lea     rdx, [rbp-62]
        mov     rsi, rdx
        mov     edi, eax
        call    chartobin
        ; Print "You entered:" and display the user's first initial, as well
        ; as its binary-string form:
        mov     edi, you_entered
        mov     eax, 0
        call    printf
        mov     dword [rbp-24], 0
        jmp     .user_first_bits_in_common_with_big_S

        ; Compare the bits of the user's first initial to those of my own, in
        ; uppercase form:
        .compare_user_first_to_my_big_S:
        mov     eax, dword [rbp-24]
        movzx   edx, byte [rbp-62+rax]
        mov     eax, dword [rbp-24]
        movzx   eax, byte [rbp-78+rax]
        ; If the current bit in the binary-string form of the user's first
        ; initial is equal to that of my own ('S')...
        cmp     dl, al
        jne     .user_first_binary_current_bit  ; ...then increment the number of similar bits by 1.
        add     dword [rbp-20], 1

        .user_first_binary_current_bit: ; print the value of the current bit
                                        ; being looped over in the user's first
                                        ; initial:
        mov     eax, dword [rbp-24]
        movzx   eax, byte [rbp-62+rax]
        mov     esi, eax
        mov     edi, int_identifier
        mov     eax, 0
        call    printf
        add     dword [rbp-24], 1

        ; Print the number of bits the two characters (user's first initial and
        ; 'S') have in common, as well as the user's actual first initial:
        .user_first_bits_in_common_with_big_S:
        cmp     dword [rbp-24], 7
        jle     .compare_user_first_to_my_big_S
        movsx   eax, byte [rbp-53]
        mov     esi, eax
        mov     edi, arrow_and_char_identifier
        mov     eax, 0
        call    printf
        mov     eax, dword [rbp-20]
        ; Print the string "Bits in common..." followed by the number of similar
        ; bits:
        NEWLINE ; \n for formatting purposes
        mov     esi, eax
        mov     edi, similar_bits_to_big_S
        mov     eax, 0
        call    printf
        ; Set the number of similar bits back to 0 to in preparation for the
        ; following loop ('s'):
        mov     dword [rbp-20], 0
        mov     dword [rbp-28], 0 ; Initialize the loop counter to 0...
        jmp     .user_first_bits_in_common_with_little_s  ; ...and get ready to loop.

        ; Compare the bits of the user's first initial to those of my own, in
        ; lowercase form:
        .compare_user_first_to_my_little_s:
        mov     eax, dword [rbp-28]
        movzx   edx, byte [rbp-62+rax]
        mov     eax, dword [rbp-28]
        movzx   eax, byte [rbp-86+rax]
        ; If the current bit in the binary-string form of the user's first
        ; initial is equal to that of my own ('s')...
        cmp     dl, al
        jne     .increment_1  ; ...then increment the number of similar bits by 1.
        add     dword [rbp-20], 1

        .increment_1:
        add     dword [rbp-28], 1

        ; Print the number of bits the two characters (user's first initial and
        ; 's'):
        .user_first_bits_in_common_with_little_s:
        cmp     dword [rbp-28], 7
        jle     .compare_user_first_to_my_little_s
        mov     edi, 10
        call    putchar
        mov     eax, dword [rbp-20]
        mov     esi, eax
        mov     edi, similar_bits_to_little_s
        mov     eax, 0
        call    printf
        ; Set the number of similar bits back to 0 to in preparation for the
        ; following loop ('P'):
        mov     dword [rbp-20], 0
        mov     dword [rbp-32], 0 ; Initialize the loop counter to 0...
        jmp     .user_first_bits_in_common_with_big_P ; ...and get ready to loop.

        ; Compare the bits of the user's first initial to those of my LAST, in
        ; uppercase form:
        .compare_user_first_to_my_big_P:
        mov     eax, dword [rbp-32]
        movzx   edx, byte [rbp-62+rax]
        mov     eax, dword [rbp-32]
        movzx   eax, byte [rbp-94+rax]
        ; If the current bit in the binary-string form of the user's first
        ; initial is equal to that of my LAST ('P')...
        cmp     dl, al
        jne     .increment_1a ; ...then increment the number of similar bits by 1.
        add     dword [rbp-20], 1

        .increment_1a:
        add     dword [rbp-32], 1

        ; Print the number of bits the two characters (user's first initial and
        ; 'P'):
        .user_first_bits_in_common_with_big_P:
        cmp     dword [rbp-32], 7
        jle     .compare_user_first_to_my_big_P
        mov     eax, dword [rbp-20]
        NEWLINE ; \n for formatting purposes
        mov     esi, eax
        mov     edi, similar_bits_to_big_P
        mov     eax, 0
        call    printf
        ; Set the number of similar bits back to 0 to in preparation for the
        ; following loop ('p'):
        mov     dword [rbp-20], 0
        mov     dword [rbp-36], 0 ; Initialize the loop counter to 0...
        jmp     .user_first_bits_in_common_with_little_p  ; ...and get ready to loop.

        ; Compare the bits of the user's first initial to those of my LAST, in
        ; lowercase form:
        .compare_user_first_to_my_little_p:
        mov     eax, dword [rbp-36]
        movzx   edx, byte [rbp-62+rax]
        mov     eax, dword [rbp-36]
        movzx   eax, byte [rbp-102+rax]
        ; If the current bit in the binary-string form of the user's first
        ; initial is equal to that of my LAST ('p')...
        cmp     dl, al
        jne     .increment_1b ; ...then increment the number of similar bits by 1.
        add     dword [rbp-20], 1

        .increment_1b:
        add     dword [rbp-36], 1

        ; Print the number of bits the two characters (user's first initial and
        ; 'p'):
        .user_first_bits_in_common_with_little_p:
        cmp     dword [rbp-36], 7
        jle     .compare_user_first_to_my_little_p
        mov     eax, dword [rbp-20]
        NEWLINE ; \n for formatting purposes
        mov     esi, eax
        mov     edi, similar_bits_to_little_p
        mov     eax, 0
        call    printf
        ; Set the number of similar bits back to 0 in preparation for the
        ; following loop ('S'):
        mov     dword [rbp-20], 0
        NEWLINE ; \n for formatting purposes

        ; Convert the user's last initial to its binary-string form:
        movsx   eax, byte [rbp-54]
        lea     rdx, [rbp-70]
        mov     rsi, rdx
        mov     edi, eax
        call    chartobin
        ; Print "You entered:" and display the user's first initial, as well
        ; as its binary-string form:
        mov     edi, you_entered
        mov     eax, 0
        NEWLINE ; \n for formatting purposes
        call    printf
        mov     dword [rbp-40], 0
        jmp     .user_last_bits_in_common_with_big_S

        ; Compare the bits of the user's last initial to those of my FIRST, in
        ; uppercase form:
        .compare_user_last_to_my_big_S:
        mov     eax, dword [rbp-40]
        movzx   edx, byte [rbp-70+rax]
        mov     eax, dword [rbp-40]
        movzx   eax, byte [rbp-78+rax]
        ; If the current bit in the binary-string form of the user's last
        ; initial is equal to that of my FIRST ('S')...
        cmp     dl, al
        jne     .user_last_binary_current_bit ; ...then increment the number of similar bits by 1.
        add     dword [rbp-20], 1

        .user_last_binary_current_bit:  ; print the value of the current bit
                                        ; being looped over in the user's first
                                        ; initial:
        mov     eax, dword [rbp-40]
        movzx   eax, byte [rbp-70+rax]
        mov     esi, eax
        mov     edi, int_identifier
        mov     eax, 0
        call    printf
        add     dword [rbp-40], 1

        ; Print the number of bits the two characters (user's last initial and
        ; 'S') have in common, as well as the user's actual last initial:
        .user_last_bits_in_common_with_big_S:
        cmp     dword [rbp-40], 7
        jle     .compare_user_last_to_my_big_S
        movsx   eax, byte [rbp-54]
        mov     esi, eax
        mov     edi, arrow_and_char_identifier
        mov     eax, 0
        call    printf
        mov     eax, dword [rbp-20]
        NEWLINE ; \n for formatting purposes
        mov     esi, eax
        mov     edi, similar_bits_to_big_S
        mov     eax, 0
        call    printf
        ; Set the number of similar bits back to 0 in preparation for the
        ; following loop ('s'):
        mov     dword [rbp-20], 0
        mov     dword [rbp-44], 0  ; Initialize the loop counter to 0...
        jmp     .user_last_bits_in_common_with_little_s ; ...and get ready to loop.

        ; Compare the bits of the user's last initial to those of my FIRST, in
        ; lowercase form ('s'):
        .compare_user_last_to_my_little_s:
        mov     eax, dword [rbp-44]
        movzx   edx, byte [rbp-70+rax]
        mov     eax, dword [rbp-44]
        movzx   eax, byte [rbp-86+rax]
        ; If the current bit in the binary-string form of the user's last
        ; initial is equal to that of my FIRST ('s')...
        cmp     dl, al
        jne     .increment_1c ; ...then increment the number of similar bits by 1.
        add     dword [rbp-20], 1

        .increment_1c:
        add     dword [rbp-44], 1

        ; Print the number of bits the two characters (user's last initial and
        ; 's') have in common:
        .user_last_bits_in_common_with_little_s:
        cmp     dword [rbp-44], 7
        jle     .compare_user_last_to_my_little_s
        mov     edi, 10
        call    putchar
        mov     eax, dword [rbp-20]
        mov     esi, eax
        mov     edi, similar_bits_to_little_s
        mov     eax, 0
        call    printf
        ; Set the number of similar bits back to 0 in preparation for the
        ; following loop ('P'):
        mov     dword [rbp-20], 0
        mov     dword [rbp-48], 0 ; Initialize the loop counter to 0...
        jmp     .user_last_bits_in_common_with_big_P  ; ...and get ready to loop.

        ; Compare the bits of the user's last initial to those of my own, in
        ; uppercase form ('P'):
        .compare_user_last_to_my_big_P:
        mov     eax, dword [rbp-48]
        movzx   edx, byte [rbp-70+rax]
        mov     eax, dword [rbp-48]
        movzx   eax, byte [rbp-94+rax]
        ; If the current bit in the binary-string form of the user's last
        ; initial is equal to that of my own ('P')...
        cmp     dl, al
        jne     .increment_1d ; ...then increment the number of similar bits by 1.
        add     dword [rbp-20], 1

        .increment_1d:
        add     dword [rbp-48], 1

        ; Print the number of bits the two characters (user's last initial and
        ; 'P') have in common:
        .user_last_bits_in_common_with_big_P:
        cmp     dword [rbp-48], 7
        jle     .compare_user_last_to_my_big_P
        mov     eax, dword [rbp-20]
        NEWLINE ; \n for formatting purposes
        mov     esi, eax
        mov     edi, similar_bits_to_big_P
        mov     eax, 0
        call    printf
        ; Set the number of similar bits back to 0 in preparation for the
        ; following loop ('p'):
        mov     dword [rbp-20], 0
        mov     dword [rbp-52], 0 ; Initialize the loop counter to 0...
        jmp     .user_last_bits_in_common_with_little_p ; ...and get ready to loop.


        ; Compare the bits of the user's last initial to those of my own, in
        ; lowercase form ('p'):
        .compare_user_last_to_my_little_p:
        mov     eax, dword [rbp-52]
        movzx   edx, byte [rbp-70+rax]
        mov     eax, dword [rbp-52]
        movzx   eax, byte [rbp-102+rax]
        ; If the current bit in the binary-string form of the user's last
        ; initial is equal to that of my own ('p')...
        cmp     dl, al
        jne     .increment_1e ; ...then increment the number of similar bits by 1.
        add     dword [rbp-20], 1

        .increment_1e:
        add     dword [rbp-52], 1

        ; Print the number of bits the two characters (user's last initial and
        ; 'p') have in common:
        .user_last_bits_in_common_with_little_p:
        cmp     dword [rbp-52], 7
        jle     .compare_user_last_to_my_little_p
        mov     eax, dword [rbp-20]
        NEWLINE ; \n for formatting purposes
        mov     esi, eax
        mov     edi, similar_bits_to_little_p
        mov     eax, 0
        call    printf
        mov     eax, 0
        leave
        ret
