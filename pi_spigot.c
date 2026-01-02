/*
    pi_spigot.c — short, clean C implementation of the integer spigot algorithm.

    Compile steps:
        gcc -O2 -std=c99 -Wall -Wextra pi_spigot.c -o pi_spigot
        ./pi_spigot

    To generate assembly for study:
        gcc -O2 -std=c99 -S pi_spigot.c -o pi_spigot.s
*/

#include <math.h>
#include <stdio.h>

#define N 100

int main() {
    // Array size is calculated as floor(10*N/3) + 1, sufficient for N digits
    int len = (int)floor(10.0 * N / 3.0) + 1;
    int A[len];

    // Initialize the array to all 2s
    for (int i = 0; i < len; ++i) {
        A[i] = 2;
    }

    int nines = 0;
    // removed unused predigit

    printf("3."); // The first digit is always 3

    int prev_predigit = -1;
    // Main loop to generate N digits
    for (int j = 1; j <= N; ++j) {
        int q = 0;
        // Inner loop performs the base conversion and carries
        for (int i = len - 1; i >= 0; --i) {
            int x = 10 * A[i] + q * (i + 1);
            A[i] = x % (2 * i + 1);
            q = x / (2 * i + 1);
        }

        A[0] = q % 10;
        q = q / 10;

        if (prev_predigit == -1) {
            // First calculated digit after decimal
            prev_predigit = q;
            continue;
        }
        if (q == 9) {
            ++nines;
        } else if (q == 10) {
            printf("%d", prev_predigit + 1);
            for (int k = 0; k < nines; ++k) {
                printf("0");
            }
            prev_predigit = 0;
            nines = 0;
        } else {
            printf("%d", prev_predigit);
            prev_predigit = q;
            if (nines) {
                for (int k = 0; k < nines; ++k) {
                    printf("9");
                }
                nines = 0;
            }
        }
    }
    printf("%d\n", prev_predigit); // Print the last held predigit

    return 0;
}

