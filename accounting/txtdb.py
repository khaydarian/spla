# vi: ts=4:sw=4:sts=4:et

class TxtdbObject(object):
    def __init__(self):
        self.fields = {}
        self.field_loc = {}
        self.loc = None

    def get(self, key):
        return self.fields[key]

    def set(self, key, value, filename, lineno):
        if key in self.fields:
            raise ValueError("%s:%d: Duplicate key '%s'" % (filename, lineno, key))
        self.fields[key] = value
        self.field_loc[key] = (filename, lineno)
        if self.loc is None:
            self.loc = (filename, lineno)

class Txtdb(object):
    def __init__(self):
        self.objects = []

    def parse_file(self, filename, f=None):
        if f is None:
            f = open(filename)
        last_obj = None
        for lineno, line in enumerate(f):
            line = line.strip()
            if line == '':
                last_obj = None
                continue
            if last_obj is None:
                last_obj = self.add_object()
            key, value = parse_line(line, filename, lineno)
            last_obj.set(key, value, filename, lineno)

    def add_object(self):
        obj = TxtdbObject()
        self.objects.append(obj)
        return obj

    def objects_with_field(self, key):
        return [(obj, obj.fields[key]) for obj in self.objects if key in obj.fields]

def parse_line(line, filename, lineno):
    if ':' not in line:
        raise ValueError("%s:%d: missing ':'" % (filename, lineno))
    key, value = line.split(':', 1)
    key = key.strip()
    if key == '':
        raise ValueError("%s:%d: empty key" % (filename, lineno))
    value = value.strip()
    if value == '':
        raise ValueError("%s:%d: empty value" % (filename, lineno))
    return key, value
