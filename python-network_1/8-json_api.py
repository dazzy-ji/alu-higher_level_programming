#!/usr/bin/python3
"""Sends a POST request with a letter search parameter."""
import sys
import requests


if __name__ == "__main__":
    letter = sys.argv[1] if len(sys.argv) > 1 else ""
    url = "http://0.0.0.0:5000/search_user"
    
    try:
        r = requests.post(url, data={'q': letter})
        json_res = r.json()
        if json_res:
            user_id = json_res.get('id')
            user_name = json_res.get('name')
            print("[{}] {}".format(user_id, user_name))
        else:
            print("No result")
    except ValueError:
        print("Not a valid JSON")
