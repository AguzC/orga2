#include <stdio.h>


/*
    Para definir funciones en C se hace:

    tipo_de_retorno nombre_de_la_funcion(parametros)
    {
        Codigo
    }
*/
void fizzbuzz(int n)
{
    /*
        El for tiene 3 partes:
         - Primero la inicializacion, eso se va a ejecutar una vez
         - Luego la condicion, se va a evaluar al principio de cada iteracion
         - Por ultimo, una instruccion que se ejecuta al final de cada iteracion (generalmente el incremento o decremento)
    
        A saber, el while es parecido, pero solo contiene la condicion:

        while(condicion)
        {
            Codigo
        }
    */
    for (int i = 0; i < n; i++)
    {
        printf("%i : ", i);

        /*
            El if es similar al while, solo tiene la condicion a chequear, y los elses se puede anidar con otros if
        */
        if (i % 15 == 0)
        {
            printf("fizzbuz");
        }
        else if (i % 5 == 0)
        {
            printf("buzz");
        }
        else if (i % 3 == 0)
        {
            printf("fizz");
        }

        printf("\n");
    }
}

/*
    La funcion main en C es donde esta el comportamiento del programa,
    todo programa en C empieza y termina en el main
*/
int main(void)
{
    // Para definir una variable es: tipo nombre = valor;
    // Podemos agregar el prefijo const para convertirla en constante
    
    const int num = 100;

    printf("=== FIZZBUZZ! ===\n");
    printf("Vamos a recorrer numeros del 1 al %i\n", num);
    printf("Cuando el numero sea divisible por 3, imprimimos 'fizz'\n");
    printf("Cuando el numero sea divisible por 5, imprimimos 'buzz'\n");
    printf("Cuando ambos lo dividan, imprimimos 'fizzbuzz'\n\n");

    fizzbuzz(num);

    return 0;
}
