#include <stdio.h>
#include <unistd.h>
#include "../include/imprimer_peigne_N.h"

int main(void)
{
    printf("Boh le resultat c'est ça :\n%i\n", imprimer_peigne_N(12));
    // printf("Devrait-être 2400000 : %i\n", imprimer_peigne_N(1200000, 2400000));
    // printf("Devrait-être -12 : %i\n", imprimer_peigne_N(-12, -24));
    return 0;
}
