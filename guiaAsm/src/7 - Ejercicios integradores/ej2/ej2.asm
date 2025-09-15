extern malloc
extern free


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
;   - optimizar
global EJERCICIO_2A_HECHO
EJERCICIO_2A_HECHO: db TRUE ; Cambiar por `TRUE` para correr los tests.

; Marca el ejercicio 1B como hecho (`true`) o pendiente (`false`).
;
; Funciones a implementar:
;   - contarCombustibleAsignado
global EJERCICIO_2B_HECHO
EJERCICIO_2B_HECHO: db FALSE ; Cambiar por `TRUE` para correr los tests.

; Marca el ejercicio 1C como hecho (`true`) o pendiente (`false`).
;
; Funciones a implementar:
;   - modificarUnidad
global EJERCICIO_2C_HECHO
EJERCICIO_2C_HECHO: db FALSE ; Cambiar por `TRUE` para correr los tests.

;########### ESTOS SON LOS OFFSETS Y TAMAÑO DE LOS STRUCTS
; Completar las definiciones (serán revisadas por ABI enforcer):
ATTACKUNIT_CLASE EQU 0
ATTACKUNIT_COMBUSTIBLE EQU 12
ATTACKUNIT_REFERENCES EQU 14
ATTACKUNIT_SIZE EQU 16

MAP_SIZE EQU 255*255

; 11b + 1padding + 2b + 1b + 1padding = 16b

	; Te recomendamos llenar una tablita acá con cada parámetro y su
	; ubicación según la convención de llamada. Prestá atención a qué
	; valores son de 64 bits y qué valores son de 32 bits o 8 bits.
	;
	; mapa_t           mapa  					--> rdi
	; attackunit_t*    compartida				--> rsi
	; uint32_t*        fun_hash(attackunit_t*)  --> rdx
global optimizar
optimizar:
	.prologo:
	push rbp
	mov rbp, rsp
	push rdi					; mapa en [rbp - 8]
	push r12					; La usamos pa guardar mapa[i][j]
	push r13
	push r14
	push r15
	push rbx

	;cuerpo

	mov r13, rsi				; r13 = compartida
	mov r14, rdx				; r14 = hashFoo
	xor r15, r15				; r15 = 0 = i , iterador

	mov rdi, r13				; Paso "compartida" a x1 para hash(x1)
	call r14					; eax = hash de compartida

	and eax, 0xffffffff			; Limpiamos 32 bits altos
	mov rbx, rax				; rbx = hash(compartida)

	.cicloDeI:
	cmp r15, MAP_SIZE			; while (r15 < 255 * 255)
	jge .epilogo

	mov rdi, [rbp - 8]			; rdi = mapa
	mov rax, [rdi + r15* 8]	 	; rax = mapa[i][j] temporal
	mov r12, rax				; r12 = mapa[i][j]

	cmp rax, 0				    ; if (mapa[i][j] == NULL) then continue
	je .finCiclo

	call r14					; eax = hash(mapa[i][j])

	cmp eax, ebx				
	jne .finCiclo				; if (hash(mapa[i][j] == hash(compartida)))

	cmp r13, r12				; if (compartida != mapa[i][j])
	je .noFree					

	mov dil, [r12 + ATTACKUNIT_REFERENCES]	;dil = mapa[i][j].references
	cmp dil, 1
	jne .noFree					; if (mapa[i][j].references == 1)

	mov rdi, r12				; paso mapa[i][j] a x1 pa llamar a free(x1)
	call free

	.noFree:
	sub byte [r12 + ATTACKUNIT_REFERENCES], 1 ;mapa[i][j].references - 1
	mov rdi, [rbp - 8]			; rdi = mapa
	mov [rdi + r15*8], r13		; mapa[i][j] = compartida
	add byte [r13 + ATTACKUNIT_REFERENCES], 1 ;compartida.references++


	.finCiclo:
	inc r15
	jmp .cicloDeI



	.epilogo:

	pop rbx
	pop r15
	pop r14
	pop r13
	pop r12
	pop rdi
	pop rbp
	ret

global contarCombustibleAsignado
contarCombustibleAsignado:
	; r/m64 = mapa_t           mapa
	; r/m64 = uint16_t*        fun_combustible(char*)
	ret

global modificarUnidad
modificarUnidad:
	; r/m64 = mapa_t           mapa
	; r/m8  = uint8_t          x
	; r/m8  = uint8_t          y
	; r/m64 = void*            fun_modificar(attackunit_t*)
	ret
