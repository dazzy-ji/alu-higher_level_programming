#!/usr/bin/python3
"""
This module provides a function to divide all elements of a matrix.
"""


def matrix_divided(matrix, div):
    """Divides all elements of a matrix by div.

    Args:
        matrix: A list of lists of integers or floats.
        div: Number (integer or float) to divide elements by.

    Returns:
        A new matrix containing the quotient rounded to 2 decimal places.

    Raises:
        TypeError: If matrix is invalid, rows differ in size, or div is not num.
        ZeroDivisionError: If div is equal to 0.
    """
    msg = "matrix must be a matrix (list of lists) of integers/floats"

    if not isinstance(matrix, list) or len(matrix) == 0:
        raise TypeError(msg)

    for row in matrix:
        if not isinstance(row, list) or len(row) == 0:
            raise TypeError(msg)
        for elem in row:
            if type(elem) not in (int, float):
                raise TypeError(msg)

    row_len = len(matrix[0])
    for row in matrix:
        if len(row) != row_len:
            raise TypeError("Each row of the matrix must have the same size")

    if type(div) not in (int, float):
        raise TypeError("div must be a number")

    if div == 0:
        raise ZeroDivisionError("division by zero")

    return [[round(elem / div, 2) for elem in row] for row in matrix]
