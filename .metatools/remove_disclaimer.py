import re


with open(".metatools/example.m", "r") as f:
    content = f.read()
    
    lines = content.split("\n")
    