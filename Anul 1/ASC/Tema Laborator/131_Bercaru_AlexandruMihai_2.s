.data
	matrice_ext: .space 1600
	matrice_aux: .space 1600
	m: .space 4   #nr linii
	n: .space 4   #nr coloane
	lin_ext: .space 4
	col_ext: .space 4
	p: .space 4   #nr celule vii
	k: .space 4   #nr evolutii
	index: .space 4
	jndex: .space 4
	index_k: .space 4
	stanga: .space 4
	dreapta: .space 4
	index_element: .space 4	
	filepointer: .space 4
	file_namein: .asciz "in.txt"
	file_nameout: .asciz "out.txt"
	modein: .asciz "r"
	modeout: .asciz "w"
	formatcitire3s: .asciz "%ld%ld%ld"
	formatcitire: .asciz "%ld"
	formatStr: .asciz "%s"
	formatafisare: .asciz "%ld "
	newline: .asciz "\n"

.text
.global main
main:
	
	pushl $modein
	pushl $file_namein
	call fopen
	add $8, %esp
	
	movl %eax, filepointer
	
	pushl $p
	pushl $n
	pushl $m
	pushl $formatcitire3s
	pushl filepointer
	call fscanf
	add $20, %esp
	
	movl m, %eax
	addl $2, %eax
	movl %eax, lin_ext
	#numarul de linii din matricea extinsa = 2 + nr de linii
	movl n, %eax
	addl $2, %eax
	movl %eax, col_ext
	#numarul de coloane din matricea extinsa = 2 + nr de coloane
	movl $0, index
	
citire_config_init:
	movl index, %ecx
	cmp %ecx, p
	je incep_iteratiile
		
	pushl $stanga
	pushl $formatcitire
	pushl filepointer
	call fscanf
	add $12, %esp
		
	pushl $dreapta
	pushl $formatcitire
	pushl filepointer
	call fscanf
	add $12, %esp
		
	incl stanga
	incl dreapta
		
	movl stanga, %eax
	mull col_ext
	addl dreapta, %eax
		
	lea matrice_ext, %edi
	movl $1, (%edi, %eax, 4)
		
	lea matrice_aux, %edi
	movl $1, (%edi, %eax, 4)
		
	incl index
	jmp citire_config_init
		
incep_iteratiile:

	pushl $k
	pushl $formatcitire
	pushl filepointer
	call fscanf
	add $12, %esp
	
	pushl filepointer
	call fclose
	add $4, %esp
	
	movl $0, index
	
	for_iteratie:
		movl index_k, %ecx
		cmp %ecx, k
		je afisare_config
		
		movl $1, index
		
		for_linii:
			movl index, %ecx
			cmp %ecx, m
			jl continuare_iteratie
			
			movl $1, jndex
			
			for_coloane:
				movl jndex, %ecx
				cmp %ecx, n
				jl continuare_linie
				
				movl index, %eax
				xor %edx, %edx
				mull col_ext
				addl jndex, %eax
				
				lea matrice_ext, %edi
				mov (%edi, %eax, 4), %ebx
				movl %eax, index_element
				
				#ma duc in NV -> N -> NE
				movl $0, %edx
				subl col_ext, %eax
				decl %eax
				mov (%edi, %eax, 4), %edx
				add 4(%edi, %eax, 4), %edx
				add 8(%edi, %eax, 4), %edx
				# (NE) -> E -> V
				addl col_ext, %eax
				add (%edi, %eax, 4), %edx
				add 8(%edi, %eax, 4), %edx
				# (V) -> SV -> S -> SE
				addl col_ext, %eax
				add (%edi, %eax, 4), %edx
				add 4(%edi, %eax, 4), %edx
				add 8(%edi, %eax, 4), %edx
				
				#aici calculez suma celor 8 vecini pentru fiecare element
				#daca celula curenta este vie, iar suma vecini <2 sau  >3, atunci aux[celula curenta] <- 0
				#daca celula curenta este moarta SI suma vecini ==3, atunci aux[celula curenta] <- 1
				cmp $0, %ebx
				je CELULA_MOARTA
					#ESTE VIE!
					cmp $2, %edx
					je continuare_coloane
					cmp $3, %edx
					je continuare_coloane
					movl index_element, %ebx
					lea matrice_aux, %edi
					movl $0, (%edi, %ebx, 4)
					jmp continuare_coloane
				CELULA_MOARTA:
					cmp $3, %edx
					jne continuare_coloane
					movl index_element, %ebx
					lea matrice_aux, %edi
					movl $1, (%edi, %ebx, 4)
					
				continuare_coloane:
				incl jndex
				jmp for_coloane
			
			continuare_linie:
			incl index
			jmp for_linii
			
		continuare_iteratie:
		#copiere din matricea auxiliara in matricea initiala
		movl $1, index
		
		for_linii_copiere:
			movl index, %ecx
			cmp %ecx, m
			jl continuare_iteratie_2
			movl $1, jndex
			
			for_coloane_copiere:
				movl jndex, %ecx
				cmp %ecx, n
				jl cont_linie_copiere
				#calculez indicele:
				movl index, %eax
				xor %edx, %edx
				mull col_ext
				addl jndex, %eax
				#mutarea efectiva:
				lea matrice_aux, %esi
				lea matrice_ext, %edi
				movl (%esi, %eax, 4), %ebx
				movl %ebx, (%edi, %eax, 4)
				
				incl jndex
				jmp for_coloane_copiere
				
				
			cont_linie_copiere:
			incl index
			jmp for_linii_copiere
		
		continuare_iteratie_2:
		incl index_k
		jmp for_iteratie


afisare_config:
	
	pushl $modeout
	pushl $file_nameout
	call fopen
	add $8, %esp
	
	movl %eax, filepointer
	
	movl $1, index
		
	for_linii_afisare:
		movl index, %ecx
		cmp %ecx, m
		jl et_exit
		movl $1, jndex
			
		for_coloane_afisare:
			movl jndex, %ecx
			cmp %ecx, n
			jl cont_linie_afisare
				
			movl index, %eax
			xor %edx, %edx
			mull col_ext
			addl jndex, %eax
				
			lea matrice_ext, %edi
			mov (%edi, %eax, 4), %ebx
				
			pushl %ebx
			pushl $formatafisare
			pushl filepointer
			call fprintf
			add $12, %esp
				
			pushl $0
			call fflush
			add $4, %esp
				
			incl jndex
			jmp for_coloane_afisare
				
		cont_linie_afisare:
		
		
		pushl $newline
		pushl $formatStr
		pushl filepointer
		call fprintf
		add $12, %esp
			
		incl index
		jmp for_linii_afisare
	
et_exit:
	pushl filepointer
	call fclose
	add $4, %esp
	
	mov $1, %eax
	xor %ebx, %ebx
	int $0x80

