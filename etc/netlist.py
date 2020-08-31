#!/usr/bin/env python3
# vi: ts=4:sw=4:sts=4:et


class ParseError(Exception): pass

def parse(s):
    top, rest = parse_expr(s)
    rest = skipwhite(rest)
    if rest != '':
        raise ParseError("Unexepected after top level: %r" % rest)
    return top

def skipwhite(s):
    i = 0
    while i < len(s) and s[i].isspace():
        i += 1
    return s[i:]

def parse_expr(s):
    s = skipwhite(s)
    if s[0] == '(':
        return parse_list(s[1:])
    if s[0] == '"':
        return parse_string(s[1:])
    if isatomchar(s):
        return parse_atom(s)
    raise ParseError("unhandled: %r..." % s[:20])

def parse_list(s):
    ret = []
    while len(s):
        if s[0] == ')':
            return ret, s[1:]
        expr, s = parse_expr(s)
        ret.append(expr)
    raise ParseError("unterminated list")

def isatomchar(c):
    return c[0] in 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/.-_~,&+*:?'

def parse_atom(s):
    i = 0
    while i < len(s) and isatomchar(s[i]):
        i += 1
    return s[:i], s[i:]

def parse_string(s):
    i = 0
    while i < len(s) and s[i] != '"':
        i += 1
    return s[:i], s[i+1:]
