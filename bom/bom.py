# vi: ts=4:sw=4:sts=4:et

import re
from xml.etree import ElementTree

DEFAULT_BOM_FILENAME = 'spla-board/spla-board.xml'

def defaultBomFilename():
    import sys, os.path
    return os.path.join(os.path.dirname(sys.argv[0]), '..', DEFAULT_BOM_FILENAME)

def refsplit(ref):
    a, i = re.match('([A-Z]+)([0-9]+)', ref).groups()
    return (a, int(i))

class Bom(object):
    def __init__(self, components, warnings):
        self.components = components
        self.warnings = warnings
        self.components.sort(key=lambda c:c.sortkey)
        self.warnings.sort(key=lambda c:c.sortkey)

    def remove_boring_components(self):
        self.components = [c for c in self.components if not c.is_boring()]

class BomWarning(object):
    def __init__(self, ref, text):
        self.ref = ref
        self.text = text
        self.sortkey = refsplit(ref)

class Component(object):
    def __init__(self, ref, value, footprint, digikey, manufacturer, manufacturer_id):
        self.ref = ref
        self.value = value
        self.footprint = footprint
        self.digikey = digikey
        self.manufacturer = manufacturer
        self.manufacturer_id = manufacturer_id
        self.sortkey = refsplit(ref)

    def is_boring(self):
        if self.value == 'NOSTUFF' or self.value == 'INF':
            return True
        if self.ref.startswith('H') or self.ref.startswith('TP'):
            return True
        return False

def parse_xml(args):
    if len(args) > 0:
        filename = args[0]
    else:
        filename = defaultBomFilename()
    assert filename.endswith('.xml')
    et = ElementTree.parse(filename)
    components = et.find('components')
    assert components is not None
    out = []
    warnings = []
    for component in components.findall('comp'):
        ref = component.attrib['ref']
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
            warnings.append(BomWarning(ref, "Component %s missing fields." % ref))
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
                    warnings.append(BomWarning(ref, "Component %s has unknown field %r" % (ref, field_name)))
        out.append(Component(ref, value, footprint, digikey, manufacturer, manufacturer_id))
    return Bom(out, warnings)
