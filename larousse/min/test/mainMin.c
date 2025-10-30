#include <stdio.h>
#include <unistd.h>
#include "../include/min.h"

int main(void)
{
    printf("Devrait-être 12 : %i\n", min(12, 24));
    printf("Devrait-être 1200000 : %i\n", min(1200000, 2400000));
    printf("Devrait-être -24 : %i\n", min(-12, -24));
    return 0;
}
