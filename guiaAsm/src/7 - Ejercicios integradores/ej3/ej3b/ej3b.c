#include "../ejs.h"







/* 
Tonces, la idea es iterar por el array de casos chusmeando el nivel del cliente, y
haciendo cositas en base a eso, y tenemos una funcion que nos dicen si es cerrable
o no, funcionCierraCasos(casoActual), que devuelve 0 o 1.

casos nivel 0: No los procesas automaticamente, lo unico que se hace con estos es
agregarlos al array de casos a revisar.

casos nivel 1 y 2: funcionCierraCasos(casoActual), 
    foo res = 1 --> El caso se cierra automaticamente y tenemos que marcar su 
                    estado como cerrado favorablemente, osea, estado = 1

    foo res = 0 Y categoria = "CLT" o "RBO", se cierra automaticamente y se 
                    le pone el estado = 2, desfavorablemente
        
    Cualquier otro caso no se puede resolver, no se modifica nada del caso
    y se agrega al array a revisar



Para el assembly podemos hacer un 
cmp xx, 0
je .caso0 
aca el caso == 1 o == 2
 */



void resolver_automaticamente(funcionCierraCasos_t* funcion, 
                              caso_t* arreglo_casos, 
                              caso_t* casos_a_revisar, 
                              int largo){

    caso_t casoActual;
    caso_t* punteroCasoActual;
    usuario_t* usuarioActual;
    uint32_t nivelActual;
    uint32_t iteradorCasosARevisar = 0;

    for (int i = 0; i < largo; i++){
        casoActual = arreglo_casos[i];
        punteroCasoActual = &casoActual;
        usuarioActual = casoActual.usuario;
        nivelActual = usuarioActual->nivel;

        if (nivelActual == 0) {
            casos_a_revisar[iteradorCasosARevisar] = casoActual;
            iteradorCasosARevisar++;
        }
        if (nivelActual != 0) {
            uint16_t resIA = funcion(punteroCasoActual);

            if (resIA == 1) {

                arreglo_casos[i].estado = 1;

            } else if (resIA == 0 && (strncmp(casoActual.categoria,"CLT",4) == 0
                ||strncmp(casoActual.categoria,"RBO",4) == 0)){

                arreglo_casos[i].estado = 2;

            } else {//No son cerrables de ninguna forma
                casos_a_revisar[iteradorCasosARevisar] = casoActual;
                iteradorCasosARevisar++;                    
            }
        }
    }
}

