// nop_benchmark.c
// C program to count NOPs (empty inline asm) executed in 1 second
#include <stdio.h>
#include <time.h>

int main() {
    volatile unsigned long long nops = 0;
    time_t start = time(NULL);
    while (time(NULL) - start < 1) {
        __asm__ __volatile__("nop");
        nops++;
    }
    printf("NOPs executed: %llu\n", nops);
    return 0;
}
