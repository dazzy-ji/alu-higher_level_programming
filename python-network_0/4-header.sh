#!/bin/bash
# Script that sends a GET request with a custom header X-School-User-Id set to 98
curl -sL -H "X-School-User-Id: 98" "$1"
