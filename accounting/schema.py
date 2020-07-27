#!/usr/bin/env python
# vi: ts=4:sw=4:sts=4:et

import re

FIELD_TYPES = {
    'Name': 'any',

    'Category': 'enum',
    'Source': 'any',
    'Location': 'any',
    'Note': 'any',

    'From Package Key': 'any',
    'Package Key': 'any',
    'Package Cost Base': 'money',
    'Package Cost Tax': 'money',
    'Package Cost Total': 'money',
    'Package Cost Subtotal': 'money',
    'Package Cost Shipping': 'money',
    'Package Cost Tariff': 'money',
    'Package Cost Sales Tax': 'money',

    'Quantity': 'int',
    'Remaining': 'int|lots',

    'Unit Cost': 'money',
    'Cost': 'money',
    'Cost Base': 'money',
    'Cost Shipping': 'money',
    'Cost Discount Coupon': 'money',
    'Cost Foreign Transaction Fee': 'money',
    'Cost JLCPCB Total': 'money',
    'Cost Total': 'money',
    'Cost Tax': 'money',

    'Date Arrive Estimated': 'date',
    'Date Arrive Actual': 'date',
    'Date Purchase': 'date',
    'Order Submitted Date': 'date',
    'Order Arrived Date': 'date',

    'Condition': 'any',
    'Model Number': 'any',
    'Part Number': 'any',
    'Manufacturer': 'any',
    'Manufacturer Product Id': 'any',
    'Shipping Method': 'any',

    'SNES Serial': 'any',
    'SNES Chips': 'any',

    'Digikey Description': 'any',
    'Digikey Product Id': 'any',
    'Digikey Salesorder Number': 'any',
    'Digikey Web ID': 'any',
    'Ebay Condition': 'any',
    'Ebay ID': 'any',
    'JLCPCB HS Code': 'any',
    'JLCPCB Product File': 'any',

    'Solder Composition': 'any',
    'Solder Width': 'any',
    'Solder Size': 'any',
    'Solder Wick Width': 'any',
    'Solder Wick Length': 'any',
    'Flux Quantity': 'any',

    'Board Serial': 'any',
    'Board Completion': 'any',
}

CATEGORIES = {
    'Board Parts',
    'Supplies',
    'Lab Equipment',
    'Lab Supplies',
    'Toys',
    'SNES Related',
}

def validate_type(tp, key, value, loc, errors):
    if tp == 'any':
        return
    if tp == 'date':
        m = re.match(r'20\d{2}-\d{2}-\d{2}', value)
        if m is None:
            errors.append((loc, 'Invalid date: %s' % value))
        return
    if tp == 'money':
        m = re.match(r'-?\$[0-9]+(.[0-9]+)?', value)
        if m is None:
            errors.append((loc, 'Invalid money: %s' % value))
        return
    if tp == 'int':
        m = re.match(r'[0-9]+', value)
        if m is None:
            errors.append((loc, 'Invalid int: %s' % value))
        return
    if tp == 'int|lots':
        m = re.match(r'(lots|[0-9]+)', value)
        if m is None:
            errors.append((loc, 'Invalid int: %s' % value))
        return
    if tp == 'enum':
        if key == 'Category':
            if value not in CATEGORIES:
                errors.append((loc, 'Invalidate category: %s' % value))
        else:
            errors.append((loc, 'Unhandled schema type enum for %r' % key))
        return
    errors.append((loc, 'Unhandled schema type %s (for key %r)' % (tp, key)))

