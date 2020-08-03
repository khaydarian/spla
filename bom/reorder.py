#!/usr/bin/env python3
# vi: ts=4:sw=4:sts=4:et

import sys, os.path, bom
ACCOUNTING_DIR = os.path.join(os.path.dirname(sys.argv[0]), '../accounting')
sys.path.append(ACCOUNTING_DIR)
import txtdb

def main(args):

    db = txtdb.Txtdb()
    db.parse_file(os.path.join(ACCOUNTING_DIR, 'board.txtdb'))
    db.parse_file(os.path.join(ACCOUNTING_DIR, 'board-used.txtdb'))

    b = bom.parse_xml(args)
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

    digikeys = set(bom_by_digikey.keys()).union(set(inv_by_digikey.keys()))

    error = False
    for digikey in digikeys:
        if digikey in bom_by_digikey and digikey not in inv_by_digikey:
            print("Only in BOM:", digikey)
            error = True
        if digikey not in bom_by_digikey and digikey in inv_by_digikey:
            print("Only in INV:", digikey)
            error = True
    if error:
        return

    parts = []
    for digikey in digikeys:
        desc = desc_by_digikey[digikey]
        if 'CONN HEADER VERT' in desc:
            # These suck.
            continue
        need = len(bom_by_digikey[digikey])
        quantity = 0
        remaining = 0
        for c in inv_by_digikey[digikey]:
            quantity += int(c.get('Quantity'))
            remaining += int(c.get('Remaining'))
        nboards = remaining // need
        parts.append((nboards, digikey, desc, need, quantity, remaining))

    parts.sort()

    for nboards, digikey, desc, need, quantity, remaining in parts:
        print('B %2d N %3d R %3d/%3d : %-20s (%s)' % (
            nboards, need, remaining, quantity, digikey, desc))
        #print "--- %s (%s)" % (digikey, desc)
        #print "Boards %d, Need %d per board, Remaining %d / %d" % (
        #        nboards, need, remaining, quantity)

    print("(Also check on pinheaders manually.)")

if __name__ == '__main__':
    main(sys.argv[1:])
