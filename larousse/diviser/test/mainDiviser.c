#include <stdio.h>
#include <unistd.h>
#include "../include/diviser.h"

int main(void)
{
    printf("Devrait-être 12 : %i\n", diviser(48, 4));
    printf("Devrait-être 0 : %i\n", diviser(0, 12));
    printf("Devrait-être -12 : %i\n", diviser(-48, 4));
    return 0;
}
