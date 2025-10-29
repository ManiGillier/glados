#include <stdio.h>
#include <unistd.h>
#include "../include/carré_de.h"

int main(void)
{
    printf("Devrait-être 9 : %i\n", carré_de(3));
    printf("Devrait-être 0 : %i\n", carré_de(0));
    printf("Devrait-être 9 : %i\n", carré_de(-3));
    return 0;
}
