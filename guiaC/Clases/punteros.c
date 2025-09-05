#include <stdio.h>

// 1) ¿Que es un puntero?
// Un puntero es una variable que almacena la dirección de memoria de otra variable.
// Es decir un puntero almacena dónde está ese valor en la memoria

int main() {
    int x = 10;         // Variable normal
    int *px = &x;       // Puntero que guarda la dirección de x
    int y = *px;        // y toma el valor de lo que apunta px (10)

    x = 20;             // Cambio directo en x
    *px = 30;           // Cambio indirecto en x a través del puntero

    int z = 40;
    px = &z;            // Ahora px apunta a otra dirección (z)

    return 0;
}

// Usar comandos de gdb para ver el contenido de las variables:
// gdb punteros
// run
// break main
// run
// next
// print x