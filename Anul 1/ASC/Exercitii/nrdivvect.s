.data
n: .space 4 
element: .space 4
v: .space 400
t: .space 400
numar: .space 4
index: .space 4
i: .space 4
divizori: .space 4
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
	je parcurgere

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
	
parcurgere:
	movl $0, index
	
	calc_t:
		movl index, %ecx
		cmp n, %ecx
		je afisare_t		
		lea v, %esi
		mov (%esi, %ecx, 4), %eax
		movl %eax, numar
		movl $2, i
		movl $1, divizori
		
		parcurgere_numar:
			movl i, %ecx
			cmp numar, %ecx
			jg incarcare_nrdiv
			mov numar, %eax
			xor %edx, %edx
			movl i, %ebx
			divl %ebx
			cmp $0, %edx # i este divizor al lui n
			
			je adaugare_nrdiv
			incl i
			jmp parcurgere_numar
			
			adaugare_nrdiv:
			incl divizori
			incl i
			jmp parcurgere_numar
			
		incarcare_nrdiv:
		lea t, %edi
		movl divizori, %ebx
		movl index, %ecx
		movl %ebx, (%edi, %ecx, 4)
	
		incl index
		jmp calc_t
			
afisare_t:
	movl $0, index
	parc_loop:
		movl index, %ecx
		cmp n, %ecx
		je pregatire_afisare
		lea t, %esi
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
			