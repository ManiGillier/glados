# Introduction (motives)

As programming using Franc C can easily become overwhelming, we decided to provide a set of already implemented functions, in a library called `Larousse`, as a way to facilitate some tasks.

`Larousse` also serves as a way to showcase our language's capabilities, and demonstrate its verbose syntax, and acts as a test suite for the `Académie Franc C'Aise`, which runs functional tests on it.

# Functions

|     Functions               |     Parameters               |     Description                                                           |        Benchmark*        |
|     :------------------     |     :------------------:     |     :---------------------------------------------------------------:     |     ----------------:    |
|     [`additionner`](https://github.com/ManiGillier/glados/blob/dev/larousse/additionner/additionner.fr)             |    `nombre`, `second_nombre`     |     Returns `nombre + second_nombre`.                                     |       0.086s             |
|     [`afficher_nombre`](https://github.com/ManiGillier/glados/blob/dev/larousse/afficher_nombre/afficher_nombre.fr)         |    `nombre`                    |     Displays in the standard output the number `nombre`.                  |       0.067s             |
|     [`carré_de`](https://github.com/ManiGillier/glados/blob/dev/larousse/carr%C3%A9_de/carr%C3%A9_de.fr)                |    `nombre`                    |     Returns `nombre * nombre`.                                            |       0.074s             |
|     [`diviser`](https://github.com/ManiGillier/glados/blob/dev/larousse/diviser/diviser.fr)                 |    `nombre`, `second_nombre`     |     Returns `nombre / second_nombre`.                                     |       0.060s             |
|     [`douze`](https://github.com/ManiGillier/glados/blob/dev/larousse/douze/douze.fr)                   |    `nombre`                    |     Returns `nombre / 12` if `nombre` is multiple of 12, otherwise `-1`.  |       0.069s             |
|     [`est_en_majuscule`](https://github.com/ManiGillier/glados/blob/dev/larousse/est_en_majuscule/est_en_majuscule.fr)        |    `nombre`                    |     Returns `1` if `nombre` is an uppercase letter, otherwise `0`.        |       0.063s             |
|     [`est_en_minuscule`](https://github.com/ManiGillier/glados/blob/dev/larousse/est_en_minuscule/est_en_minuscule.fr)        |    `nombre`                    |     Returns `1` if `nombre` is a lowercase letter, otherwise `0`.         |       0.060s             |
|     [`est_négatif`](https://github.com/ManiGillier/glados/blob/dev/larousse/est_n%C3%A9gatif/est_n%C3%A9gatif.fr)             |    `nombre`                    |     Returns `1` if `nombre` is negative, otherwise `0`.                   |       0.070s             |
|     [`est_premier`](https://github.com/ManiGillier/glados/blob/dev/larousse/est_premier/est_premier.fr)             |    `nombre`                    |     Returns `1` if `nombre` is a prime number, otherwise `0`.             |       0.051s             |
|     [`fizzbuzz`](https://github.com/ManiGillier/glados/blob/dev/larousse/fizzbuzz/fizzbuzz.fr)                |    `nombre`                    |     Displays « Fizz » if `nombre` is multiple of 3, « Buzz » if multiple of 5, and « FizzBuzz » if multiple of both, otherwise displays `nombre`.             |       0.056s             |
|     [`imprimer_peigne`](https://github.com/ManiGillier/glados/blob/dev/larousse/imprimer_peigne/imprimer_peigne.fr)         |    -                         |     Displays in ascending order all the smallest numbers composed of three digits. |   0.220s    |
|     [`imprimer_peigne_2`](https://github.com/ManiGillier/glados/blob/dev/larousse/imprimer_peigne_2/imprimer_peigne_2.fr)       |    -                         |     Displays in ascending order all the smallest numbers composed of four digits.  |    8.481s   |
|     [`imprimer_peigne_nombre`](https://github.com/ManiGillier/glados/blob/dev/larousse/imprimer_peigne_nombre/imprimer_peigne_nombre.fr)  |    `nombre`                    |     Displays in ascending order all the smallest numbers composed of `nombre` digits. |   Depends |
|     [`max`](https://github.com/ManiGillier/glados/blob/dev/larousse/max/max.fr)                     |    `nombre`, `second_nombre`     |     Returns `nombre` if `nombre` is superior than `second_nombre`, otherwise `second_nombre`.                                    |       0.060s
|     [`min`](https://github.com/ManiGillier/glados/blob/dev/larousse/min/min.fr)                     |    `nombre`, `second_nombre`     |     Returns `second_nombre` if `nombre` is superior than `second_nombre`, otherwise `nombre`.                                    |       0.092s
|     [`multiplier`](https://github.com/ManiGillier/glados/blob/dev/larousse/multiplier/multiplier.fr)              |    `nombre`, `second_nombre`     |     Returns `nombre * second_nombre`.                                     |       0.065s             |
|     [`prochain_premier`](https://github.com/ManiGillier/glados/blob/dev/larousse/prochain_premier/prochain_premier.fr)        |    `nombre`                    |     Returns the first prime number greater than `nombre`.                 |       0.072s             |
|     [`précedent`](https://github.com/ManiGillier/glados/blob/dev/larousse/pr%C3%A9c%C3%A9dent/pr%C3%A9c%C3%A9dent.fr)               |    `nombre`                    |     Returns `nombre - 1`.                                                 |       0.069s             |
|     [`racine_carré_de`](https://github.com/ManiGillier/glados/blob/dev/larousse/racine_carr%C3%A9_de/racine_carr%C3%A9_de.fr)         |    `nombre`                    |     Returns the integer square root of `nombre`.                          |       0.070s             |
|     [`soustraire`](https://github.com/ManiGillier/glados/blob/dev/larousse/soustraire/soustraire.fr)              |    `nombre`, `second_nombre`     |     Returns `nombre - second_nombre`.                                     |       0.090s             |
|     [`suivant`](https://github.com/ManiGillier/glados/blob/dev/larousse/suivant/suivant.fr)               |    `nombre`                      |     Returns `nombre + 1`.                                                 |       0.065s             |  


(*) Benchmark specs:
```
CPU : Intel i9 14900K
GPU : NVIDIA RTX 4070 TI SUPER
RAM: 32 GB
```

# Académie Franc C'Aise

`Académie Franc C'Aise` is the `functional tester` made in `Python` for the `Franc C`, and uses `Larousse` standard library.

You will find in every single `Larousse` source code function:
- The same function written in `C`.
- A main function in `Franc C` which calls the function in `Franc C` with various parameter, in the `test` folder.
- A main function in `C` which calls the function in `C` with the same parameters, in the `test` folder.

`Académie Franc C'Aise` compiles both the `C` and `Franc C` version using `gcc` and `fcvm`. It then runs both versions, and check whether their inputs are the same as a way to test the language. It also displays how much time each step took (Compilation, Execution) for both languages then finally shows the time difference between those.

`Franc C` is in most cases faster to compile than `C`. However, `C` is almost always faster in execution time than `Franc C`.

At the end of the program, `Académie Franc C'Aise` displays how many tests passed out of how many were run. It then exits with a failure if not all tests passed.
