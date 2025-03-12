.data
	matrice_ext: .space 1600
	matrice_aux: .space 1600
	m: .space 4   #nr linii
	n: .space 4   #nr coloane
	lin_ext: .space 4
	col_ext: .space 4
	nr_el_mat_ext: .space 4
	p: .space 4   #nr celule vii
	k: .space 4   #nr evolutii
	index: .space 4
	jndex: .space 4
	index_k: .space 4
	stanga: .space 4
	dreapta: .space 4
	lung: .space 4
	mesaj: .space 100
	cript: .space 100
	sirascii: .space 100
	criptat: .space 100
	code: .space 4
	afishexa: .space 20
	byte_init: .space 1
	byte_modif: .space 1
	byte_aux: .space 1
	index_element: .space 4	
	formatcitire3s: .asciz "%ld%ld%ld"
	formatcitire: .asciz "%ld"
	formatafisare: .asciz "%ld "
	formatcitirestr: .asciz "%s"
	formatafisarestr: .asciz "%s\n"
	formatafisarehexa: .asciz "%X "
	afis0x: .asciz "0x"
	newline: .asciz "\n"

.text
.global main
main:

	pushl $p
	pushl $n
	pushl $m
	pushl $formatcitire3s
	call scanf
	add $16, %esp
	
	movl m, %eax
	addl $2, %eax
	movl %eax, lin_ext
	#numarul de linii din matricea extinsa = 2 + nr de linii
	movl n, %eax
	addl $2, %eax
	movl %eax, col_ext
	#numarul de coloane din matricea extinsa = 2 + nr de coloane
	
	movl lin_ext, %eax
	mull col_ext
	movl %eax, nr_el_mat_ext
	
	movl $0, index
	
	
	
citire_config_init:
	movl index, %ecx
	cmp %ecx, p
	je incep_iteratiile
		
	pushl $stanga
	pushl $formatcitire
	call scanf
	add $8, %esp
		
	pushl $dreapta
	pushl $formatcitire
	call scanf
	add $8, %esp
		
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
	call scanf
	add $8, %esp
	
	movl $0, index
	
	for_iteratie:
		movl index_k, %ecx
		cmp %ecx, k
		je cript_decript
		
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

