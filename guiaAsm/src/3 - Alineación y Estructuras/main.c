#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <assert.h>

#include "../test-utils.h"
#include "Estructuras.h"

int main() {
	/* Acá pueden realizar sus propias pruebas */

	lista_t a;
	packed_lista_t b;


	return 0;
}


uint32_t cantidad_total_de_elementos_Mia(lista_t* lista) {

	//Chequeo Null pointer
	if (lista == NULL) {
		return 0;
	} 
	nodo_t* actual = lista->head;
	uint32_t res = actual->longitud;
	nodo_t* siguiente = actual->next;

	//
	while (siguiente != NULL) {
		actual = siguiente;
		res += actual->longitud;
		siguiente = actual->next;
	}
	return res;

}
