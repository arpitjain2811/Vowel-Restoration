#!/usr/bin/env python

from sys import stdin

state = 0
tok = ''
while True:
    line = stdin.readline()
    if not line:
        break
    f = line.split()
    if len(f) < 4:
        continue
    if f[3] == '<t>':
        continue
    elif f[3] == '</t>':
        print tok
        tok = ''
    elif f[3] == '<epsilon>':
        continue
    # Add spaces if they are included
    elif f[3] == '<space>':
        tok += ' '
    # Newlines become spaces
    elif f[3] == '<newline>':
        tok += '\n'
    else:
        tok += f[3]
print tok