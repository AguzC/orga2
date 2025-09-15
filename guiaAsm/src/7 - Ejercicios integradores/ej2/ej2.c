#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "ej2.h"

/**
 * Marca el ejercicio 1A como hecho (`true`) o pendiente (`false`).
 *
 * Funciones a implementar:
 *   - es_indice_ordenado
 */
bool EJERCICIO_2A_HECHO = true;

/**
 * Marca el ejercicio 1B como hecho (`true`) o pendiente (`false`).
 *
 * Funciones a implementar:
 *   - contarCombustibleAsignado
 */
bool EJERCICIO_2B_HECHO = false;

/**
 * Marca el ejercicio 1B como hecho (`true`) o pendiente (`false`).
 *
 * Funciones a implementar:
 *   - modificarUnidad
 */
bool EJERCICIO_2C_HECHO = false;

/**
 * OPCIONAL: implementar en C
 */

/* 
La idea es que te pasan un tipo de unidad, sean tanques o algo asi, y vos tenes que 
optimizarla, que es agarrar, fijarte si son equivalentes con la funcion hash,
que seria hash(compartido) == hash(posActual), si lo son, haces free a la unidad,
y subis 1 la referencia  del compartido y apuntas el puntero a la unidad compartida

mapa :: attackunit_t* mapa?

compartida = auto1

maap[0][0] = auto1

No quiero subir la referencia de compartida en + 1, 

Mi compartido que me pasan puede empezar con 0, 1 o mas referencias, las que se te cante el orto
Compartido puede o no ser parte del tablero

Caso1: Empieza en 0 y hay una aparicion en el tablero. resultado: 1
caso2: Empieza en 1 y hay una aparicion en el tablero. resultado: 1

Si tnego punteros distintos y hash igual -> 


  */
/* void optimizar(mapa_t mapa, attackunit_t* compartida, uint32_t (*fun_hash)(attackunit_t*)) {

    uint32_t hashCompartida = fun_hash(compartida);

    for (int i = 0; i < 255;i++) {
        for (int j = 0; j < 255; j++){

            attackunit_t* unidadActual = mapa[i][j]; //Consigo el puntero actual de esa pos
                                                     //IMPORTANTE: en asm calcular el tam
        
            if (unidadActual == NULL){ //Null pointer check, hash no parece ser bueno con NULL
                continue;              
            }

            if (unidadActual == compartida && compartida->references <= 0) {
                compartida->references = 1;
                continue;
            }
            
            uint32_t hashPosActual = fun_hash(unidadActual); //Calculamos el hash de la unidad

            
            if (hashCompartida == hashPosActual) { //Si hashean igual
                compartida->references =+ mapa[i][j]->references;        
                free(mapa[i][j]);                     //Libero el valor del puntero
                mapa[i][j] = compartida;             // 
            }
        }                              
    }
} */

void optimizar(mapa_t mapa, attackunit_t* compartida, uint32_t (*fun_hash)(attackunit_t*)) {

    uint32_t hashCompartida = fun_hash(compartida);

    for(int i=0; i<255;i++){
        for(int j=0; j<255; j++){

            if (mapa[i][j] == NULL){ //Null pointer check, hash no parece ser bueno con NULL
                continue;              
            }

            if(hashCompartida == fun_hash(mapa[i][j])){ //Si tienen mismo hash
                                                                        
                if(compartida != mapa[i][j] && mapa[i][j]->references == 1){ //Si no apuntan al mismo item
                    free(mapa[i][j]);                                        //comp y mapa[i][j] y mapa 
                }                                                            //tiene 1
                mapa[i][j]->references--;
                mapa[i][j]=compartida;
                compartida->references++;
            }
        }
    }
 
}






/**
 * OPCIONAL: implementar en C
 */
uint32_t contarCombustibleAsignado(mapa_t mapa, uint16_t (*fun_combustible)(char*)) {
}

/**
 * OPCIONAL: implementar en C
 */
void modificarUnidad(mapa_t mapa, uint8_t x, uint8_t y, void (*fun_modificar)(attackunit_t*)) {
}
