#include "funciones.h"
#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>
#include <stddef.h>
#include <string.h>
#include <stdlib.h>
#define NAME_LEN 50

void separasao() {
    printf("\n\n ==============Separasao de ejercicio============== \n\n");
}

void swap(int *a, int *b) {
int tmp = *a;
*a = *b;
*b = tmp;
}

void swap2(int* a, int* b) {
    int tmp = *b; 
    *b = *a;
    *a = tmp;
}

size_t lenght(char *str) {
    size_t len = 0;
    while (*str != '\0') {
        len++;  
        str++;
    }
return len;
}

void mayus(char *frase) {

    while(*frase != '\0') {
        char x = *frase;
        if ( 'a'<= x && x <= 'z') {
            *frase -= 32;
        }
        frase++;
    }
}

typedef struct persona_s {
        char nombre[NAME_LEN+1];
        int edad;
        struct persona_s* hijo;
    } persona_t;

uint16_t *secuencia(uint16_t n){
    uint16_t *arr = malloc(n * sizeof(uint16_t));
    if (arr == NULL) {
        // Manejar el error de asignaci´on de memoria
        return NULL;
    }
    for(uint16_t i = 0; i < n; i++)
        arr[i] = i;
    return arr;
}

persona_t* crearPersona(char* nombre,int edad) {
    persona_t* ptr = malloc(sizeof(persona_t));//Hace sizeOf(algun struct) ya te da todos sus bytes que ocupa alineados a 4 en mem. 
    if (ptr == NULL) {
        return NULL; // Error de memoria
    }
    strcpy(ptr->nombre,nombre);
    ptr->edad = edad;
    printf("TOY VIVO, me llamo %s, y tengo %d años. \n",nombre,edad);
    return ptr;
}                

void eliminarPersona(persona_t* victima) {
    printf("LLegue a la funcion de eliminar. \n");
    free(victima);
    printf("Ya no existo mas.. \n");
}
 
typedef struct node {
    void* data;
    struct node* next;
} node_t;
typedef struct list {
    //type_t type;
    uint8_t size;
    node_t* first;
} list_t;

/* list_t* listNew(type_t t) {
    list_t* l = malloc(sizeof(list_t));
    //l->type = t; // l->type es equivalente a (*l).type
    l->size = 0;
    l->first = NULL;
    return l;
} */

/* void listAddFirst(list_t* l, void* data) {
    node_t* n = malloc(sizeof(node_t));
     switch(l->type) {
        case TypeFAT32:
        n->data = (void*) copy_fat32((fat32_t*) data);
        break;
        case TypeEXT4:
        n->data = (void*) copy_ext4((ext4_t*) data);
        break;
        case TypeNTFS:
        n->data = (void*) copy_ntfs((ntfs_t*) data);
        break;
    } 
    n->next = l->first;
    l->first = n;
    l->size++;
} */

//se asume: i < l->size
void* listGet(list_t* l, uint8_t i){
    node_t* n = l->first;
    for(uint8_t j = 0; j < i; j++)
        n = n->next;
    return n->data;
}

//se asume: i < l->size
/* void* listRemove(list_t* l, uint8_t i){
    node_t* tmp = NULL;
    void* data = NULL;
    if(i == 0){
        data = l->first->data;
        tmp = l->first;
        l->first = l->first->next;
    }else{
        node_t* n = l->first;
        for(uint8_t j = 0; j < i - 1; j++)
            n = n->next;
            data = n->next->data;
            tmp = n->next;
            n->next = n->next->next;
        }
    free(tmp);
    l->size--;
    return data;
} */

void listDelete(list_t* l){
    node_t* n = l->first;
    while(n){
    node_t* tmp = n;
    n = n->next;
/*     switch(l->type) {
        case TypeFAT32:
        rm_fat32((fat32_t*) tmp->data);
        break;
        case TypeEXT4:
        rm_ext4((ext4_t*) tmp->data);
        break;
        case TypeNTFS:
        rm_ntfs((ntfs_t*) tmp->data);
        break;
    } */
    free(tmp);
    }
    free(l);
}

void allocateArray(int **arr, int size, int value) {
    *arr = (int*)malloc(size * sizeof(int));
    if(*arr != NULL) {
    for(int i=0; i<size; i++) {
        (*arr)[i] = value;
    }
    }
}

void modPuntero(int** ptr) {
    *ptr = malloc(sizeof(int));
}

