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
    for w in b.warnings:
        print(w.text)
    else:
        print('ok')

if __name__ == '__main__':
    main(sys.argv[1:])
