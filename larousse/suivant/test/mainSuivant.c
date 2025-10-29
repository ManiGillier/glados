#include <stdio.h>
#include <unistd.h>
#include "../include/suivant.h"

int main(void)
{
    printf("Devrait-être 12 : %i\n", suivant(11));
    printf("Devrait-être 1 : %i\n", suivant(0));
    printf("Devrait-être -12 : %i\n", suivant(-13));
    return 0;
}
