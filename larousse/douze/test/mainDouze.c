#include <stdio.h>
#include <unistd.h>
#include "../include/douze.h"

int main(void)
{
    printf("Devrait-être 3 : %i\n", douze(36));
    printf("Devrait-être 1 : %i\n", douze(12));
    printf("Devrait-être -12 : %i\n", douze(8));
    return 0;
}
