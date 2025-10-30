#include <stdio.h>
#include <unistd.h>
#include "../include/afficher_nombre.h"

int main(void)
{
    afficher_nombre(2147483647);
    write(1, "\n", 1);
    afficher_nombre(12);
    write(1, "\n", 1);
    afficher_nombre(0);
    write(1, "\n", 1);
    afficher_nombre(-12);
    write(1, "\n", 1);
    afficher_nombre(-2147483648);
    write(1, "\n", 1);
    return 0;
}
