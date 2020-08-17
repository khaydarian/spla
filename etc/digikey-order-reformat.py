#!/usr/bin/env python3
# vi: ts=4:sw=4:sts=4:et

import sys, argparse


def guess_manufacturer(product_id):
    if product_id.startswith('RMCF'):
        return 'Stackpole Electronics Inc'
    if product_id.startswith('GCJ'):
        return 'Murata Electronics'
    if product_id.startswith('GRM'):
        return 'Murata Electronics'
    if product_id == 'RK73Z1JTTD':
        return 'KOA Speer Electronics Inc.'
    return 'xxxxxxx'


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('input')
    parser.add_argument('--package', type=str)
    args = parser.parse_args()

    lines = open(args.input).read().replace('\u200e', '').splitlines()
    block_size = 7
    blocks = [lines[i:i+block_size] for i in range(0, len(lines), block_size)]

    i = 1
    for b in blocks:
        assert b[0] == str(i), 'Formatting is bogus'
        i += 1
        digikey = b[1].upper()
        mfgid = b[2].upper()
        digikey_desc = b[3]
        quantity = int(b[4].strip())
        assert b[5] == 'Immediate', 'Not immediate?'
        cost_per, cost_tot = b[6].split()

        print('Name: xxxxx') # Fill manually
        print('Category: Board Parts')
        print('From Package Key:', args.package)
        print('Digikey Product Id:', digikey)
        print('Digikey Description:', digikey_desc)
        print('Manufacturer:', guess_manufacturer(mfgid))
        print('Manufacturer Product Id:', mfgid)
        print('Unit Cost:', '$'+cost_per)
        print('Cost:', cost_tot)
        print('Quantity:', quantity)
        print('Remaining:', quantity)
        print('')


if __name__ == '__main__':
    main()
