#!/usr/bin/env python3
# vi: ts=4:sw=4:sts=4:et

import sys, argparse
import bom

def main(args):
    parser = argparse.ArgumentParser()
    parser.add_argument(
            '--bom', type=str, default=None,
            help='BoM xml file.')
    args = parser.parse_args()
    b = bom.parse_xml(args.bom)
    b.remove_boring_components()
    if len(b.warnings):
        for w in b.warnings:
            print(w.text)
    digikey = {}
    for c in b.components:
        if c.digikey == 'N/A':
            continue
        if c.digikey not in digikey:
            digikey[c.digikey] = []
        digikey[c.digikey].append(c.ref)
    for digikey, refs in sorted(digikey.items()):
        print('%d,%s,%s' % (len(refs), digikey, '/'.join(refs)))

if __name__ == '__main__':
    main(sys.argv[1:])
