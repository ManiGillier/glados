#include <stdio.h>
#include <unistd.h>
#include "../include/prochain_premier.h"

int main(void)
{
    printf("Devrait-être 13 : %i\n", prochain_premier(12));
    printf("Devrait-être 2 : %i\n", prochain_premier(1));
    return 0;
}
