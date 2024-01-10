	# Initialize metadata of file 
	.file	"linked.c" # Original source for debugger
	.text
	.section	.rodata # Read data, dont write
.LC0: # Create variable (reference) to given print form for integers
	.string	"%d \n"
	.text
	.globl	main # Assembler directive to show scope of where this can be accessed for linker 
	.type	main, @function # Declare function "main" for function invocation
main:
.LFB6: # Label for main function begin
	.cfi_startproc # Initialize call frame information for data struct
	pushq	%rbp # Push current state of base pointer into stack for previous calls
	.cfi_def_cfa_offset 16 # Sets jump offset of current stack pointer for call frame (16 bits)
	.cfi_offset 6, -16 # Current val in register 6 (base ptr) is saved in instruction cfa - 16
	movq	%rsp, %rbp # Stack pointer to base pointer
	.cfi_def_cfa_register 6 # Set cfa's state to register 6's (base ptr)
	subq	$32, %rsp # 32 bytes allocated for local vals
	movl	$16, %edi # Allocates 16 bytes for malloc
	call	malloc # Allocate memory in rax
	movq	%rax, -24(%rbp) # Store this allocated spot 24 bytes below rbp
	movq	-24(%rbp), %rax # Set rax to this spot 24 bytes below base ptr
	movq	%rax, -8(%rbp) # Set val of rax 8 bytes below base ptr
	movl	$0, -12(%rbp)
	jmp	.L2 # Go create links
.L3:	# Allocating
	movl	$16, %edi # Set 16-bytes for malloc
	call	malloc # Allocate memory in rax
	movq	%rax, %rdx # Store alloc spot in rdx
	movq	-8(%rbp), %rax # Set rax to 8-bytes below rax
	movq	%rdx, 8(%rax) # Place alloc spot in rdx to 8-bytes above rax (next spot in its memory; creating a link)
	movq	-8(%rbp), %rax # Maybe redunant
	movl	-12(%rbp), %edx # Grab loop count
	movl	%edx, (%rax)	# Place count into link 
	movq	-8(%rbp), %rax
	movq	8(%rax), %rax # Grab next link
	movq	%rax, -8(%rbp) # Set as next link
	addl	$1, -12(%rbp) # Add 1 12 below rbp for end check
.L2: # Check if all links made
	cmpl	$3, -12(%rbp) # Check link count
	jle	.L3
	movq	-24(%rbp), %rax # Grab link
	movq	%rax, -8(%rbp) # Reorientate link to 8 bytes below rbp
	movl	$0, -16(%rbp) # Set this as counter for prints in L4
	jmp	.L4
.L5: # Print contents
	movq	-8(%rbp), %rax # Grab link
	movl	(%rax), %eax
	movl	%eax, %esi # Tmp swap for printf args
	movl	$.LC0, %edi
	movl	$0, %eax 
	call	printf # Print link
	movq	-8(%rbp), %rax # Redunant
	movq	8(%rax), %rax # Redunant
	movq	%rax, -8(%rbp) # Set rax (rbp alias) 8 bytes below rbp
	addl	$1, -16(%rbp) # Increment for print count check
.L4:  # Check if all links printed
	cmpl	$3, -16(%rbp) # Check if all have been printed
	jle	.L5
	movl	$0, %eax # Reset
	leave # %rsp is %rbp; then pop stack into %rbp
	.cfi_def_cfa 7, 8 # Take register 7 and add a offset of 8 to it
	ret
	.cfi_endproc # De-initializes call frame information and data structs
.LFE6: # Label for main function end
	.size	main, .-main # instruct assembler to write the size of main into its object file
	.ident	"GCC: (GNU) 12.1.1 20220628 (Red Hat 12.1.1-3)" # Set some metadata for current compiler version
	.section	.note.GNU-stack,"",@progbits # Sets compatibility with non-executable stacks
