#include <stdio.h>
#define N 100

int main()
{
    int len = (10 * N / 3) + 1;
    int A[len];
    for (int i = 0; i < len; ++i)
        A[i] = 2;
    int nines = 0, predigit = 0;
    // Step 1: Generate and print the integer part (3)
    int q = 0;
    for (int i = len; i > 0; --i) {
        int x = 10 * A[i - 1] + q * i;
        A[i - 1] = x % (2 * i - 1);
        q = x / (2 * i - 1);
    }
    A[0] = q % 10;
    q = q / 10;
    printf("%d.", q); // Print integer part and decimal point

    // Step 2: Generate and hold the first fractional digit
    q = 0;
    for (int i = len; i > 0; --i) {
        int x = 10 * A[i - 1] + q * i;
        A[i - 1] = x % (2 * i - 1);
        q = x / (2 * i - 1);
    }
    A[0] = q % 10;
    predigit = q / 10;

    // Step 3: Main loop for remaining digits
    for (int j = 2; j <= N; ++j) {
        q = 0;
        for (int i = len; i > 0; --i) {
            int x = 10 * A[i - 1] + q * i;
            A[i - 1] = x % (2 * i - 1);
            q = x / (2 * i - 1);
        }
        A[0] = q % 10;
        q = q / 10;
        if (q == 9) {
            nines++;
        } else if (q == 10) {
            printf("%d", predigit + 1);
            for (int k = 0; k < nines; ++k) printf("0");
            predigit = 0;
            nines = 0;
        } else {
            printf("%d", predigit);
            for (int k = 0; k < nines; ++k) printf("9");
            predigit = q;
            nines = 0;
        }
    }
    printf("%d\n", predigit);
    return 0;
}
