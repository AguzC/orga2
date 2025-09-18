#include "../ejs.h"



uint32_t contar_casos_por_nivel(caso_t* arreglo_casos, uint32_t largo, uint32_t nivel) {
    
    if (largo == 0) { //null pointer
        return 0;
    }

    uint32_t res = 0;
    caso_t casoActual;  
    usuario_t* usuarioActual;

    uint32_t i = 0;
    while (i < largo) {

        casoActual = arreglo_casos[i];

        usuarioActual = casoActual.usuario;

        if (usuarioActual->nivel == nivel) {
            res++;
        }
        i++;
    }
    return res;
}

segmentacion_t* segmentar_casos(caso_t* arreglo_casos, int largo) {

    uint32_t casosNivel0 = contar_casos_por_nivel(arreglo_casos,largo,0); 
    uint32_t casosNivel1 = contar_casos_por_nivel(arreglo_casos,largo,1); 
    uint32_t casosNivel2 = contar_casos_por_nivel(arreglo_casos,largo,2); 

    caso_t* punteroCasosNivel0 = NULL;
    caso_t* punteroCasosNivel1 = NULL;
    caso_t* punteroCasosNivel2 = NULL;

    if (casosNivel0 != 0) {
        punteroCasosNivel0 = malloc(casosNivel0 * 16);
    }
    if (casosNivel1 != 0) {
        punteroCasosNivel1 = malloc(casosNivel1 * 16);
    }
    if (casosNivel2 != 0) {
        punteroCasosNivel2 = malloc(casosNivel2 * 16);
    }

    uint32_t iteradorNivel0 = 0;
    uint32_t iteradorNivel1 = 0;
    uint32_t iteradorNivel2 = 0;

    for(int i = 0; i < largo; i++) {

        caso_t casoActual = arreglo_casos[i];

        usuario_t* usuarioActual = casoActual.usuario;

        uint32_t nivelActual = usuarioActual->nivel;

        if (nivelActual == 0) {
            punteroCasosNivel0[iteradorNivel0] = casoActual;
            iteradorNivel0++;
        }
        if (nivelActual == 1) {
            punteroCasosNivel1[iteradorNivel1] = casoActual;
            iteradorNivel1++;
        } 
        if (nivelActual == 2) {
            punteroCasosNivel2[iteradorNivel2] = casoActual;
            iteradorNivel2++;
        }

    }

    segmentacion_t* segResultado = malloc(sizeof(segmentacion_t));
    
    segResultado->casos_nivel_0 = punteroCasosNivel0;
    segResultado->casos_nivel_1 = punteroCasosNivel1;
    segResultado->casos_nivel_2 = punteroCasosNivel2;

    return segResultado;
}



