/*
    pi_spigot.c — short, clean C implementation of the integer spigot algorithm.

    Compile steps:
        gcc -O2 -std=c99 -Wall -Wextra pi_spigot.c -o pi_spigot
        ./pi_spigot

    To generate assembly for study:
        gcc -O2 -std=c99 -S pi_spigot.c -o pi_spigot.s
*/

#include <stdio.h>





#define NDIGITS 100
#define LEN (10*NDIGITS/3 + 1)

#include <stdio.h>

#define N 1000  // buffer size for internal precision
#define DIGITS 100

int main(void) {
    int a[N];
    int i, k, q, x, n = N;

    for (i = 0; i < n; i++) a[i] = 2;

    printf("3.");

    for (k = 0; k < DIGITS; k++) {
        q = 0;
        for (i = n - 1; i >= 0; i--) {
            x = a[i] * 10 + q * (i + 1);
            a[i] = x % (2 * (i + 1) + 1);
            q = x / (2 * (i + 1) + 1);
        }
        printf("%d", q / 10);
    }

    printf("\n");
    return 0;
}

