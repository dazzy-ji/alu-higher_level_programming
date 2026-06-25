#!/usr/bin/python3
def uppercase(str):
    for i in str:
        ascii_val = ord(i)
        if 97 <= ascii_val <= 122:
            i = chr(ascii_val - 32)
         print("{}".format(i), end="")
     print("")
