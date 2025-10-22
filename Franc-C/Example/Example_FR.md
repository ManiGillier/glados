# Exemple d'un fizzbuzz :

++Voici un `Fizzbuzz`, ce code imprime `Fizz`, `Buzz`, ou affiche le nombre en fonction de sa valeur.++

```fr
Bonjour,

J'aimerais définir le bloc répondant au nom de fizzbuzz, de type de retour nul, nécessitant comme entrée :
; contenant les variables :
    - compteur, de type entier naturel, valant 0
; représenté par le code ci-après.



    Tant que compteur est inférieure à 100 exécute le code ci-après :

        Si compteur modulo 3 est égale à 0, exécute le texte :
            Affiche « Fizz ».
        Merci.

        Si compteur modulo 5 est égale à 0, exécute le texte :
            Affiche « Buzz ».
        Merci.

        Si compteur modulo 3 est différent de 0 et compteur modulo 5 est différent de 0, exécute le texte :
            Affiche compteur.
        Merci.

        Affiche un retour à la ligne.

    Merci.

Merci.
```

++D'abord la fonction est définie avec une variable nommée "compteur" qui est une entier naturel valant zéro.++
```
Bonjour,

J'aimerais définir le bloc répondant au nom de fizzbuzz, de type de retour nul, nécessitant comme entrée :
; contenant les variables :
    - compteur, de type entier naturel, valant 0
; représenté par le code ci-après.
```


++Ici une boucle est créé, et le code a l'interieur de la boucle sera executé tant que compteur (créé précedemment) sera inferieur à 100.++
```
    Tant que compteur est inférieure à 100 exécute le code ci-après :

```


++Le bloc ci dessous est le code qui sera executé 100 fois.++
++La première condition `Si compteur modulo 3 est égale à 0, exécute le texte :` signifie que si la variable compteur est un multiple de 3 alors le texte inferieur `Affiche « Fizz »` s'active, et affiche la suite de caractères "Fizz". Puis le bloc conditionnel se terminera avec la formule de politesse `Merci.`++

++La seconde condition `Si compteur modulo 5 est égale à 0, exécute le texte :` activera le texte `Affiche « Fizz ».` seulement si la variable compteur est un multiple de 5, et dans ce cas affichera "Buzz".++

++La dernière condition `Si compteur modulo 3 est différent de 0 et compteur modulo 5 est différent de 0, exécute le texte :` ne s'activera que dans le cas où le nombre n'est ni un multiple de 3 ni de 5, et executera le text `Affiche compteur.` qui imprimera a l'écran la valeur de la variable compteur, qui est toujours un entier natural++
```
        Si compteur modulo 3 est égale à 0, exécute le texte :
                    Affiche « Fizz ».
        Merci.
        Si compteur modulo 5 est égale à 0, exécute le texte :
                    Affiche « Buzz ».
        Merci.
        Si compteur modulo 3 est différent de 0 et compteur modulo 5 est différent de 0, exécute le texte :
            Affiche compteur.
        Merci.
```

++Enfin le bloc de code ci dessous imprime un retour a la ligne a la fin de chaque boucle++
```

        Affiche un retour à la ligne.
```

++Pour finir les deux lignes ci dessous arrêtent premièrement la boucle et secondement la fonction avec les formules de politesse `Merci.`++
```
    Merci.
Merci.
```
