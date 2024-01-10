	# Initialize metadata of file 
  .file	"pointer.c" # Original source for debugger
	.text
	.section	.rodata # Read data, dont write
.LC0: # Create variable (reference) to given print form for integers
	.string	"%d \n"
.LC1: # Create variable (reference) to given print form for pointer address
	.string	"%p \n"
	.text
	.globl	main # Assembler directive to show scope of where this can be accessed for linker
	.type	main, @function # Declare function "main" for function invocation
main:
.LFB6: # Label for main function begin
	.cfi_startproc # Initialize call frame information for data struct
	pushq	%rbp # Push current state of base pointer into stack for previous calls
	.cfi_def_cfa_offset 16 # Sets jump offset of current stack pointer for call frame (16 bytes)
	.cfi_offset 6, -16 # Current val in register 6 (base ptr) is saved in instruction cfa - 16
	movq	%rsp, %rbp # Stack pointer to base pointer
	.cfi_def_cfa_register 6 # Set cfa's state to register 6's (base ptr)
	subq	$16, %rsp # Set space for locals of 16 bytes
	movl	$4, %edi # Set allocation of only 4-bytes
	call	malloc # Allocate memory in rax
	movq	%rax, -8(%rbp) # Store 8 bytes from current base pointer
	movq	-8(%rbp), %rax # Load point allocated to rax
	movl	$55, (%rax) # Place literal value 55 to be stored in pointer
	movq	-8(%rbp), %rax # Reset rax's state
	movl	(%rax), %eax # Store pointed value (55)
	movl	%eax, %esi # Place for printf
	movl	$.LC0, %edi # Set print format
	movl	$0, %eax
	call	printf
	movq	-8(%rbp), %rax # Restore as pointer
	movq	%rax, %rsi # Now place rax's (pointer) address in rsi for printf
	movl	$.LC1, %edi # Set pointed to (value 55's) address print
	movl	$0, %eax
	call	printf
	leaq	-8(%rbp), %rax # Set to pointer's address
	movq	%rax, %rsi 
	movl	$.LC1, %edi # Set print format to pointer address
	movl	$0, %eax
	call	printf
	movl	$0, %eax
	leave # Now place rax's (pointer) address in rsi for printf
	.cfi_def_cfa 7, 8 # Take register 7 and add a offset of 8 to it
	ret
	.cfi_endproc # De-initializes call frame information and data structs
.LFE6: # Label for main function end
	.size	main, .-main # instruct assembler to write the size of main into its object file
	.ident	"GCC: (GNU) 12.1.1 20220628 (Red Hat 12.1.1-3)" # Set some metadata for current compiler version
	.section	.note.GNU-stack,"",@progbits # Sets compatibility with non-executable stacks
