#!/usr/bin/env python

from sys import stdin

q = 0
for line in stdin:
    for ch in line:
        sym = '<space>' if ch == ' ' else '<newline>' if ch == '\n' else ch
        print '{0} {1} {2} {2}'.format(q, q+1, sym)
        q += 1
print q
