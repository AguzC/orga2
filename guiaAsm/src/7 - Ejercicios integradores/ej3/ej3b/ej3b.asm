extern strncmp
;########### SECCION DE DATOS
section .data
cliente db "CLT", 0     ; string terminado en 0
robo db "RBO", 0

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

global resolver_automaticamente

;void resolver_automaticamente(funcionCierraCasos* funcion, caso_t* arreglo_casos, caso_t* casos_a_revisar, int largo)
;funcion                --> rdi = Puntero a Foo
;arreglo_casos          --> rsi = Puntero al array de casos
;casos_a_revisar        --> rdx = Puntero al array donde tenemos que poner los casos a revisar
;largo                  --> ecx = Longitud de arreglo_casos
resolver_automaticamente:
    ;prologo
    push rbp
    mov rbp, rsp
    push rbx
    push rbp
    push r12
    push r13
    push r14
    push r15
    xor r15, r15
    push r15 ;iteraodrCasosRevisar = qword [rbp - 56]
    sub rsp, 8

    ;cuerpo
    mov rbx, rdi ; rbx = Foo
    mov r12, rsi ; r12 = arreglo_casos
    mov r13, rdx ; r13 = casos_a_revisar
    xor r14, r14
    mov r14d, ecx ; r14 = longitud de arreglo_casos
    xor r15,r15   ; r15 = 0, es el iterador


    cmp r14d, 0    ;if LEN(ARREGLO) == 0
    je .epilogo

    xor rdx, rdx ;rdx = 0, va a ser i * size

    .ciclo:

    mov rdx, r15
    imul rdx, CASO_SIZE ;rdx = i * CASO_SIZE, osea, posicion acaso actual
    mov rsi, [r12 + rdx + CASO_USUARIO_OFFSET] ;RSI = usuarioActual*
    mov ecx, [rsi + USUARIO_NIVEL_OFFSET] ;rcx = nivel

    ;iteradorCasosRevisar = qword [rbp - 56]

    cmp rcx, 0
    je .casoNivel0YOtrosMasQueNadieQuiere

    ;casoNivel1u2
    xor rdi, rdi
    add rdi, r12
    add rdi, rdx            ; rdi = arreglo_casos[i]*
    call rbx                ; funcion(casoActul*) = ax

    mov rdx, r15            ; Renuvoe rdx porq llame a una funcion 
    imul rdx, CASO_SIZE     ; rdx = i * CASO_SIZE, osea, posicion acaso actual

    cmp ax, 1
    je .casofuncionDeIADio1

    ;casoFucionDeIADio0 y mas cosas....
    cmp ax, 0
    jne .casoNivel0YOtrosMasQueNadieQuiere
    mov bp, ax              ; Tengo que preservarlo porq voy a llamar strncmp


    ;=========If (catogria == CLT)
    mov rdi, r12
    add rdi, rdx
    add rdi, CASO_CATEGORIA_OFFSET ;Esto no hace nada pero me copa
    ;rdi Es el puntero a categoria
    ;edi = casoActual.categoria, que van a ser 4 bytes
    mov rsi, cliente
    mov rdx, 4  ;el 4 de longitud hardcodeado
    call strncmp            ; eax = strcmp(categoria,cliente,4)
    cmp eax, 0  ;Salta si categoria == "RBO"
    je .casoElSuperIfLLegoHastaAca

    mov rdx, r15            ; Renuvoe rdx porq llame a una funcion 
    imul rdx, CASO_SIZE     ; rdx = i * CASO_SIZE, osea, posicion acaso actual

    ;=========If (catogria == RBO)
    mov rdi, r12
    add rdi, rdx
    add rdi, CASO_CATEGORIA_OFFSET ;Esto no hace nada pero me copa
    ;rdi Es el puntero a categoria
    ;edi = casoActual.categoria, que van a ser 4 bytes
    mov rsi, robo
    mov rdx, 4  ;el 4 de longitud hardcodeado
    call strncmp            ; eax = strcmp(categoria,cliente,4)
    mov rdx, r15            ; Renuvoe rdx porq llame a una funcion 
    imul rdx, CASO_SIZE     ; rdx = i * CASO_SIZE, osea, posicion acaso actual
    cmp eax, 0  ;Salta si categoria == "RBO"
    jne .casoNivel0YOtrosMasQueNadieQuiere

    .casoElSuperIfLLegoHastaAca:

        mov rdx, r15            ; Renuvoe rdx porq llame a una funcion 
    imul rdx, CASO_SIZE     ; rdx = i * CASO_SIZE, osea, posicion acaso actual

    mov word [r12 + rdx + CASO_ESTADO_OFFSET], 2
    jmp .incrementarEsteLoop


    .casofuncionDeIADio1:    ; funcion(casoActul*) = ax = 1
    mov word [r12 + rdx + CASO_ESTADO_OFFSET], 1
    jmp .incrementarEsteLoop

    .casoNivel0YOtrosMasQueNadieQuiere:
    mov r8, qword [rbp - 56] ; saco de mem el iterador
    imul r8, CASO_SIZE       ; r8 = iteradorCasosARevisar * CASO_SIZE
    mov r9, [r12 + rdx]      ; r9 = primeros 8 bytes del caso
    mov [r13 + r8], r9       ; pongo los primeros 8 bytes los primeros 8 bytes del caso
    mov r9, [r12 + rdx + 8]  ; r9 = segundos 8 bytes del caso
    mov [r13 + r8 + 8], r9   ; pongo los segundos 8 bytes los segundos 8 bytes del caso
    inc qword [rbp - 56]     ; iteradorDeCasosARevisar++


    .incrementarEsteLoop
    inc r15 ;r15++
    cmp r15, r14
    jl .ciclo 



    .epilogo:

    add rsp, 16
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbp
    pop rbx
    pop rbp
    ret
