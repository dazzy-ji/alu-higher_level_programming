#!/bin/bash
# Script that sends a POST request with specific variables email and subject
curl -s -d "email=test@gmail.com&subject=I will always be here for PLD" "$1"
