#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "../test-utils.h"
#include "Debugging.h"

int main(int argc, char* argv[]) {

	bool a = true;

	printf("El tam de bool es: %d \n",sizeof(a));

	return 0;
}
