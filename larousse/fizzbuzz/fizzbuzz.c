#include <stdio.h>
#include <unistd.h>

int fizzbuzz(int n)
{
    if ((n % 3 == 0) && (n % 5 == 0)) {
        write (1, "FizzBuzz", 8);
        write (1, "\n", 1);
        return 0;
    }
    if (n % 3 == 0) {
        write (1, "Fizz", 4);
        write (1, "\n", 1);
        return 0;
    }
    if (n % 5 == 0) {
        write (1, "Buzz", 4);
        write (1, "\n", 1);
        return 0;
    }
    printf("%i\n", n);
    return 0;
}
