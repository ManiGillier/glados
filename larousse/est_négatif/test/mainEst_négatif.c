#include <stdio.h>
#include <unistd.h>
#include "../include/est_négatif.h"

int main(void)
{
    printf("Devrait-être 1 : %i\n", est_négatif(-12));
    printf("Devrait-être 0 : %i\n", est_négatif(12));
    printf("Devrait-être 0 : %i\n", est_négatif(0));
    return 0;
}
