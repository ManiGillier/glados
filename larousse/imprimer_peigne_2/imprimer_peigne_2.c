/*
** EPITECH PROJECT, 2023
** day03
** File description:
** print combinations
*/

#include <stdio.h>
#include <unistd.h>

void my_put_nbr(long int n)
{
    if (n < 0){
        write (1, "-", 1);
        n = -n;
    } if (n > 9)
        my_put_nbr(n / 10);
    n = (n % 10) + '0';
    write(1, &n, 1);
    return;
}

int puissance(int puissancé, int puissance)
{
    int àRenvoyer = puissancé;
    int i = 1;

    while (i < puissance) {
        àRenvoyer = àRenvoyer * puissancé;
        i++;
    }
    return puissance == 0 ? 1 : àRenvoyer;
}


int compter_chiffres(int number)
{
    int i = 0;

    while (number > 0) {
        i++;
        number = number / 10;
    }
    return i;
}

int trèsGrosNombre(int n)
{
    int àRenvoyer = 0;
    int i = n - 1;

    while (i >= 0) {
        àRenvoyer = àRenvoyer + (9 * puissance(10, i));
        i--;
    }
    return àRenvoyer;
}

int petiteCompositionZero(int chiffre, int combien)
{
    int nouveauChiffre = chiffre / 10;
    int dernierStocké = chiffre % 10;
    int i = 0;

    while (i < combien - 2) {
        if (nouveauChiffre % 10 < dernierStocké) {
            dernierStocké = nouveauChiffre % 10;
            nouveauChiffre = nouveauChiffre / 10;
        } else {
            return 0;
        }
        i++;
    }
    return dernierStocké > 0;
}


int petiteComposition(int chiffre, int combien)
{
    int nouveauChiffre = chiffre / 10;
    int dernierStocké = chiffre % 10;
    int i = 0;

    while (i < combien - 1) {
        if (nouveauChiffre % 10 < dernierStocké) {
            dernierStocké = nouveauChiffre % 10;
            nouveauChiffre = nouveauChiffre / 10;
        } else {
            return 0;
        }
        i++;
    }
    return 1;
}


int verifier_la_composition(int chiffre, int combien)
{
    if (combien - compter_chiffres(chiffre) > 1) {
        return 0;
    } else if (combien - compter_chiffres(chiffre) == 1) {
        return petiteCompositionZero(chiffre, combien);
    } else {
        return petiteComposition(chiffre, combien);
    }
}

int est_de_composition_maximale(int chiffre, int combien)
{
    int aSupprimer = 0;
    int chiffreAttendu = 0;
    int maxAtteignable = trèsGrosNombre(combien);
    int i = 0;

    while (i < combien) {
        chiffreAttendu = (maxAtteignable % 10) - aSupprimer;
        if (chiffreAttendu == chiffre % 10) {
            aSupprimer++;
            chiffre = chiffre / 10;
            maxAtteignable = maxAtteignable / 10;
        } else {
            return 0;
        }
        i++;
    }
    return 1;
}


void affichage(int n, int combien)
{
    if (compter_chiffres(n) != combien)
        my_put_nbr(0);
    my_put_nbr(n);
    if (!est_de_composition_maximale(n, combien)) {
        write(1,",",1);
        write(1," ",1);
    }
}

int imprimer_peigne_nombre(int n)
{
    int plusGrandNombreAtteignable = trèsGrosNombre(n);
    int i = 0;

    while (i <= plusGrandNombreAtteignable) {
        if (verifier_la_composition(i, n))
            affichage(i, n);
        i++;
    }
    return 0;
}

int imprimer_peigne_2()
{
    return imprimer_peigne_nombre(4);
}
