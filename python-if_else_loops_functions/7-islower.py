#!/usr/bin/python3
"""Module that checks for lowercase character."""


def islower(c):
    """Return True if c is lowercase, False otherwise."""
    return ord('a') <= ord(c) <= ord('z')
