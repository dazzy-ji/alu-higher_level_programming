#!/bin/bash
# Script that takes in a URL, sends a request, and displays the size of the body of the response in bytes
curl -sI "$1" | grep -i "^Content-Length:" | awk '{print $2}' | tr -d '\r'
