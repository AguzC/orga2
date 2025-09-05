#include <stdio.h>
#include <stdlib.h>

// 2) Punteros y arrays:

// en funciones, arrays y punteros se usan igual para acceder a elementos.
// Pero Sizeof se comporta distinto! idem con reasignacion de memoria.

// Función que modifica el arreglo multiplicando por 2
void multiplicarPorDos(int *arr, int size) {
    for (int i = 0; i < size; i++) {
        arr[i] *= 2;
    }
}

int main() {
    int n;
    printf("Ingrese el tamaño del arreglo: ");
    scanf("%d", &n);

    // Reservar memoria dinámica
    int *arreglo = (int *)malloc(n * sizeof(int));
    if (arreglo == NULL) {
        printf("Error al reservar memoria.\n");
        return 1;
    }

    // Llenar con cuadrados de los índices
    for (int i = 0; i < n; i++) {
        arreglo[i] = i * i;

        // Alternativamente, se puede usar:
        //*(arreglo + i) = i * i;
    }

    // Imprimir antes
    printf("\nArreglo original:\n");
    for (int i = 0; i < n; i++) {
        printf("%d ", arreglo[i]);
    }

    // Modificar con punteros
    multiplicarPorDos(arreglo, n);

    // Imprimir después
    printf("\n\nArreglo modificado (x2):\n");
    for (int i = 0; i < n; i++) {
        printf("%d ", arreglo[i]);
    }

    // Liberar memoria
    free(arreglo);

    return 0;
}