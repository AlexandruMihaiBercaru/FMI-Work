.data
n: .long 4
fs: .asciz "%ld! = %ld\n"

.text
factorial:

push %ebp
mov %esp, %ebp
push %ebx

mov 8(%ebp), %eax
mov $1, %ebx

cmp %ebx, %eax
jle stop

dec %eax
push %eax
call factorial

#eax = factorial (n-1)

add $4, %esp

mov 8(%ebp), %ebx

#ebx = n, eax = factorial(n-1)

mul %ebx  # eax <- ebx* eax = n * factorial (n-1)

jmp final 

stop:
mov $1, %eax

final:
pop %ebx
pop %ebp
ret

.global main

main:

pushl n
call factorial
add $4, %esp

#am in eax = factorial (n)

push %eax
pushl n
push $fs
call printf
add $12, %esp

mov $1, %eax
xor %ebx, %ebx
int $0x80
