#!/usr/bin/env python3
# vi: ts=4:sw=4:sts=4:et

import math
import resistor

scale = 1e3

vref = 3.3

best = None
best_err = 1e9

r1 = 1.65e3
for r2 in resistor.e96(scale/1e3) + resistor.e96(scale) + resistor.e96(scale*1e3):
	for r3 in resistor.e96(scale/1e3) + resistor.e96(scale) + resistor.e96(scale*1e3):
		top = vref * (r2 + r3) / (r1 + r2 + r3)
		bot = vref * (r3) / (r1 + r2 + r3)
		if top < bot: continue
		center = (top + bot) / 2
		vrange = (top - bot)
		centererr = (center - 1.475) ** 2
		rangeerr = (2 - vrange) ** 2
		err = math.sqrt(centererr * centererr)
		if err < best_err:
			best_err = err
			best = (r1, r2, r3, center, vrange, bot, top)


(r1, r2, r3, center, vrange, bot, top) = best
print("R1 = %6.3f ohm" % r1)
print("R2 = %6.3f ohm" % r2)
print("R3 = %6.3f ohm" % r3)
print("Vref_hi = %6.3f v" % top)
print("Vref_lo = %6.3f v" % bot)
print(" center = %6.3f v" % center)
print("  range = %6.3f v" % vrange)
