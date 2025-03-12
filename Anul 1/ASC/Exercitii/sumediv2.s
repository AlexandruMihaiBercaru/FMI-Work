.data
	n: .long 6
	v: .long 5, 10, 9, 8, 7, 6
	nr: .long 0
	formatafisare: .asciz "%d\n"
.text

divizibil_cu_2:
	pushl %ebp
	mov %esp, %ebp
	
	movl 8(%ebp), %edi
	addl 12(%ebp), %edi
	movl %edi, %eax
	movl $0, %edx
	movl $2, %ebx
	divl %ebx
	movl %edx, %eax
	popl %ebp
	ret

.global main

main:
	
	movl $1, %edx
	lea v, %esi
	subl $1, n
	
et_loop:
	cmp n, %edx
	jg exit
	movl (%esi, %edx, 4), %eax
	movl -4(%esi, %edx, 4), %ebx
	pushl %edx
	pushl %eax
	pushl %ebx
	call divizibil_cu_2
	pop %ebx
	pop %ebx
	popl %edx
	addl %eax, nr
	inc %edx
	jmp et_loop
	
exit:
	 
	pushl nr
	pushl $formatafisare
	call printf
	add $8, %esp
	
	pushl $0
	call fflush
	add $4, %esp
	
	mov $1, %eax
	xor %ebx, %ebx
	int $0x80
	