void print_int(int x) {
    printf("%d\n", x);
}

void pretty_print_int(int x) {
    printf("Entero[%lu bits]: %d\n", sizeof(x)*8, x);
}
void contarHasta(int hasta){
    for(int i = 0; i < hasta; i++){
        printf("%d\n", i);
    }
}
//=========================================================

typedef struct{
    char nombre[5];
    uint8_t habilitado; // bool
    int saldo;
    int gustoDeHeladoFavorito;
} usuario_t;

void habilitarUsuario(usuario_t *usuario){
    usuario->habilitado = 1;
    for(int i = 0; i < 5; i++){ //El problema era que tenia un <= 5,asiq se iba una posicion de mem
        usuario->nombre[i] = '\0';//mas y modifica el valor de habilitado que viene en la siguiente 
    }                           //pos de memoria por un \0, que vale 0 pasado a int segun ASCII, es 
    usuario->saldo = 0;
}                               //equivalente a NULL?

typedef enum{
    MENTA,
    DDL,
    OREO,
    LIMON
} gustoDeHelado_t;

typedef enum{
    ABIERTO,
    CERRADO
} estadoDelLocal;


char* gustosDeHelado[4]= {"MENTA", "DDL", "OREO", "LIMON"};

typedef struct{
    uint32_t precio;
    gustoDeHelado_t gusto;
} helado_t;

helado_t heladoDDL = {.precio = 5, .gusto = DDL};

void aumentarSaldo(int* saldoDelUsuario, int cantidad){ //Taba mal porq pasaba por copia el saldo.
    *saldoDelUsuario += cantidad;
}

void comprarHelado(usuario_t *usuario, helado_t** helado){ //Que psicopateada que int** a = int* *a
    if(usuario->saldo >= 5){
        usuario->saldo -= 5;
        *helado = &heladoDDL;
        printf("Helado comprado con exito\n");
    }else{
        printf("El usuario no tiene saldo suficiente\n");
    }
}

/* void map(lista_t* lista, int (*operacion)(int)) { //Map sobre listas enlazadas.
    nodo_t* actual = lista->cabeza;
    while (actual != NULL) {
        actual->valor = operacion(actual->valor);
        actual = actual->siguiente; 
    }
} */






