int est_premier(int n)
{
    for (int i = 2; i <= n;) {
        if ((n % i) == 0 && i != n)
            return -1;
        i++;
    }
    return 0;
}
