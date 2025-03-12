.data
n: .space 4 
element: .space 4
v: .space 400
index: .space 4
formatcitire: .asciz "%ld"
formatafisare: .asciz "%ld "
NewLine: .asciz "\n"
.text
.global main

main:

	pushl $n
	pushl $formatcitire
	call scanf
	popl %ebx
	popl %ebx

	movl $0, index

et_loop:
	movl index, %ecx
	cmp n, %ecx
	je testare_paritate

#citesc rand pe rand elementele vectorului
	pushl $element
	pushl $formatcitire
	call scanf
	popl %ebx
	popl %ebx

#incarc in memorie
	lea v, %edi
	movl element, %eax
	movl index, %ecx
	movl %eax, (%edi, %ecx, 4)
	
	incl index
	jmp et_loop


testare_paritate:
	movl $0, index
#parcurg si vad care sunt pare

	parc_loop:
		movl index, %ecx
		cmp n, %ecx
		je pregatire_afisare
		lea v, %esi
		movl (%esi, %ecx, 4), %edx
		and $1, %edx
		jz afis_par
		incl index
		jmp parc_loop

	afis_par:
		lea v, %esi
		movl (%esi, %ecx, 4), %edx
		pushl %edx
		pushl $formatafisare
		call printf
		popl %ebx
		popl %ebx
		incl index
		jmp parc_loop

pregatire_afisare:
	pushl $NewLine
	call printf
	popl %ebx
	pushl $0
	call fflush
	popl %ebx
	mov $1, %eax
	xorl %ebx, %ebx
	int $0x80
