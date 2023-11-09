#!/opt/user/bin/python3
import random
import time

N = random.randint(12, 18)

for _ in range(N):
    X = random.randint(1, 9)
    O = random.choice(['+', '-', '*', '/'])
    Y = random.randint(1, 9)
    print(f"{X} {O} {Y}")
    time.sleep(1)


