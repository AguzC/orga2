#include <stdio.h>

/*
    Al pasar un arreglo por parametro se puede especificar su tamaño,
    o poner los corchetes vacios y pasar el largo como otro parametro
    (si la funcion lo necesita)
*/
float maximo(const float arr[], const int largo)
{
    float max = arr[0];

    for (int i = 0; i < largo; i++)
    {
        float actual = arr[i];

        if (actual > max)
        {
            max = actual;
        }
    }

    return max;
}

int main(void)
{
    const int largo = 10;

    const float mi_array[largo] = {1.0, 1.2, 2.3, 3.14, 5.7, 9.3, 0.2, -3.4, 4.3, 6.7};

    printf("El mayor en el array es: %f\n", maximo(mi_array, largo));

    return 0;
}
