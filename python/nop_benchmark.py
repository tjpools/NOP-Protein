# nop_benchmark.py
# Python program to count 'NOPs' (empty pass) executed in 1 second
import time

nops = 0
start = time.time()
while time.time() - start < 1:
    pass
    nops += 1
print(f"NOPs executed: {nops}")
