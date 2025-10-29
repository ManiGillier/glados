#include <stdio.h>
#include <unistd.h>
#include "../include/additionner.h"

int main(void)
{
    printf("Devrait-être 12 : %i\n", additionner(3, 9));
    printf("Devrait-être 12 : %i\n", additionner(12, 0));
    printf("Devrait-être -12 : %i\n", additionner(-3, -9));
    return 0;
}
