extern malloc

section .rodata
; Acá se pueden poner todas las máscaras y datos que necesiten para el ejercicio

section .text
; Marca un ejercicio como aún no completado (esto hace que no corran sus tests)
FALSE EQU 0
; Marca un ejercicio como hecho
TRUE  EQU 1

; Marca el ejercicio 1A como hecho (`true`) o pendiente (`false`).
;
; Funciones a implementar:
;   - es_indice_ordenado
global EJERCICIO_1A_HECHO
EJERCICIO_1A_HECHO: db TRUE ; Cambiar por `TRUE` para correr los tests.

; Marca el ejercicio 1B como hecho (`true`) o pendiente (`false`).
;
; Funciones a implementar:
;   - indice_a_inventario
global EJERCICIO_1B_HECHO
EJERCICIO_1B_HECHO: db TRUE ; Cambiar por `TRUE` para correr los tests.

;########### ESTOS SON LOS OFFSETS Y TAMAÑO DE LOS STRUCTS
; Completar las definiciones (serán revisadas por ABI enforcer):
ITEM_NOMBRE EQU 0
ITEM_FUERZA EQU 20 ;Deberia empezar a partir de18
ITEM_DURABILIDAD EQU 24
ITEM_SIZE EQU 28

;18b + 2 padding, 18 no es multiplo de 4 + 4b + 2b + 2 padding
;nos alineamos a uint32, osea, 4 bytes, deberia ser 26 packed, pero
;noesel caso,asiq, 28.

;; La funcion debe verificar si una vista del inventario está correctamente 
;; ordenada de acuerdo a un criterio (comparador)

;; bool es_indice_ordenado(item_t** inventario, uint16_t* indice, uint16_t tamanio, comparador_t comparador);

;; Dónde:
;; - `inventario`: Un array de punteros a ítems que representa el inventario a
;;   procesar.
;; - `indice`: El arreglo de índices en el inventario que representa la vista.
;; - `tamanio`: El tamaño del inventario (y de la vista).
;; - `comparador`: La función de comparación que a utilizar para verificar el
;;   orden.
;; 
;; Tenga en consideración:
;; - `tamanio` es un valor de 16 bits. La parte alta del registro en dónde viene
;;   como parámetro podría tener basura.
;; - `comparador` es una dirección de memoria a la que se debe saltar (vía `jmp` o
;;   `call`) para comenzar la ejecución de la subrutina en cuestión.
;; - Los tamaños de los arrays `inventario` e `indice` son ambos `tamanio`.
;; - `false` es el valor `0` y `true` es todo valor distinto de `0`.
;; - Importa que los ítems estén ordenados según el comparador. No hay necesidad
;;   de verificar que el orden sea estable.

global es_indice_ordenado
	; Te recomendamos llenar una tablita acá con cada parámetro y su
	; ubicación según la convención de llamada. Prestá atención a qué
	; valores son de 64 bits y qué valores son de 32 bits o 8 bits.
	;
	; item_t**     inventario   -> rdi
	; uint16_t*    indice		-> rsi
	; uint16_t     tamanio      -> dx
	; comparador_t comparador   -> rcx