cript_decript:
		
	pushl $code
	pushl $formatcitire
	call scanf
	add $8, %esp
	
	movl code, %ecx
	cmp $0, %ecx 
	
	jne DECRIPTARE #altfel face criptare
	
	CRIPTARE:
	
		pushl $mesaj
		pushl $formatcitirestr
		call scanf
		add $8, %esp
	
		lea mesaj, %esi
		movl $0, %ecx
		#calculez numarul de litere (lungimea mesajului)
		et_loop: 
			movb (%esi, %ecx, 1), %al
			cmp $0, %al
			je final_et
			incl %ecx
			jmp et_loop
	
		final_et:
		decl %ecx
		movl %ecx, lung
	
		xor_mat:
		
			movl $0, index
			movl $0, %ebx #indicele din matrice
		
			for_litera:
				movl index, %ecx      
				cmp lung, %ecx
				jg creare_sirhexa0
			
				lea mesaj, %esi
				movb (%esi, %ecx, 1), %al
				movb %al, byte_init
				movl $7, %ecx
				movb $0, byte_modif
			
				for_biti_litera:
					cmp $0, %ecx
					jl continuare_litera
					movl byte_init, %eax
					shr %ecx, %eax
					and $1, %eax
					#in al am bitul pe care vreau sa-l xorez
					cmp %ebx, nr_el_mat_ext
					jne xorare
					movl $0, %ebx
					xorare:
						lea matrice_ext, %edi
						movl (%edi, %ebx, 4), %edx
						xor %edx, %eax
						#in al am acum bitul xorat
						shl %ecx, %eax
						addb %al, byte_modif
				
					incl %ebx
					decl %ecx
					jmp for_biti_litera
				
				continuare_litera:
				lea cript, %edi
			
				movb byte_modif, %al
				movl index, %ecx
				movb %al, (%edi, %ecx, 1)
			
				incl index
				jmp for_litera
		
		#mesajul este modificat cu cheia de criptare, il pregatesc pentru afisare (il am in cript)
		creare_sirhexa0:

			lea cript, %esi
			lea afishexa, %edi
			movl $0, %ebx
			movl $0, index
	
		creare_sirhexa:
			movl index, %ecx
			cmp lung, %ecx
			jg afisare_cript
		
			movb (%esi, %ecx, 1), %al
			shr $4, %al
			cmp $10, %al
			jge cod_alpha
			addb $48, %al
			jmp adaugare
			cod_alpha:
				addb $55, %al
			adaugare:
				movb %al, (%edi, %ebx, 1)
				incl %ebx
		
			movb (%esi, %ecx, 1), %al
			and $15, %al
			cmp $10, %al
			jge cod_alpha2
			addb $48, %al
			jmp adaugare2
			cod_alpha2:
				addb $55, %al
			adaugare2:
				movb %al, (%edi, %ebx, 1)
				incl %ebx
	
			incl index
			jmp creare_sirhexa
		
		afisare_cript:
	
			pushl $afis0x
			pushl $formatcitirestr
			call printf
			add $8, %esp
		
			pushl $afishexa
			pushl $formatafisarestr
			call printf 
			add $8, %esp
		
			pushl $0
			call fflush
			add $4, %esp
	
			jmp et_exit



	DECRIPTARE:
	
		pushl $criptat
		pushl $formatcitirestr
		call scanf
		add $8, %esp
	
		lea criptat, %esi
		movl $0, %ecx
	
		et_loop_1:
			movb (%esi, %ecx, 1), %al
			cmp $0, %al
			je final_et_1
			incl %ecx
			jmp et_loop_1
	
		final_et_1:
		decl %ecx
		movl %ecx, lung
	

		lea criptat, %esi
		lea sirascii, %edi
		mov $2, %ecx #indicele pt ce este criptat 
		mov $0, %ebx #indicele pt mesajul clar
		
		creare_sir_normal:
			cmp lung, %ecx
			jg xorare_decript
		
			movl $0, byte_aux
			movb (%esi, %ecx, 1), %al
			cmp $'A', %al
			jge litera16
			subb $48, %al
			jmp adaugare3
			litera16:
				subb $55, %al
			adaugare3:
				shl $4, %al
				movb %al, byte_aux
				incl %ecx
		
			movb (%esi, %ecx, 1), %al
			cmp $'A', %al
			jge litera16_2
			subb $48, %al
			jmp adaugare4
			litera16_2:
				subb $55, %al
			adaugare4:
				addb %al, byte_aux
				incl %ecx
			
			movb byte_aux, %al
			movb %al, (%edi, %ebx, 1)
			incl %ebx
		
			jmp creare_sir_normal
			
		xorare_decript:
			movl %ebx, lung
			decl lung
			movl $0, index
			movl $0, %ebx #indicele din matrice
			
			for_byte:
			
				movl index, %ecx      
				cmp lung, %ecx
				jg afisare_clar
			
				lea sirascii, %esi
				movb (%esi, %ecx, 1), %al
				movb %al, byte_init
				movl $7, %ecx
				movb $0, byte_modif
			
				for_biti_ascii:
					cmp $0, %ecx
					jl cont_for_bytes
					movl byte_init, %eax
					shr %ecx, %eax
					and $1, %eax
					#in al am bitul pe care vreau sa-l xorez
					cmp %ebx, nr_el_mat_ext
					jne xorare_1
					movl $0, %ebx
					xorare_1:
						lea matrice_ext, %edi
						movl (%edi, %ebx, 4), %edx
						xor %edx, %eax
						#in al am acum bitul xorat
						shl %ecx, %eax
						addb %al, byte_modif
				
					incl %ebx
					decl %ecx
					jmp for_biti_ascii
				
				cont_for_bytes:
				lea mesaj, %edi
			
				movb byte_modif, %al
				movl index, %ecx
				movb %al, (%edi, %ecx, 1)
			
				incl index
				jmp for_byte
			
			afisare_clar:
			
				push $mesaj
				push $formatafisarestr
				call printf
				add $8, %esp
	
				pushl $0
				call fflush
				add $4, %esp
				
				
et_exit:
	pushl $0
	call fflush
	add $4, %esp
	
	mov $1, %eax
	xor %ebx, %ebx
	int $0x80

