#include <stdio.h>
#include <unistd.h>
#include "../include/multiplier.h"

int main(void)
{
    printf("Devrait-être 12 : %i\n", multiplier(3, 4));
    printf("Devrait-être 0 : %i\n", multiplier(12, 0));
    printf("Devrait-être -12 : %i\n", multiplier(-3, 4));
    return 0;
}
