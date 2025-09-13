extern malloc
extern free
extern fprintf

section .data

section .text

global strCmp
global strClone
global strDelete
global strPrint
global strLen

; ** String **

; int32_t strCmp(char* a, char* b)
strCmp:
	ret

; char* strClone(char* a)
;a --> rdi
strClone:
	.prologo:
	push rbp
	mov rbp, rsp
	push rbx		;me guardo un reg no volatil
	push r12

	;cuerpo
	mov rbx, rdi	;me guardo a en no volatil.


	call strLen		;eax = len(str) 

	mov r12d, eax	;r12d = len(str), este para iterar despues


	mov rdi, rax
	shl rdi, 32
	shr rdi, 32 ;Solucion actual para limpiar los 32 bits, hay otras 10 veces mejores
	inc rdi			;rdi = len(a) + 1, asi tengo el espacio del char nulo

	call malloc		;rax = *char a algun lado

	xor rcx, rcx ;rcx = 0, va a ser mi offset

	.ciclo:
	cmp byte [rbx], 0 ;While (char* a != NULL)
	je .epilogo

	mov r8, [rbx]
	mov [rax + rcx], r8 ;Pone en puntero + offset, lo que haya en el otro string
	inc rcx  	;offset++ , como tamos con char, tan uno al lado del otro.
	inc rbx		;puntero++, como es char, igual funca con 1.
	
	jmp .ciclo

	.epilogo:

	pop r12
	pop rbx
	pop rbp
	ret

; void strDelete(char* a)
strDelete:
	ret

; void strPrint(char* a, FILE* pFile)
strPrint:
	ret

; uint32_t strLen(char* a)
;a --> rdi 
strLen:
	.prologo:
	push rbp
	mov rbp, rsp

	;cuerpo
	xor eax, eax  ;res = 0

	.ciclo:
	cmp byte [rdi], 0  ;char* == 0
	je .epilogo

	inc eax ; res++
	inc rdi ; le sumo 1 byte asiq avanza en 1 con chars.
	jmp .ciclo


	.epilogo:
	pop rbp
	ret


