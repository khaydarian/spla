#!/usr/bin/env python
# vi: ts=4:sw=4:sts=4:et

import sys
import re
from xml.etree import ElementTree

DEFAULT_BOM_FILE = 'spla-board/spla-board.xml'

def refsplit(ref):
    a, i = re.match('([A-Z]+)([0-9]+)', ref).groups()
    return (a, int(i))

class Component(object):
    def __init__(self, ref, value, footprint, digikey, manufacturer, manufacturer_id):
        self.sortkey = refsplit(ref)
        self.ref = ref
        self.value = value
        self.footprint = footprint
        self.digikey = digikey
        self.manufacturer = manufacturer
        self.manufacturer_id = manufacturer_id

def parse_xml(filename):
    et = ElementTree.parse(filename)
    components = et.find('components')
    assert components is not None
    out = []
    for component in components.findall('comp'):
        ref = component.attrib['ref']
        if ref.startswith('H') or ref.startswith('TP'):
            continue
        kind = None
        value = None
        footprint = None
        digikey = None
        manufacturer = None
        manufacturer_id = None

        footprint = component.find('footprint').text
        value = component.find('value').text
        fields = component.find('fields')
        if fields is None:
            print "Error: Component %s missing fields." % ref
        else:
            for field in fields.findall('field'):
                field_name = field.attrib['name']
                if field_name == 'Digikey':
                    digikey = field.text
                elif field_name == 'Manufacturer':
                    manufacturer = field.text
                elif field_name == 'Manufacturer Id':
                    manufacturer_id = field.text
                else:
                    print "Error: Component %s has unknown field %r" % (ref, field_name)
        out.append(Component(ref, value, footprint, digikey,
                    manufacturer, manufacturer_id))
    return out



def main(args):
    if len(args) >= 1:
        xml_filename = args[0]
    else:
        xml_filename = DEFAULT_BOM_FILE
    assert xml_filename.endswith('.xml')
    components = parse_xml(xml_filename)
    for c in sorted(components, key=lambda c:c.sortkey):
        if c.digikey is None:
            print '%-8s %-10s %s' % (c.ref, c.value, c.footprint)

if __name__ == '__main__':
    main(sys.argv[1:])
