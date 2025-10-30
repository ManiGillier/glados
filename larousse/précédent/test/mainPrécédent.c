#include <stdio.h>
#include <unistd.h>
#include "../include/précédent.h"

int main(void)
{
    printf("Devrait-être 12 : %i\n", précédent(13));
    printf("Devrait-être -1 : %i\n", précédent(0));
    printf("Devrait-être -12 : %i\n", précédent(-11));
    return 0;
}
