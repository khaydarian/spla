#!/usr/bin/env python
# vi: ts=4:sw=4:sts=4:et

import sys, re

nametable = {}

for line in open(sys.argv[1]):
    line = line.strip()
    m = re.match('parameter (PINDEF[A-Z0-9_]*) = ([0-9]+);', line)
    if m is None:
        raise ValueError('Bad line: %r' % line)
    name, val = m.groups()
    val = int(val)
    print '#define %s %d' % (name, val)
    if name in ('PINDEFMIN', 'PINDEFMAX'):
        continue
    assert name.startswith('PINDEF_');
    lowername = name[7:].lower()
    nametable[val] = lowername

print 'const char* pindef_name[] = {'
for i in xrange(max(nametable.keys())+1):
    print '  "%s",' % nametable.get(i, "(n/a)")
print '};'
