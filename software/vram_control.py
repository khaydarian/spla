#!/usr/bin/env python3
# vi: ts=4:sw=4:sts=4:et

import sys, re

for line in open(sys.argv[1]):
    line = line.strip()
    m = re.match("localparam (OPCODE_[A-Z0-9_]+) *= * 8'h([0-9a-f][0-9a-f]);", line)
    if m is None:
        continue
    name, val = m.groups()
    print("static const uint8_t %s = 0x%s;" % (name, val))
