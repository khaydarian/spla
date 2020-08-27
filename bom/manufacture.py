#!/usr/bin/env python3
# vi: ts=4:sw=4:sts=4:et

import sys
import os.path
import argparse
import bom
ACCOUNTING_DIR = os.path.join(os.path.dirname(sys.argv[0]), '../accounting')
sys.path.append(ACCOUNTING_DIR)
import txtdb

GREEN = '[92m'
RESET = '[m'

class Stage(object):
    def __init__(self, name, refs):
        self.name = name
        self.refs = refs.split()

    def show(self, c_by_ref, desc_by_digikey):
        print("----- %s -----" % self.name)
        components_by_digikey = {}
        for r in self.refs:
            if r not in c_by_ref:
                # Probably a boring component
                continue
            c = c_by_ref[r]
            if c.digikey not in components_by_digikey:
                components_by_digikey[c.digikey] = []
            components_by_digikey[c.digikey].append(c)

        digikeys = list(components_by_digikey.keys())
        digikeys.sort(key=lambda d: refsortkey(components_by_digikey[d][0].ref))
        for digikey in digikeys:
            if digikey == 'N/A':
                continue
            components = components_by_digikey[digikey]
            print('[%-20s] %s%s%s (%r)' % (
                digikey, GREEN, desc_by_digikey[digikey], RESET, onlyvalue(components)))
            print(' ', ' '.join([c.ref for c in components]))

def onlyvalue(vs):
    for v in vs:
        if v.value != vs[0].value:
            return "various"
    return vs[0].value

def refsortkey(ref):
    if ref.startswith('R'):
        return (1, ref)
    if ref.startswith('C'):
        return (2, ref)
    return (0, ref)

STAGES = [
    Stage("Back:Stencil:FTDI", """
C1 C2 C3 C4
C14 C51 C52 C60 C64
R1 R2 R4 R8
R20 R25 R26 R27 R39 R40 R50 R51 R52 R53 R59
R38 C67 C72
X1
       """),
    Stage("Back:Stencil:FPGA", """
C29 R6
C11 C12 C25 C29 C32 C30
C22 C27 C34 C26 C23 C28 C33 C31 C21 C24 C20
            """),
    Stage("Back:Stencil:Analog", """
C107 C108 C151 C152 C153 C154
C207 C208 C251 C252 C253 C254
C307 C308 C351 C352 C353 C354
C407 C408 C507 C508
            """),
    Stage("Back:Stencil:North","""
U34 U33 C61 C65 C15 R76 C17 C8
U32 U31 U30 C63 R5 C19 C49
R30 R31 R32 R33 R34 R35 R36 R37
            """),
    Stage("Back:Stencil:South","""
U29 U28 C66 C74 U27 R70 R71 R72 C79
U26 C18 U25 C5 C16 U24 U23 U22 C62 C71
C78 C73 U21 U20
C6 C7
            """),
    Stage("Front:Stencil:Power", """
D1 D2 R7 R28 L1 L2
C92 C82 C99 C89 C94 C84 R91 R81 U8 U9
C83 C93 R92 R82 C81 C91
C9 C10 U6 U7 R73 R74
            """),
    Stage("Front:Stencil:FTDI", """
U2 U3 R75 C53 D3 D4 D5 D6 U4 U5 R54
            """),
    Stage("Front:Stencil:FPGA", "U1"),
    Stage("Front:Stencil:East", """
R55 R56 R21 R22 R23 R24 D7 D8 D9 D10
R58 C13 R57
R123 R122 R121 R321 R322 R323
R223 R222 R221
           """),
    Stage("Front:Stencil:Analog", """
R111 C111 R211 C211 R311 C311
R301 R302 C301 R309 R303 R304 U63 R308 C309 C53
R201 R202 C201 R209 R203 R204 U62 R208 C209 C52
R101 R102 C101 R109 R103 R104 U61 R108 C109 C51
R408 U74 R508 U75 R502 R501 C501 C502 R402 R401 C401 C402
R601 R602 R603 U80
U51 U52 U53
           """),
    Stage("Manual:PinHeaders", "J2 J4 J7 J8 J5 J6 J9 J10 J11 J12"),
    Stage("Manual:Misc", "J1 J3 SW1 SW2"),
    Stage("Front:SNES", "U10 U11 U12 U13"),
]

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument(
            '--bom', type=str, default=None,
            help='BoM xml file.')
    args = parser.parse_args()

    db = txtdb.Txtdb()
    db.parse_file(os.path.join(ACCOUNTING_DIR, 'board.txtdb'))
    db.parse_file(os.path.join(ACCOUNTING_DIR, 'board-used.txtdb'))
    desc_by_digikey = {}
    for obj, digikey in db.objects_with_field('Digikey Product Id'):
        desc = obj.get('Digikey Description')
        assert desc not in desc_by_digikey or desc_by_digikey[digikey] == desc
        desc_by_digikey[digikey] = desc

    b = bom.parse_xml(args.bom)
    b.remove_boring_components()

    c_by_ref = {}
    for c in b.components:
        c_by_ref[c.ref] = c
    for stage in STAGES:
        stage.show(c_by_ref, desc_by_digikey)

    staged_components = []
    for stage in STAGES:
        for ref in stage.refs:
            staged_components.extend(stage.refs)

    unstaged_components = []
    for ref in c_by_ref.keys():
        if ref.startswith('BOM'):
            continue
        if ref in staged_components:
            continue
        unstaged_components.append(ref)

    if unstaged_components:
        print('----- Missing! -----')
        print(' '.join(sorted(unstaged_components)))

if __name__ == '__main__':
    main()
