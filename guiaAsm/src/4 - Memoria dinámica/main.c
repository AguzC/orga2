#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <assert.h>

#include "../test-utils.h"
#include "Memoria.h"

uint64_t contarLetras(char* palabra) {
	uint64_t res = 0;

	while(*palabra != '\0') {
		res += 1;
		palabra += 1;

	}

	return res;
} 

//clonar, me dan un puntero que no apunta a nada valioso, y otro punteo
//que apunta a un string, queremos que todo el contenido del segundo 
//tambien este en el primero, la reserva de memoria se hace por fuera 
//de la funcion, el strcpy no se encarga de alocar mem, solo de reemplazar
//dentro suyo el contenido.
//Actually la materia quiere que nosotros reservemos memoriai dentro,asiq 
//si hay que malloquear dentro.

char* clonarString(char* src) {
	
	size_t len = contarLetras(src);

	char* dst = malloc(len + 1);

	int offset = 0;

	while(*src != '\0') {
		*(dst + offset) = *src;
		src += 1;
		offset += 1;
	}
	
	*(dst + offset) = '\0';

	return dst;
}

/* 
int comparameStrings(char* str1, char* str2) {
	int res = 0;

	if(*str1 == '\0' && *str2 != '\0') {
		return -1;
	}
	if(*str2 == '\0' && *str1 != '\0') {
		return 1;
	}

	while(*str1 != '\0' && *str2 != '\0') {
		if ( || *str1  > *str2) {
			res = 1;
			break;
		} else if (*str1 < *str2 ) {
			res = -1;
			break;
		}
		str1 ++;
		str2 ++;
	}
	return res;
} */




int main() {
	/* Acá pueden realizar sus propias pruebas */

	char a[] = "hola";
	char* nuevoString = strClone(a);

	printf("nuevoString vale: %d \n",nuevoString);

	free(nuevoString);
	
	return 0;
}
