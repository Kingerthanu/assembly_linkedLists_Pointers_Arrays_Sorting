	.file	"sort.c" # Name of Source file making assembly
	.text
	.section	.rodata
.LC0: # Print index -> value
	.string	"%d --> %d\n"
	.text
	.globl	printarr
	.type	printarr, @function # Create printarr
printarr:
.LFB6:
	.cfi_startproc # Initialize call frame information for data struct
	pushq	%rbp
	.cfi_def_cfa_offset 16 # Sets jump offset of current stack pointer for call frame (16 bits)
	.cfi_offset 6, -16 # Current val in register 6 (base ptr) is saved in instruction cfa - 16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6 # Set cfa's state to register 6's (base ptr)
	subq	$32, %rsp # Allocate 32 bytes of space on the stack
	movq	%rdi, -24(%rbp) # Store passed function variables (array)
	movl	%esi, -28(%rbp) # Array size
	movl	$0, -8(%rbp)
	jmp	.L2
.L3: # Print result | Maybe a precondition function before printing?
	movl	-8(%rbp), %eax # Grab loop counter
	cltq  # Mnemonic for move doubleword %eax to quadword %rax (inflating it to 64 bits in size to allow for index)
	leaq	0(,%rax,4), %rdx # Grab element in steps of 4 bytes
	movq	-24(%rbp), %rax # Move base address of array into rax
	addq	%rdx, %rax # Grab current array element's address
	movl	(%rax), %eax # Grabs array element 
	movl	%eax, -4(%rbp) # Stores array element from print
	movq	stdout(%rip), %rax
	movl	-4(%rbp), %ecx # Set values for printing
	movl	-8(%rbp), %edx
	leaq	.LC0(%rip), %rsi # Grab string
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf@PLT # Print
	addl	$1, -8(%rbp) # Step one into counter
.L2:
	movl	-8(%rbp), %eax # Grab loop count
	cmpl	-28(%rbp), %eax # Check if reached end
	jl	.L3 # If not, go print
	nop # No operation, conclude function if not at end?
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE6:
	.size	printarr, .-printarr # Set size of function during end of call
	.section	.rodata
.LC1: 
	.string	"Presorted order:\n" 
.LC2:
	.string	"\nSorted order:\n"
	.text
	.globl	main
	.type	main, @function # Set main as function
main:
.LFB7:
	.cfi_startproc # Initialize call frame information for data struct
	pushq	%rbp
	.cfi_def_cfa_offset 16 # Sets jump offset of current stack pointer for call frame (16 bits)
	.cfi_offset 6, -16 # Current val in register 6 (base ptr) is saved in instruction cfa - 16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6 # Set cfa's state to register 6's (base ptr)
	pushq	%r12
	pushq	%rbx
	subq	$64, %rsp # Set 64 bytes of local variable space
	.cfi_offset 12, -24
	.cfi_offset 3, -32
	movl	%edi, -68(%rbp) # Grab arr length
	movq	%rsi, -80(%rbp) # Grab arr content
	movq	%fs:40, %rax # Save previous stack value?
	movq	%rax, -24(%rbp)
	xorl	%eax, %eax
	movq	%rsp, %rax
	movq	%rax, %r12 # Store away stack pointer
	movl	$1, -60(%rbp) # Set count equal to one  
	movl	-68(%rbp), %eax # Grab index one element
	subl	$1, %eax # Go back to 0'th element
	movl	%eax, -52(%rbp) # Store this element away
	movl	-52(%rbp), %eax # Grab this index of realigned element
	movslq	%eax, %rdx
	subq	$1, %rdx
	movq	%rdx, -40(%rbp) # Move element
	movslq	%eax, %rdx
	movq	%rdx, %r8
	movl	$0, %r9d
	movslq	%eax, %rdx
	movq	%rdx, %rcx
	movl	$0, %ebx
	cltq # expand eax for indexing of array
	leaq	0(,%rax,4), %rdx # Grab first element offset?
	movl	$16, %eax
	subq	$1, %rax
	addq	%rdx, %rax # Grab element using offset
	movl	$16, %ebx
	movl	$0, %edx
	divq	%rbx
	imulq	$16, %rax, %rax # Adjust stack size by 16 and square result?
	subq	%rax, %rsp
	movq	%rsp, %rax
	addq	$3, %rax
	shrq	$2, %rax
	salq	$2, %rax
	movq	%rax, -32(%rbp) # Set adjustments to varibale for later usage
	jmp	.L6
