#include <stdio.h>
#include <unistd.h>
#include "../include/est_en_minuscule.h"

int main(void)
{
    printf("Devrait-être 1 : %i\n", est_en_minuscule('m'));
    printf("Devrait-être 0 : %i\n", est_en_minuscule('M'));
    printf("Devrait-être 0 : %i\n", est_en_minuscule(12));
    return 0;
}
