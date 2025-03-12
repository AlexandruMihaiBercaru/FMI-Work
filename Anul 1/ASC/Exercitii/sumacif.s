.data
	x: .long 1472
	formats: .asciz "%d\n"
.text
suma_cifre:
	
	pushl %ebp
	movl %esp, %ebp
	#pushl %ebx
	movl 8(%ebp), %eax
	xorl %ecx, %ecx
	movl $10, %ebx
		
	suma_cifre_loop:
		
		cmp $0, %eax
		je suma_cifre_exit
		xorl %edx, %edx
		divl %ebx
		addl %edx, %ecx
		jmp suma_cifre_loop
			
suma_cifre_exit:
	#popl %ebx
	movl %ecx, %eax
	popl %ebp
	ret

.global main

main:

	pushl x
	call suma_cifre
	addl $4, %esp
	
	pushl %eax
	pushl $formats
	call printf
	addl $8, %esp
	
	movl $1, %eax
	xorl %ebx, %ebx
	int $0x80
	


			
		