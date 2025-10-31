#include <stdio.h>
#include <unistd.h>
#include "../include/est_premier.h"

int main(void)
{
    printf("Devrait-être -1 : %i\n", est_premier(12));
    printf("Devrait-être 0 : %i\n", est_premier(13));
    printf("Devrait-être 0 : %i\n", est_premier(5));
    return 0;
}
