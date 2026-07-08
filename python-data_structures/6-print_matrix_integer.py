#!/usr/bin/python3
def print_matrix_integer(matrix=[[]]):
    for row in matrix:
        line = ""
        for i in range(len(row)):
            if i != 0:
                line += " "
            line += "{:d}".format(row[i])
        print(line)
