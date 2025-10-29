#include <stdio.h>
#include <unistd.h>
#include "../include/est_en_majuscule.h"

int main(void)
{
    printf("Devrait-être 1 : %i\n", est_en_majuscule('m'));
    printf("Devrait-être 0 : %i\n", est_en_majuscule('M'));
    printf("Devrait-être 0 : %i\n", est_en_majuscule(12));
    return 0;
}
