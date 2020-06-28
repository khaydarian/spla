#!/usr/bin/env python
# vi: ts=4:sw=4:sts=4:et

import sys, bom
sys.path.append('./accounting')
import txtdb

GREEN = '[92m'
RESET = '[m'

class Stage(object):
    def __init__(self, name, refs):
        self.name = name
        self.refs = refs.split()

    def show(self, c_by_ref, desc_by_digikey):
        print "----- %s -----" % self.name
        components_by_digikey = {}
        for r in self.refs:
            c = c_by_ref[r]
            if c.digikey not in components_by_digikey:
                components_by_digikey[c.digikey] = []
            components_by_digikey[c.digikey].append(c)

        digikeys = components_by_digikey.keys()
        digikeys.sort(key=lambda d: refsortkey(components_by_digikey[d][0].ref))
        for digikey in digikeys:
            components = components_by_digikey[digikey]
            print '[%-20s] %s%s%s (%r)' % (
                digikey, GREEN, desc_by_digikey[digikey], RESET, components[0].value)
            print ' ', ' '.join([c.ref for c in components])

def refsortkey(ref):
    if ref.startswith('R'):
        return (1, ref)
    if ref.startswith('C'):
        return (2, ref)
    return (0, ref)

STAGES = [
    Stage("FPGA-Only", "U1"),
    Stage("Power", """
        J7 D1 D2 L1 L2 R96 C92 C99 C94 R91 U8 C91 R98 C93 R97 R92 R86 C82 C89
        C84 R81 U7 C81 R88 C83 R87 R82 C42 U14 R34 C41 U9 R33"""),
    Stage("FTDI-Front", "U2 U3 C7 D3 D4 D5 D6 R12 R16 R8 R10 R9 R28"),
    Stage("FPGA-Front", "D7 D8 R26 R27"),
    # Skip R1 C1
    Stage("FTDI-Back", "R13 R14 R2 R3 C16 R4 R5 R6 R7 C38 C4 C6 C3 C5 R31 X1 C2 C18 C43"),
    Stage("FGPA-Back", "C31 C25 C13 R15 C30 C32 C37 C19 C24 C21 C35 C20 C15 C27 C33 C34 C23 C17"),
    Stage("PinHeaders", "J12 J4 J2"),
    #Stage("LevelShifters", ...),
    #Stage("SNES", ...),
    #Stage("Analog", ...),
]

def main(args):

    db = txtdb.Txtdb()
    db.parse_file('./accounting/board.txtdb')
    desc_by_digikey = {}
    for obj, digikey in db.objects_with_field('Digikey Product Id'):
        desc = obj.get('Digikey Description')
        assert desc not in desc_by_digikey or desc_by_digikey[digikey] == desc
        desc_by_digikey[digikey] = desc

    b = bom.parse_xml(args)
    b.remove_boring_components()

    c_by_ref = {}
    for c in b.components:
        c_by_ref[c.ref] = c
    for stage in STAGES:
        stage.show(c_by_ref, desc_by_digikey)

if __name__ == '__main__':
    main(sys.argv[1:])
