#include <stdio.h>
#include <unistd.h>
#include "../include/soustraire.h"

int main(void)
{
    printf("Devrait-être 12 : %i\n", soustraire(21, 9));
    printf("Devrait-être 12 : %i\n", soustraire(12, 0));
    printf("Devrait-être -12 : %i\n", soustraire(-21, -9));
    return 0;
}
