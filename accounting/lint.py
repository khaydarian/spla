#!/usr/bin/env python
# vi: ts=4:sw=4:sts=4:et

import txtdb, schema

def lint_files(files):
    if not files:
        files = default_files()
    db = txtdb.Txtdb()
    for f in files:
        db.parse_file(f)
    errors = []
    validate_fields(db, errors)
    validate_packages(db, errors)
    validate_cost_package(db, errors)
    validate_cost_total(db, errors)
    errors.sort()
    for (filename, lineno), err in errors:
        print '%s:%d: %s' % (filename, lineno, err)
    return len(errors)

def default_files():
    import sys, os.path, glob
    return glob.glob(os.path.join(os.path.dirname(sys.argv[0]), "*.txtdb"))

def validate_fields(db, errors):
    for obj in db.objects:
        for key, value in obj.fields.items():
            tp = schema.FIELD_TYPES.get(key)
            if tp is None:
                errors.append((obj.field_loc[key], "Unknown schema for field '%s'" % key))
                continue
            schema.validate_type(tp, key, value, obj.field_loc[key], errors)

def validate_packages(db, errors):
    packages = {}
    package_count = {}
    for obj, package_key in db.objects_with_field('Package Key'):
        if package_key in packages:
            errors.append((obj.field_loc[key], "Duplicate package key: %r" % package_key))
        packages[package_key] = obj
        package_count[package_key] = 0
    for obj, from_key in db.objects_with_field('From Package Key'):
        if from_key not in packages:
            errors.append((obj.field_loc[key], "Nonexistant package key: %r" % package_key))
        package_count[from_key] += 1
    for key, obj in packages.items():
        if package_count[key] == 0:
            errors.append((obj.loc, "Empty package: %r" % kage_key))

def validate_cost_package(db, errors):
    # TODO validate "Package Cost Total" as sum of contained items
    pass

def validate_cost_total(db, errors):
    # TODO validate "Cost Total" as sum of costs
    pass

if __name__ == '__main__':
    import sys
    sys.exit(lint_files(sys.argv[1:]))
