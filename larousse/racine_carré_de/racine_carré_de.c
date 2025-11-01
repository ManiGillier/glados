int racine_carré_de(int n)
{
    for (int i = 0; i <= n;) {
        if ((i * i) == n)
            return i;
        i++;
    }
    return -1;
}
