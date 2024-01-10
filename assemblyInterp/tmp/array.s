	# Initialize metadata of file 
	.file	"array.c"  # Original source for debugger
	.text
	.section	.rodata # Read data, dont write
.LC0: # Create variable (reference) to given print form for integers
	.string	"%d \n"
	.text
	.globl	main # Assembler directive to show scope of where this can be accessed for linker 
	.type	main, @function # Declare function "main" for function invocation
main:
.LFB0: # Label for main function begin
	.cfi_startproc # Initialize call frame information for data struct
	pushq	%rbp 
	.cfi_def_cfa_offset 16 # Sets jump offset of current stack pointer for call frame (16 bytes)
	.cfi_offset 6, -16 # Current val in register 6 is saved in instruction cfa - 16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6 # Set cfa's state to register 6's
	subq	$416, %rsp # Pad 416 bytes for local variables
	movl	$0, -4(%rbp) # Move literal 0 4-bytes below rbp's location (long pads for 32-bit value; sets first element)
	jmp	.L2 # Now move to second stage
.L3: # Add to array new element
	movl	-4(%rbp), %eax # Grab current element position
	cltq # Mnemonic for move doubleword %eax to quadword %rax (inflating it to 64 bits in size)
	movl	-4(%rbp), %edx 
	movl	%edx, -416(%rbp,%rax,4) # Store in array, offsetted by -416 bits and 4 times the current value for padding
	addl	$1, -4(%rbp) # Increment by 1 the value for next check
.L2: # Check size
	cmpl	$99, -4(%rbp) # Compare long literal 99 (checking if last element was 99 [end]) with address 4 bits after rbp
	jle	.L3 # Go add a new element
	movl	$0, -8(%rbp) # Set literal 0 to memory posiiton 8 below rbp
	jmp	.L4
.L5: # Print elements
	movl	-8(%rbp), %eax
	cltq # Mnemonic for move doubleword %eax to quadword %rax
	movl	-416(%rbp,%rax,4), %eax # Grab element from array
	movl	%eax, %esi 
	movl	$.LC0, %edi # Set print format
	movl	$0, %eax # Reset %eax
	call	printf # Print decimal
	addl	$1, -8(%rbp) # Increment by one the current element
.L4: # Check if all printed
	cmpl	$99, -8(%rbp) # Check if last element has been printed
	jle	.L5 # Print if not
	movl	$0, %eax # Reset %eax
	leave # %rsp is %rbp; then pop stack into %rbp
	.cfi_def_cfa 7, 8 # Take register 7 and add a offset of 8 to it
	ret
	.cfi_endproc # De-initializes call frame information and data structs
.LFE0: # Label for main function end
	.size	main, .-main # instruct assembler to write the size of main into its object file
	.ident	"GCC: (GNU) 12.1.1 20220628 (Red Hat 12.1.1-3)" # Set some metadata for current compiler version
	.section	.note.GNU-stack,"",@progbits # Sets compatibility with non-executable stacks
