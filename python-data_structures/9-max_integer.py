#!/usr/bin/python3def max_integer(my_list=[]):
    if len(my_list) == 0:
        return None
    biggest = my_list[0]
    for item in my_list:
        if item > biggest:
            biggest = item
    return biggest