int main() {


/*     int8_t memoria[8] = {0};
    uint8_t *x = (uint8_t*) &memoria[0];
    uint8_t *y = (uint8_t*) &memoria[8];

    printf("Dir de x: %p Valor: %d\n", (void*) x, *x);
    printf("Dir de y: %p Valor: %d\n", (void*) y, *y);

    separasao();

    int *p = NULL;
    if (p == NULL) {
    printf("El puntero no apunta a nada.\n");
    } else {
    printf("El puntero apunta a: %d\n", *p);
    }

    separasao();

    uint32_t a[] = {28,7,92};
    uint32_t *pi = a;
    printf("%d\n", *pi); //28
    pi += 1;
    printf("%d\n", *pi); //7

    separasao();


    char a1 = 'a';
    char* pa1 = &a1;

    printf("Tam a1 es: %c \n",sizeof(a1));
    printf("Tam pa1 es: %d \n",sizeof(pa1));

    separasao();

    int x10 = 10, y20 = 20;
    swap(&x, &y);
    printf("x: %d, y: %d\n", x, y);

    int c10 = 10, d20 = 20;
    printf("x: %d, y: %d\n", c10, d20);
    swap2(&c10,&d20);
    printf("x: %d, y: %d\n", c10, d20); */
    separasao();
/*     char str[] = "Hola me llamo juan, un gusto";
    mayus(str);
    printf("Lenght de str es: %lu\n", lenght(str));

    printf("%s \n",str);

    char copia[lenght(str)]; // Importante aclarar el tamaño del array 
    strcpy(copia,str);       // donde lo vas a dejar,sino, seg fault.
    printf("%s \n",copia);   // Copia el contenido del segundo param en el primero


    char strx[] = "Hola me llamo Gus, un gusto";
    char concatenar[lenght(str)*2]; 
    strcat(concatenar,strx);
    strcat(concatenar,str);
    printf("%s \n",concatenar);
    return 0;

    size_t lenPrueba = strlen(strx); //Calcula la longitud sin tener en cuenta al '\0'

  0, if the s1 and s2 are equal;
    a negative value if s1 is less than s2;
    a positive value if s1 is greater than s2. 
    the strncmp() function is similar, except it compares only the first (at most) n bytes of s1 and s2.
*/
    //int equals = strcmp(strx,str); 
    separasao();
/*     typedef struct persona_s {
        char nombre[NAME_LEN+1];
        int edad;
        struct persona_s* hijo;
    } persona_t; */
    separasao();
/*     uint16_t *arr = secuencia(10);

    if (arr == NULL) {
    // Manejar el error de asignaci´on de memoria
        return 1;
    }
    for(uint16_t i = 0; i < 10; i++)mak
    printf("%d\n", arr[i]);
    free(arr); // Liberar la memoria reservada */
/* 
    persona_t* juan = crearPersona("Juan", 29);
    eliminarPersona(juan);*/
    separasao();
/*     printf("Null == 0 --> %d \n",NULL == 0 ? 1:0);

    int *vector;
    allocateArray(&vector,5,45); //IMPORTANTISIMO: Si queres cambiar la direccion de un puntero,
                                 //tenes qu
    for(int i = 0; i < 5; i++)
        printf("%d\n", vector[i]);
    free(vector); */

/*     int* punterito = NULL;
    printf("Mi punterito vale %d \n",punterito);
    modPuntero(&punterito);
    printf("Mi punterito vale %d \n",punterito);
    free(punterito);
    printf("Mi punterito fue liberado \n");
 */
    separasao();
/*     int matrix[3][4] = {
    {1, 2, 3, 4},
    {5, 6, 7, 8},
    {9, 10, 11, 12}
    };

    // Todos estos prints imprimen 7
    printf("matrix[1][2]: %d\n", matrix[1][2]); //Cosa divina, gracias a dios que existe
    printf("matrix[1][2]: %d\n", *(*(matrix + 1) + 2));  
       
    Matrix  = pos inicial del array en memoria, el 1 es el tamaño de una fila, aca, serian
    16 bytes, porq son 4 ints, 4 x 4, y a eso, el *(matrix + 1) es un puntero a un arrelgo,
    *matrix  ≡  matrix[0]  ≡  &matrix[0][0]
    *(matrix + 1) → fila 1 (puntero a m[1][0])
    *(matrix + 2) → fila 2 (puntero a m[2][0])

    matrix + 1 → puntero a la fila 1
    *(matrix + 1) → esa fila (un int * a matrix[1][0])
    *(matrix + 1) + 2 → dirección de matrix[1][2]
    *(*(matrix + 1) + 2) → valor almacenado en matrix[1][2]
    
    printf("matrix[1][2]: %d\n", *((int*) matrix + 4*1 + 2));
    //Si queres explicaciones de este mejor buscalas, sino, usa m[i][j]

    matrix[0][3] = 100; // asigna 100 a la fila 0, columna 3
    printf("matrix[0][3]: %d\n", matrix[0][3]); // imprime 100  */
    
/*     int matrix[3][4] = {
    {1, 2, 3, 4},
    {5, 6, 7, 8},
    {9, 10, 11, 12}
    };
    // p apunta al int en la fila 0, columna 0
    int *p = &matrix[0][0];
    // ¿qu´e es reshape?
    int (*reshape)[2] = (int (*)[2]) p;
    printf("%d\n", p[3]); // Qu´e imprime esta l´ınea?
    printf("%d\n", reshape[1][1]); // Qu´e imprime esta l´ınea
     */
    separasao();
/*     void (*print)(int) = print_int;
    print(42); // () desreferencia el puntero a funci´on
    print = pretty_print_int;
    print(3);
 */
    separasao();
/* 
    usuario_t *nuevoUsuario = malloc(sizeof(usuario_t));

    habilitarUsuario(nuevoUsuario);

    if(nuevoUsuario->habilitado){
        printf("Usuario habilitado con exito!\n");
        aumentarSaldo(&nuevoUsuario->saldo, 10);

        helado_t* helado = NULL;
        comprarHelado(nuevoUsuario, &helado);
        nuevoUsuario->gustoDeHeladoFavorito = helado->gusto;

        printf("Usuario creado con exito. \n");
        printf("Su saldo es de %d pesos y su gusto favorito es %s.\n",
            nuevoUsuario->saldo,
            gustosDeHelado[nuevoUsuario->gustoDeHeladoFavorito]);
    } else{
        printf("Error al habilitar usuario %d\n", nuevoUsuario->habilitado);
    }
    free(nuevoUsuario); */
    separasao();



    return 0;
}