.L7:  # Re-sort
	movl	-60(%rbp), %eai # Counter
	cltq  # Extend to 64 bit
	leaq	0(,%rax,8), %rdx  # Grab element index
	movq	-80(%rbp), %rax # Base index
	addq	%rdx, %rax # Get element
	movq	(%rax), %rax
	movl	-60(%rbp), %edx # Grab counter
	leal	-1(%rdx), %ebx
	movq	%rax, %rdi # Set current val to atoi
	call	atoi@PLT
	movq	-32(%rbp), %rdx
	movslq	%ebx, %rcx
	movl	%eax, (%rdx,%rcx,4) # Replace back in proper spot in new array
	addl	$1, -60(%rbp) # Add one to counter
.L6: # Swap unsorted elements and print them
	movl	-60(%rbp), %eax # Grab loop counter
	cmpl	-68(%rbp), %eax # Check if counter is
	jl	.L7 # If less, resort next element
	movl	$0, -60(%rbp) # Reset counter
	movl	$0, -48(%rbp)
	movq	stdout(%rip), %rax
	movq	%rax, %rcx
	movl	$17, %edx
	movl	$1, %esi
	leaq	.LC1(%rip), %rax # Load print format to rax
	movq	%rax, %rdi
	call	fwrite@PLT # Write for print
	movl	-52(%rbp), %edx
	movq	-32(%rbp), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	call	printarr # Print arr element
	movq	stdout(%rip), %rax
	movq	%rax, %rcx
	movl	$15, %edx
	movl	$1, %esi
	leaq	.LC2(%rip), %rax
	movq	%rax, %rdi
	call	fwrite@PLT
	movl	$1, -60(%rbp) # Step loop counter to 1
	jmp	.L8
.L12: # Store previous tmp
	movl	-60(%rbp), %eax # Grab counter
	movl	%eax, -56(%rbp) # Place old counter
	jmp	.L9
.L11: # Swap values of two elements
	movq	-32(%rbp), %rax # Grab stored away arr size 
	movl	-56(%rbp), %edx # Grab stored away arr ele base
	movslq	%edx, %rdx
	movl	(%rax,%rdx,4), %eax # Grab arr element
	movl	%eax, -44(%rbp) # Store element
	movl	-56(%rbp), %eax # Grab current element index
	leal	-1(%rax), %edx  # Remove one from index
	movq	-32(%rbp), %rax
	movslq	%edx, %rdx
	movl	(%rax,%rdx,4), %ecx # Grab element  
	movq	-32(%rbp), %rax
	movl	-56(%rbp), %edx
	movslq	%edx, %rdx
	movl	%ecx, (%rax,%rdx,4) # Swap element?
	movl	-56(%rbp), %eax # Grab index
	leal	-1(%rax), %edx # Index one less
	movq	-32(%rbp), %rax 
	movslq	%edx, %rdx
	movl	-44(%rbp), %ecx # Return tmp held
	movl	%ecx, (%rax,%rdx,4)
	subl	$1, -56(%rbp) # Deincrmeent index by one
.L9: # Grab values for printing
	cmpl	$0, -56(%rbp) # If element one
	jle	.L10 # If not element one or is
	movl	-56(%rbp), %eax
	leal	-1(%rax), %edx # Remove one from rax address and set to edx
	movq	-32(%rbp), %rax # Grab element index
	movslq	%edx, %rdx
	movl	(%rax,%rdx,4), %ecx # Grab element
	movq	-32(%rbp), %rax # Grab index  
	movl	-56(%rbp), %edx # Grab element val
	movslq	%edx, %rdx 
	movl	(%rax,%rdx,4), %eax # Grab next up element?
	cmpl	%eax, %ecx
	jg	.L11
.L10: # Increment loop
	addl	$1, -60(%rbp) # Increment loop counter
.L8: # Print element
	movl	-60(%rbp), %eax # loop counter
	cmpl	-52(%rbp), %eax # Check if counter is less than arr length
	jl	.L12 # If less than arr length
	movl	-52(%rbp), %edx # Grab element val
	movq	-32(%rbp), %rax # Grab element index
	movl	%edx, %esi
	movq	%rax, %rdi # Move values for printing in arguments of printarr
	call	printarr # Print element
	movl	$0, -60(%rbp) # Set count to 0
	movl	$0, %eax
	movq	%r12, %rsp # Restore stack ptr
	movq	-24(%rbp), %rdx
	subq	%fs:40, %rdx
	je	.L14
	call	__stack_chk_fail@PLT # Error call if seg fault?
.L14: # Conclude and restore
	leaq	-16(%rbp), %rsp # Set stack pointer to 16 bytes below base pointer 
	popq	%rbx
	popq	%r12 # Restore used registers
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE7:
	.size	main, .-main
	.ident	"GCC: (GNU) 12.2.1 20230201"
	.section	.note.GNU-stack,"",@progbits
