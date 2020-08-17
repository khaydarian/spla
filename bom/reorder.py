#!/usr/bin/env python3
# vi: ts=4:sw=4:sts=4:et

import sys, os.path, argparse
ACCOUNTING_DIR = os.path.join(os.path.dirname(sys.argv[0]), '../accounting')
sys.path.append(ACCOUNTING_DIR)
import bom
import txtdb

def main(args):
    parser = argparse.ArgumentParser()
    parser.add_argument(
            '-n', '--num-boards', type=int, default=0,
            help='Number of boards to order parts for.')
    parser.add_argument(
            '--bom', type=str, default=None,
            help='BoM xml file.')
    args = parser.parse_args()
    num_boards_to_order = args.num_boards

    db = txtdb.Txtdb()
    db.parse_file(os.path.join(ACCOUNTING_DIR, 'board.txtdb'))
    db.parse_file(os.path.join(ACCOUNTING_DIR, 'board-used.txtdb'))

    b = bom.parse_xml(args.bom)
    b.remove_boring_components()

    bom_by_digikey = {}
    for c in b.components:
        if c.digikey == 'N/A':
            continue
        if c.digikey not in bom_by_digikey:
            bom_by_digikey[c.digikey] = []
        bom_by_digikey[c.digikey].append(c)

    inv_by_digikey = {}
    desc_by_digikey = {}
    for obj, digikey in db.objects_with_field('Digikey Product Id'):
        if digikey not in inv_by_digikey:
            inv_by_digikey[digikey] = []
        inv_by_digikey[digikey].append(obj)
        desc_by_digikey[digikey] = obj.get('Digikey Description')

    for digikey in inv_by_digikey.keys():
        if digikey not in bom_by_digikey:
            print("Warning: Deprecated inventory part:", digikey,
                file=sys.stderr)

    for digikey in bom_by_digikey.keys():
        if digikey not in desc_by_digikey:
            print("Warning: BoM part not in inventory:", digikey,
                file=sys.stderr)

    order = []

    parts = []
    for digikey in bom_by_digikey.keys():
        desc = desc_by_digikey.get(digikey, "<Digikey Description Unknown>")
        if 'CONN HEADER VERT' in desc:
            # These suck.
            continue
        need = len(bom_by_digikey[digikey])
        quantity = 0
        remaining = 0
        for c in inv_by_digikey.get(digikey, []):
            quantity += int(c.get('Quantity'))
            remaining += int(c.get('Remaining'))
        nboards = remaining // need
        parts.append((nboards, digikey, desc, need, quantity, remaining))

        num_to_order = (num_boards_to_order * need) - remaining
        if num_to_order > 0:
            order.append((digikey, num_to_order))

    parts.sort()

    if num_boards_to_order:
        for digikey, count in order:
            print('%d,%s' % (count, digikey))
    else:
        print('Board Need  Remaining : Digikey ID (Description)')
        for nboards, digikey, desc, need, quantity, remaining in parts:
            print('B %3d N %3d R %3d/%3d : %-20s (%s)' % (
                nboards, need, remaining, quantity, digikey, desc))

    print('(Also check on pinheaders manually.)', file=sys.stderr)


if __name__ == '__main__':
    main(sys.argv[1:])
