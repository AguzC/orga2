#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <assert.h>

#include "../test-utils.h"
#include "ABI.h"

int main() {
	/* Acá pueden realizar sus propias pruebas */

	double result = -1;

	product_9_f(&result, 562, 62.54, 249, 289.09, 591, 783.86, 588, 122.03, 942, 822.40, 508, 912.90, 934, 760.04, 927, 7.64, 473, 513.26);

	assert(alternate_sum_8(8,7,6,5,4,3,2,1) == 4);
	
	assert(alternate_sum_4_using_c(8, 2, 5, 1) == 10);

	assert(alternate_sum_4_using_c_alternative(8, 2, 5, 1) == 	10);
	return 0;
}
