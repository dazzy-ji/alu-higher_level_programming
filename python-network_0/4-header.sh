#!/bin/bash
# Script that sends a GET request with a custom header X-HolbertonSchool-User-Id set to 98
curl -sH "X-HolbertonSchool-User-Id: 98" "$1"
