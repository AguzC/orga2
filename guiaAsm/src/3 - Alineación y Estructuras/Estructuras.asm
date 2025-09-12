
;########### ESTOS SON LOS OFFSETS Y TAMAÑO DE LOS STRUCTS
; Completar las definiciones (serán revisadas por ABI enforcer):
NODO_OFFSET_NEXT EQU 0
NODO_OFFSET_CATEGORIA EQU 8
NODO_OFFSET_ARREGLO EQU 16
NODO_OFFSET_LONGITUD EQU 24
NODO_SIZE EQU 32
; 8(puntero) + 1(8 bits) + 7 (padding) + 8(arreglo*)+ 4 (32 bits) = 28
; y el tipo mas grande aca es el puntero, el struct se alinea a 8, asiq
; hay 4 de padding y pesa 32

PACKED_NODO_OFFSET_NEXT EQU 0
PACKED_NODO_OFFSET_CATEGORIA EQU 8
PACKED_NODO_OFFSET_ARREGLO EQU 9
PACKED_NODO_OFFSET_LONGITUD EQU 17
PACKED_NODO_SIZE EQU 21
LISTA_OFFSET_HEAD EQU 0
LISTA_SIZE EQU 8
PACKED_LISTA_OFFSET_HEAD EQU 0
PACKED_LISTA_SIZE EQU 8

;########### SECCION DE DATOS
section .data

;########### SECCION DE TEXTO (PROGRAMA)
section .text

;########### LISTA DE FUNCIONES EXPORTADAS
global cantidad_total_de_elementos
global cantidad_total_de_elementos_packed

;########### DEFINICION DE FUNCIONES
;extern uint32_t cantidad_total_de_elementos(lista_t* lista);
;registros: 
;lista --> rdi

cantidad_total_de_elementos:
	.prologo:
	push rbp
	mov rbp, rsp

	;chequeo de null pointer
	cmp rdi, 0
	jne .noVacia ;Salta si no es Null.
	mov eax, 0	 ;Digo que tiene 0 elementos   
	jmp .epilogo  ;Uso la condicion negada para saltar al final

	.noVacia: ;
	mov rsi, [rdi] ; RSI = nodo* head
	xor eax, eax  ; Setteo el resultado a 0

	.ciclo:
	cmp rsi, 0
	je .epilogo ; while (!(rsi == NULL)) 

	add eax, [rsi + NODO_OFFSET_LONGITUD] 
	mov rsi, [rsi + NODO_OFFSET_NEXT]

	jmp .ciclo

	.epilogo:
	pop rbp
	ret

;extern uint32_t cantidad_total_de_elementos_packed(packed_lista_t* lista);
;registros: lista[rdi]
cantidad_total_de_elementos_packed:
		.prologo:
	push rbp
	mov rbp, rsp

	;chequeo de null pointer
	cmp rdi, 0
	jne .noVacia ;Salta si no es Null.
	mov eax, 0	 ;Digo que tiene 0 elementos   
	jmp .epilogo  ;Uso la condicion negada para saltar al final

	.noVacia: ;
	mov rsi, [rdi] ; RSI = nodo* head
	xor eax, eax  ; Setteo el resultado a 0

	.ciclo:
	cmp rsi, 0
	je .epilogo ; while (!(rsi == NULL)) 

	add eax, [rsi + PACKED_NODO_OFFSET_LONGITUD] 
	mov rsi, [rsi + PACKED_NODO_OFFSET_NEXT]

	jmp .ciclo

	.epilogo:
	pop rbp
	ret



