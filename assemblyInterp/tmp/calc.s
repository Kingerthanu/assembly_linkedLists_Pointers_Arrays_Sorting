# CPSC 2500 Spring 2023
# Name: Benjamin R Spitzauer
# Date: 5/16/2023 

# Compile on Linux using: gcc -g -fno-pie -no-pie ./calc.s -o calc

.bss # block starting symbol, contains allocated but not yet initialized memory
num: # num will hold a 64 bit integer provided by the user
    .skip 8     # 8-byte sized alias for a int for user input

.data # Section holds initialized variables
addstr: # Add fstring
    .asciz "%d + %d -> %d\n"

substr: # Subtract fstring
    .asciz "%d - %d -> %d\n"

multstr: # Multiply fstring
    .asciz "%d * %d -> %d\n"

divstr: # Divide fstring (Takes extra param. for Remainder)
    .asciz "%d / %d -> %d \nRemainder: %d\n"

powstr: # Square fstring
    .asciz "%d ^ 2 -> %d \n"

.text
.global main # Main function is globally accessible

getint: # get integer from user
    movq $0, %rax # Input is for reading
    movq $0, %rdi 
    movq $num, %rsi # Set buffer for user input to be stored
    movq $8, %rdx # Read max 8 bytes
    syscall # get user input from STDIN
    movq $num, %rdi
    call atoi # convert user input from string to integer
    ret

printAdd: # print result of addition
    add %rax, %r15 
    mov $addstr, %rdi # Set printf format to addition
    mov %r14, %rsi    # left operand
    mov %rax, %rdx    # right operand
    mov %r15, %rcx    # result
    xor %rax, %rax    # Reset rax state for next calculation
    call printf       # Now concatenate string with parameters given
    jmp LOOP

printSub: # print result of subtraction
    sub %rax, %r15
    mov $substr, %rdi # Set printf format to subtraction
    mov %r14, %rsi    # left operand
    mov %rax, %rdx    # right operand
    mov %r15, %rcx    # result
    xor %rax, %rax    # Reset rax state for next calculation
    call printf       # Now concatenate string with parameters given
    jmp LOOP

printMult: # print result of multiplication
    imulq %rax, %r15
    mov $multstr, %rdi # Set printf format to multiplication
    mov %r14, %rsi   # left operand
    mov %rax, %rdx   # right operand
    mov %r15, %rcx   # result operand
    xor %rax, %rax   # Reset rax state for next calculation
    call printf      # Now concatenate string with parameters given
    jmp LOOP

printPow: # print result of squaring
    imulq %r15, %rax # r15 = rax = operand
    mov $powstr, %rdi # Set printf format to power
    mov %r15, %rsi   # left operand
    mov %rax, %rdx   # result operand
    xor %rax, %rax   # Reset rax state for next calculation
    call printf      # Now concatenate string with parameters given
    jmp LOOP

printDiv: # print result of division
    mov %r15, %r8   # Flip %r15 <-> %rax using %r8 as tmp (%rax / %r15; not %r15 / %rax)
    mov %rax, %r15
    mov %r8, %rax
    idivq %r15       # %rax / %r15
    mov %rdx, %r8   # Set %r8 to remainder
    mov %r15, %rdx  # Set %rdx to right operand for printf args
    mov $divstr, %rdi # Set printf format to division
    mov %r14, %rsi  # left operand
    mov %rax, %rcx  # quotient
    xor %rax, %rax  # Reset rax state for next calculation
    call printf     # Now concatenate string with parameters given
    jmp LOOP


end: # terminate program
    mov $60, %rax # Set exit flag
    xor %rdi, %rdi
    syscall

main:

    # %r13 - operator
    # %r15 - left operand
    # %rax - right operand (contains output of getint)
    
    LOOP:

    call getint # Ask operator from user

    cmp $-1, %rax # Check if user wants to terminate
    je end

    mov %rax, %r13 # Holds Operator

    call getint # Ask first operand from user
    mov %rax, %r15 

    cmp $5, %r13 # Do Squaring (Place here as we only need one operand)
    je printPow

    call getint # Ask second operand from user
    mov %r15, %r14  # Store left operator in reg for formatting

    cmp $1, %r13  # Do Addition
    je printAdd

    cmp $2, %r13 # Do Subtraction
    je printSub

    cmp $3, %r13 # Do Multiplication
    je printMult

    cmp $4, %r13 # Do Division
    je printDiv



    je LOOP
    
    call end
