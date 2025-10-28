#include <stddef.h>
#include <unistd.h>
#include <stdio.h>

void afficher_nombre(long int n)
{
    if (n < 0){
        write (1, "-", 1);
        n = -n;
    } if (n > 9)
        afficher_nombre(n / 10);
    n = (n % 10) + '0';
    write(1, &n, 1);
    return;
}
