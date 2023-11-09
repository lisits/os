#!/usr/bin/env python3
import os
import sys
import signal
import time

def handler(signum, frame):
    global expressions_count
    print(f"Produced: {expressions_count}")

def main():
    global expressions_count
    expressions_count = 0

    def run_producer(pipe_write):
        os.close(pipe_write[0])
        os.dup2(pipe_write[1], sys.stdout.fileno())
        os.execvp("python3", ["python3", "producer.py"])

    def run_bc(pipe_read, pipe_write):
        os.close(pipe_read[1])
        os.dup2(pipe_read[0], sys.stdin.fileno())
        os.close(pipe_write[0])
        os.dup2(pipe_write[1], sys.stdout.fileno())
        os.execvp("/usr/bin/bc", ["bc"])


    pipe1_0 = os.pipe()
    pipe0_2 = os.pipe()
    pipe2_0 = os.pipe()

    pid_p1 = os.fork()

    if pid_p1 ==0:
        run_producer(pipe1_0)

    pid_p2 = os.fork()

    if pid_p2 == 0:
        run_bc(pipe0_2, pipe2_0)

    os.close(pipe1_0[1])
    os.close(pipe0_2[0])
    os.close(pipe2_0[1])

    signal.signal(signal.SIGUSR1, handler)

    expressions = []
    results = []

    while True:
        expression = os.read(pipe1_0[0], 128)
        if not expression:
            break
        expressions_count += 1
        expressions.append(expression)

    for expression in expressions:
        os.write(pipe0_2[1], expression)
        result = os.read(pipe2_0[0], 128)
        results.append(result)

    x = expressions[0].decode().strip().splitlines()
    y = results[0].decode().strip().splitlines()

    for expression, result in zip(x, y):
        print(f"{expression} = {result}")

    os.waitpid(pid_p1, 0)
    os.waitpid(pid_p2, 0)


main()


