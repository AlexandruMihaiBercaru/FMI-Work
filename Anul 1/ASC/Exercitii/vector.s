.data
	v: .space 20
	n: .long 5
.text
.global main
main:
	lea v, %edi
	mov $11, %edx
	mov $0, %ecx
et_loop:
	cmp n, %ecx
	jg et_exit
	mov %edx, (%edi, %ecx, 4)
	inc %ecx
	inc %edx
	jmp et_loop
et_exit:
	mov $1, %eax
	xor %ebx, %ebx
	int $0x80
	

