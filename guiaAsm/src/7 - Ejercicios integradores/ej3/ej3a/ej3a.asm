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
    xor rbx, rbx ;rbx = 0
    push rbx     ;iteraodrNivel1 = qword [rbp - 48]
    push rbx     ;iteraodrNivel1 = qword [rbp - 56]
    push rbx     ;iteraodrNivel2 = qword [rbp - 64] 
    

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
    ;En principio, okey, tenemos nuestros punteritos
    ;Aca no hay llamados a funcion, asiq podemos usar los registros volatiles


    cmp r12d, 0                 ;if largo== 0 sigo con mi vida
    je .mallochearResultado
    

    xor r9, r9                  ; r9 = 0, es el iterador
    xor rsi, rsi                ; rsi = 0 para productear

    .ciclo: ;----------------------------CICLO----------------------------------
    
    
    mov rsi,r9                  ; paso el  valor i a rsi
    imul rsi, CASO_SIZE         ; multiplico i * CASO_SIZE

    mov rdi, [rbx + rsi + CASO_USUARIO_OFFSET]
    ;[arreglgo_casos + (i * CASO_SIZE) + casoUsuarioOffset] = rdi
    ;osea, rdi deberia ser el puntero al usuario actual del caso.
    ;enfasis en DEBERIA.
    mov edx, [rdi + USUARIO_NIVEL_OFFSET] ; rdx = nivelActual....

    ;primer IF

    cmp rdx, 0
    jne .casoNivel1 ;Si no sos 0, vas al siguiente IF
    mov rcx, qword [rbp - 48] ; rcx = iteradorNivel0
    imul rcx, CASO_SIZE       ; rcx = iteradorNivel0 * CASO_SIZE 

    ;Este es un mejor metodo de clonar los casos
    ;mov r8, [r14+SEGMENTACION_CASOS1_OFFSET]
    ;mov [r8+rsi+CASO_USUARIO_OFFSET], r10   ;copie los bytes 9 a 16
    
    ;mov r10, [r12+r9+CASO_CATEGORIA_OFFSET]
    ;mov [r8+rsi+CASO_CATEGORIA_OFFSET], r10 ;copie los bytes 1 a 8


    ;Copiar categoria[3] a manopla.....
    mov r8b, [rbx + rsi + CASO_CATEGORIA_OFFSET]    ; Hasta aca funca
    mov [r13 + rcx + CASO_CATEGORIA_OFFSET], r8b    ; Hasta aca tambien
    mov r8b, [rbx + rsi + CASO_CATEGORIA_OFFSET + 1]    ; Hasta aca funca
    mov [r13 + rcx + CASO_CATEGORIA_OFFSET + 1], r8b    ; Hasta aca tambien
    mov r8b, [rbx + rsi + CASO_CATEGORIA_OFFSET + 2]    ; Hasta aca funca
    mov [r13 + rcx + CASO_CATEGORIA_OFFSET + 2], r8b    ; Hasta aca tambien

    

    ;Copiar estado
    mov r8w, [rbx + rsi + CASO_ESTADO_OFFSET]
    mov [r13 + rcx + CASO_ESTADO_OFFSET], r8w

    ;Copiar puntero a usuario
    mov r8, [rbx + rsi + CASO_USUARIO_OFFSET]
    mov [r13 + rcx + CASO_USUARIO_OFFSET], r8
    inc qword [rbp - 48]    ;iteradorNivel0++


    .casoNivel1:

    cmp rdx, 1
    jne .casoNivel2 ;Si no sos 0, vas al siguiente IF
    mov rcx, qword [rbp - 56] ; rcx = iteradorNivel0
    imul rcx, CASO_SIZE       ; rcx = iteradorNivel0 * CASO_SIZE 

    ;Copiar categoria[3] a manopla.....
    mov r8b, [rbx + rsi + CASO_CATEGORIA_OFFSET]    ; Hasta aca funca
    mov [r14 + rcx + CASO_CATEGORIA_OFFSET], r8b    ; Hasta aca tambien
    mov r8b, [rbx + rsi + CASO_CATEGORIA_OFFSET + 1]    ; Hasta aca funca
    mov [r14 + rcx + CASO_CATEGORIA_OFFSET + 1], r8b    ; Hasta aca tambien
    mov r8b, [rbx + rsi + CASO_CATEGORIA_OFFSET + 2]    ; Hasta aca funca
    mov [r14 + rcx + CASO_CATEGORIA_OFFSET + 2], r8b    ; Hasta aca tambien

    ;Copiar estado
    mov r8w, [rbx + rsi + CASO_ESTADO_OFFSET]
    mov [r14 + rcx + CASO_ESTADO_OFFSET], r8w

    ;Copiar puntero a usuario
    mov r8, [rbx + rsi + CASO_USUARIO_OFFSET]
    mov [r14 + rcx + CASO_USUARIO_OFFSET], r8
    inc qword [rbp - 56]    ;iteradorNivel1++


    .casoNivel2:

    cmp rdx, 2
    jne .incrementarCiclo ;Si no sos 0, vas al siguiente IF
    mov rcx, qword [rbp - 64] ; rcx = iteradorNivel0
    imul rcx, CASO_SIZE       ; rcx = iteradorNivel0 * CASO_SIZE 

    ;Copiar categoria[3] a manopla.....
    mov r8b, [rbx + rsi + CASO_CATEGORIA_OFFSET]    ; Hasta aca funca
    mov [r15 + rcx + CASO_CATEGORIA_OFFSET], r8b    ; Hasta aca tambien
    mov r8b, [rbx + rsi + CASO_CATEGORIA_OFFSET + 1]    ; Hasta aca funca
    mov [r15 + rcx + CASO_CATEGORIA_OFFSET + 1], r8b    ; Hasta aca tambien
    mov r8b, [rbx + rsi + CASO_CATEGORIA_OFFSET + 2]    ; Hasta aca funca
    mov [r15 + rcx + CASO_CATEGORIA_OFFSET + 2], r8b    ; Hasta aca tambien

    ;Copiar estado
    mov r8w, [rbx + rsi + CASO_ESTADO_OFFSET]
    mov [r15 + rcx + CASO_ESTADO_OFFSET], r8w

    ;Copiar puntero a usuario
    mov r8, [rbx + rsi + CASO_USUARIO_OFFSET]
    mov [r15 + rcx + CASO_USUARIO_OFFSET], r8
    inc qword [rbp - 64]    ;iteradorNivel2++



    .incrementarCiclo:

    inc r9d 
    cmp r9d, r12d                ; while (r9/iterador < largo)
    jl .ciclo



    ;------------------------------------------------------TestFuncionalidad


    .mallochearResultado:

    mov rdi, SEGMENTACION_SIZE ;pasamos comoprimerparametro el tam delsegmento enbytes para malloc
    call malloc ; rax = segmentacion_t*, nuestro resultado

    mov [rax + SEGMENTACION_CASOS0_OFFSET], r13
    mov [rax + SEGMENTACION_CASOS1_OFFSET], r14
    mov [rax + SEGMENTACION_CASOS2_OFFSET], r15


    .epilogo:
    add rsp, 24
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    pop rbp
    ret
