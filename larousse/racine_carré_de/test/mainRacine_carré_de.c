#include <stdio.h>
#include <unistd.h>
#include "../include/racine_carré_de.h"

int main(void)
{
    printf("Devrait-être 3 : %i\n", racine_carré_de(9));
    printf("Devrait-être 0 : %i\n", racine_carré_de(0));
    printf("Devrait-être 4 : %i\n", racine_carré_de(16));
    return 0;
}
