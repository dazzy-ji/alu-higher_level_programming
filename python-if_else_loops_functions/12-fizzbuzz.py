#!/usr/bin/python3
"""Module that prints FizzBuzz from 1 to 100."""


def fizzbuzz():
    """Print numbers 1-100 with Fizz, Buzz, FizzBuzz substitutions."""
    for i in range(1, 101):
        if i % 3 == 0 and i % 5 == 0:
            print("FizzBuzz ", end="")
        elif i % 3 == 0:
            print("Fizz ", end="")
        elif i % 5 == 0:
            print("Buzz ", end="")
        else:
            print("{} ".format(i), end="")
