extern malloc 
extern free

;########### SECCION DE DATOS
section .data

;########### SECCION DE TEXTO (PROGRAMA)
section .text

; Completar las definiciones (serán revisadas por ABI enforcer):
USUARIO_ID_OFFSET EQU 0
USUARIO_NIVEL_OFFSET EQU 4
USUARIO_SIZE EQU 8

CASO_CATEGORIA_OFFSET EQU 0  ;Va de 0 a 2,asiq 3, pero +1 padding
CASO_ESTADO_OFFSET EQU 4
CASO_USUARIO_OFFSET EQU 8    ;2 de padding, 4 + 2= 6, 6 no es multiplo de 8
CASO_SIZE EQU 16

SEGMENTACION_CASOS0_OFFSET EQU 0
SEGMENTACION_CASOS1_OFFSET EQU 8
SEGMENTACION_CASOS2_OFFSET EQU 16
SEGMENTACION_SIZE EQU 24

ESTADISTICAS_CLT_OFFSET EQU 0
ESTADISTICAS_RBO_OFFSET EQU 1
ESTADISTICAS_KSC_OFFSET EQU 2
ESTADISTICAS_KDT_OFFSET EQU 3
ESTADISTICAS_ESTADO0_OFFSET EQU 4
ESTADISTICAS_ESTADO1_OFFSET EQU 5
ESTADISTICAS_ESTADO2_OFFSET EQU 6
ESTADISTICAS_SIZE EQU 7


;uint32_t contar_casos_por_nivel(caso_t* arreglo_casos, uint32_t largo, uint32_t nivel) 
;arreglo_casos --> rdi, no los modifiquemos
;largo         --> esi
;nivel         --> edx
global contar_casos_por_nivel
contar_casos_por_nivel:
    ;prologo
    push rbp
    mov rbp, rsp
    push r12
    push r13

    ;cuerpo
    mov rax, 0   ; rax = res = 0

    cmp esi, 0      ;largo == 0 termino
    je .epilogo

    xor r9, r9  ; r9 es mi iterador, lo pongo en 0

    .ciclo:
    cmp r9d, esi
    jge .epilogo   ;for(r9 = 0; r9 < esi; r9++) {

    xor r12, r12 ; r12 = 0
    mov r12,r9   ; r12 =  r9 = valorIteradorActual
    imul r12, CASO_SIZE ; r12 = valorIteradorActual * CASO_SIZE

    mov rcx, [rdi + r12 + CASO_USUARIO_OFFSET];arreglo_casos[i].usuario*

    mov r8d, [rcx + USUARIO_NIVEL_OFFSET] ; usuario.nivel

    cmp r8d, edx            ;if nivel == usuario.nivel
    jne .saltoNivelDistinto
    inc eax                 ;res++

    .saltoNivelDistinto:
    inc r9
    jmp .ciclo     ;    }

    .epilogo:
    pop r13
    pop r12
    pop rbp
    ret


;Libres: rcx y r8
;rcx =  puntero al usuario del caso actual
;r8  =  nivel del usuario actual


;segmentacion_t* segmentar_casos(caso_t* arreglo_casos, int largo)
;arreglo_casos --> rdi
;largo         --> esi

global segmentar_casos
segmentar_casos:

    ;prologo
    push rbp
    mov rbp, rsp
    push rbx
    push r12
    push r13    
    push r14    
    push r15    
    sub rsp, 8

    ;cuerpo

    mov rbx, rdi                   ;rbx  = arreglo_casos
    mov r12d, esi                  ;r12d = largo

    mov rdi, rbx
    mov esi, r12d
    mov edx, 0
    call contar_casos_por_nivel
    xor r13, r13
    mov r13d, eax ;r13 = contar_casos_por_nivel(rdi,esi,0)

    mov rdi, rbx
    mov esi, r12d
    mov edx, 1
    call contar_casos_por_nivel
    xor r14, r14
    mov r14d, eax ;r14 = contar_casos_por_nivel(rdi,esi,1)
    
    mov rdi, rbx
    mov esi, r12d
    mov edx, 2
    call contar_casos_por_nivel
    xor r15, r15
    mov r15d, eax ;r15 = contar_casos_por_nivel(rdi,esi,2)

    ;------------------------------------------------------TestFuncionalidad
    ;En principio, okey

    xor rdi, rdi
    mov rdi, r13        ;rdi = contarCasos...
    cmp rdi, 0
    je .mallocCasoNivel1;if (casosNivel0 != 0)
    imul rdi, CASO_SIZE ;casosNivelX * CASO_SIZE = tam array de casos
    call malloc         ;malloc(rdi), rdi es el puntero ahora
    mov r13, rax        ;r13 deja de ser el casosNivel0 y pasa a ser 
                        ;el puntero al array de nivel 0

    .mallocCasoNivel1:

    xor rdi, rdi
    mov rdi, r14        ;rdi = contarCasos...
    cmp rdi, 0
    je .mallocCasoNivel2;if (casosNivel1 != 0)
    imul rdi, CASO_SIZE ;casosNivelX * CASO_SIZE = tam array de casos
    call malloc         ;malloc(rdi), rdi es el puntero ahora
    mov r14, rax        ;r14 deja de ser el casosNivel0 y pasa a ser 
                        ;el puntero al array de nivel 1

    .mallocCasoNivel2:

    xor rdi, rdi
    mov rdi, r15        ;rdi = contarCasos...
    cmp rdi, 0
    je .chauMalloc      ;if (casosNivel2 != 0)
    imul rdi, CASO_SIZE ;casosNivelX * CASO_SIZE = tam array de casos
    call malloc         ;malloc(rdi), rdi es el puntero ahora
    mov r15, rax        ;r15 deja de ser el casosNivel2 y pasa a ser 
                        ;el puntero al array de nivel 2

    .chauMalloc:

    ;------------------------------------------------------TestFuncionalidad
    ;En principio, okey



    .epilogo:
    add rsp, 8
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    ret
;
