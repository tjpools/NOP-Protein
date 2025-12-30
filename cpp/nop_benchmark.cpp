// nop_benchmark.cpp
// C++ program to count NOPs (empty inline asm) executed in 1 second
#include <iostream>
#include <ctime>

int main() {
    volatile unsigned long long nops = 0;
    std::time_t start = std::time(nullptr);
    while (std::time(nullptr) - start < 1) {
        __asm__ __volatile__("nop");
        nops++;
    }
    std::cout << "NOPs executed: " << nops << std::endl;
    return 0;
}