es_indice_ordenado:
	.prologo:
	push rbp
	mov rbp, rsp
	push r12
	push r13
	push r14
	push r15
	push rbx 
	sub rsp, 8


	;cuerpo

	cmp dx, 1		;if (tamanio <= 1)
	jle .estanOrdenados

	mov r12, rdi	;inventario
	mov r13, rsi	;indice
	mov r14w, dx	;tamanio
	sub r14w, 1		;tamanio - 1
	mov r15, rcx	;comparador
	xor rbx, rbx    ;rbx = 0, es el iterador

	.ciclo:
	cmp bx, r14w	
	jge .estanOrdenados 	;Salta si bx >= tamanio-1

	xor rdx, rdx 				;dx = 0 porq no sabemos que tiene
	xor rcx, rcx 				;cx = 0 porq no sabemos que tiene
							;y necesitamos ambos para acceder a mem

	mov dx, [r13 + (rbx * 2)]		;dx = indiceActual = *(indice + i)
	mov cx, [r13 + (rbx * 2) + 2]	;cx = indiceSiguiente = *(indice + i + 1)

	mov rdi, [r12 + 8 * rdx]	;rdi = inventario[indiceActual]
	mov rsi, [r12 + 8 * rcx]	;rsi = inventario[indiceSiguiente]

	call r15				;al = comparador(itemActual,itemSiguiente)

	cmp al, 0				;if (!estaEnOrden)
	je .epilogo				;No tan ordenadas, y el 0 ya esta en al, asiq epilogo

	inc bx					;bx++
	jmp .ciclo 				;Empiezo de nuevo el ciclo

	.estanOrdenados:
	mov al, 1 ;Devuelvo 1 si ta ordenado, el bool pesa 1, asiq debe ser un uint8(?)

	.epilogo:

	add rsp, 8
	pop rbx
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbp 
	ret

;; Dado un inventario y una vista, crear un nuevo inventario que mantenga el
;; orden descrito por la misma.

;; La memoria a solicitar para el nuevo inventario debe poder ser liberada
;; utilizando `free(ptr)`.

;; item_t** indice_a_inventario(item_t** inventario, uint16_t* indice, uint16_t tamanio);

;; Donde:
;; - `inventario` un array de punteros a ítems que representa el inventario a
;;   procesar.
;; - `indice` es el arreglo de índices en el inventario que representa la vista
;;   que vamos a usar para reorganizar el inventario.
;; - `tamanio` es el tamaño del inventario.
;; 
;; Tenga en consideración:
;; - Tanto los elementos de `inventario` como los del resultado son punteros a
;;   `ítems`. Se pide *copiar* estos punteros, **no se deben crear ni clonar
;;   ítems**


;;Dado un inventario que es un array de punteros hacia los items, y un indice, 
;;que es un array de indices que tiene algun orden, tenemos que devolver un 
;;puntero a un array de punteros, donde el primer elemento sea el que esta 
;;en la posicion que indica el primer elemento de indice.

 

;item_t** indice_a_inventario(item_t** inventario, uint16_t* indice, uint16_t tamanio)

	; Te recomendamos llenar una tablita acá con cada parámetro y su
	; ubicación según la convención de llamada. Prestá atención a qué
	; valores son de 64 bits y qué valores son de 32 bits o 8 bits.
	;
	; item_t**     inventario   -> rdi
	; uint16_t*    indice		-> rsi
	; uint16_t     tamanio      -> dx

global indice_a_inventario
indice_a_inventario:
.prologo:
	push rbp
	mov rbp, rsp
	push r12
	push r13
	push r14
	push rbx
	;cuerpo

	mov r12, rdi	;inventario
	mov r13, rsi	;indice
	xor r14w, r14w  ;=0 por la vida
	mov r14w, dx	;tamanio
	

	imul dx, dx, 8	;tamanio * 8 para que sea de punteros
	xor rdi, rdi ;por cuestiones de la vida, rdi = 0
	mov di, dx   ;di = tamanio * 8,para el malloc

	call malloc	;rax = item** resultado

	xor rbx, rbx ; rbx = 0,iterador

	.ciclo:
	cmp bx, r14w	
	jge .epilogo 	;Salta si bx >= tamanio

	xor rdi, rdi ; rdi = 0 pa usarlo

	mov di, [r13 + (rbx * 2)] ;rdi es indice actual de indices
	mov rsi, [r12 + (rdi * 8)] ;rsi es puntero al item que quiero
	mov [rax + (rbx * 8)], rsi

	inc bx					;bx++
	jmp .ciclo 				;Empiezo de nuevo el ciclo

.epilogo:

	pop rbx
	pop r14
	pop r13
	pop r12
	pop rbp 
	ret



