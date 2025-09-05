#include <stdio.h>   // Para tener printf y sizeof
#include <stdbool.h> // Para tener tipo bool
#include <stdint.h>  // Para tener distintos tamaños

int main(void)
{
    // Estos son los tipos de C, cada uno con su respectivo tamaño

    int    mi_entero  = 4;
    char   mi_char    = 'a';
    float  mi_float   = 3.14;
    double mi_double  = 2.71;
    bool   mi_bool    = false;

    printf("Soy un entero de tamaño %i y valor %i\n", sizeof(mi_entero), mi_entero);
    printf("Soy un char de tamaño %zu y valor %c\n", sizeof(mi_char), mi_char);
    printf("Soy un float de tamaño %zu y valor %f", sizeof(mi_float), mi_float);
    printf("Soy un double de tamaño %zu y valor %f\n", sizeof(mi_double), mi_double);
    printf("Soy un bool de tamaño %zu y valor %i\n", sizeof(mi_bool), mi_bool);

    // A su vez, C nos permite declarar si una variable
    // tiene signo y reducir o agrandar el tamaño por defecto

    //unsigned int; // Entero sin signo, si tiene n bits, entonces va de 0 a 2^n
    //short int;    // Reduce el tamaño
    //long int;     // Aumenta el tamaño

    // Aca podemos especificar el tamaño "a mano", declarando la cantidad de bytes

    //uint8_t  entero_chiquito;
    //uint16_t entero_promedio;
    //uint32_t entero_grande;
    //uint64_t entero_masivo;

    return 0;
}
