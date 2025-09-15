#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "ej1.h"

/**
 * Marca el ejercicio 1A como hecho (`true`) o pendiente (`false`).
 *
 * Funciones a implementar:
 *   - es_indice_ordenado
 */
bool EJERCICIO_1A_HECHO = false;

/**
 * Marca el ejercicio 1B como hecho (`true`) o pendiente (`false`).
 *
 * Funciones a implementar:
 *   - indice_a_inventario
 */
bool EJERCICIO_1B_HECHO = true;

/**
 * OPCIONAL: implementar en C
 * |inventario| = |indice| = tamanio
 * El indice es un array de indices, que dependiendo segun que lo querias ordenar, estan en ese orden,
 * osea, si queres que sea por mayor daño, en el inventario tan los punteros a sus items sin ningun 
 * orden particular, y en el indice, el valor del indice que tiene el mayor daño y asi dentro de 
 * inventario, asiq lo que vamos a hacer es ir fijandonos 1 a 1 si el item del indice que tiene 
 * primero en el array indice es mayor segun el comparador al item del siguiente indice, fijandonos
 * uno a uno, y por transitividad deberian ser(?
 * 
 * Comparador:  * Devolver `true` significa los parámetros están en el orden correcto.

 */
bool es_indice_ordenado(item_t** inventario, uint16_t* indice, uint16_t tamanio, comparador_t comparador) {

	if (tamanio <= 1) { //0 y 1 items tan ordenados.
		return true;
	}

	for (uint16_t i = 0; i < tamanio - 1; i++) { 
		uint16_t indiceActual = *(indice + i); //Agarro el primer indice 
		uint16_t indiceSiguiente = *(indice + i + 1); //Agarro el siguiente indice

		item_t* itemActual = inventario[indiceActual]; //Consigo el primer objeto
		item_t* itemSiguiente = inventario[indiceSiguiente]; //Consigo el segundo objeto

		bool estanEnOrden = comparador(itemActual,itemSiguiente);
		if (!estanEnOrden) {
			return false;
		}
	}
	return true;
}

/**
 * OPCIONAL: implementar en C
 */

 /* 
Dado un inventario que es un array de punteros hacia los items, y un indice, 
que es un array de indices que tiene algun orden, tenemos que devolver un 
puntero a un array de punteros, donde el primer elemento sea el que esta 
en la posicion que indica el primer elemento de indice.
Voy a tener que mallochear un array del tam que me pasan primero, y laburar 
ese.

 */

item_t** indice_a_inventario(item_t** inventario, uint16_t* indice, uint16_t tamanio) {
	// ¿Cuánta memoria hay que pedir para el resultado?

	item_t** resultado = malloc(tamanio * 8); //Cantidad de elementos por tam de punteros.

	for (uint16_t i = 0; i < tamanio ; i ++) {

		uint16_t indiceActual = *(indice + i); //Importante pasar unidades en asm
		resultado[i]  = inventario[indiceActual];	//Importante pasar unidades en asm
	}	
	return resultado;
}

