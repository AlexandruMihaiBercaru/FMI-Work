.data
n: .space 4
formatcitire: .asciz "%ld"
formatafisare: .asciz "%ld\n"
.text
.global main

main:

pushl $n
pushl $formatcitire
call scanf
popl %ebx
popl %ebx

mov $1, %ecx

et_loop:
cmp n, %ecx
jg exit
movl n, %eax

xorl %edx, %edx
div %ecx
mov $0, %ebx
cmp %ebx, %edx
#restul impartirii nu este 0, adica %ecx nu este divizor al lui %eax
je estediv
add $1, %ecx
jmp et_loop

estediv:
push %ecx
push %ecx
push $formatafisare
call printf
add $8, %esp
pop %ecx
add $1, %ecx
jmp et_loop

exit:
movl $1, %eax
xorl %ebx, %ebx
int $0x80
