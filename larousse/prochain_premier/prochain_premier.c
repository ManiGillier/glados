int est_premier_pour_test(int n)
{
    if (n == 1 || n == 0)
        return 0;
    for (int i = 2; i <= n;) {
        if ((n % i) == 0 && i != n)
            return 0;
        i++;
    }
    return 1;
}

int prochain_premier(int n)
{
    n++;
    while (!est_premier_pour_test(n))
    {
        n++;
    }
    return n;
}
