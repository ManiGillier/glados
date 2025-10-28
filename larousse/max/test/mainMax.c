#include <stdio.h>
#include <unistd.h>
#include "../include/max.h"

int main(void)
{
    printf("Devrait-être 24 : %i\n", max(12, 24));
    printf("Devrait-être 2400000 : %i\n", max(1200000, 2400000));
    printf("Devrait-être -12 : %i\n", max(-12, -24));
    return 0;
}
