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


int main() {
	/* Acá pueden realizar sus propias pruebas */

	char a[] = "hola";

	printf("a tiene: %d letras \n", contarLetras(a));

	return 0;
}
