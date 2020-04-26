#!/usr/bin/env python
# vi: ts=4:sw=4:sts=4:et

import sys, bom

def main(args):
    b = bom.parse_xml(args)
    b.remove_boring_components()
    for w in b.warnings:
        print w.text

if __name__ == '__main__':
    main(sys.argv[1:])
