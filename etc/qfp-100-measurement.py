#!/usr/bin/env python3
# vi: ts=4:sw=4:sts=4:et

pin_pitch = 635 # um
plastic_width = 13500 # um
plastic_height = 19500 # um
land_outer_width = 19500 # um
land_outer_height = 25500 # um
land_orig_length = 2000 # um
land_new_length = 3000 # um, including space for hand-soldering
land_width = 400 # um -- guessing

def show(name, value):
  print('%s = %f mm' % (name, float(value) / 1000))

plastic_land_gap_width = (land_outer_width - plastic_width) / 2 - land_orig_length
plastic_land_gap_height = (land_outer_height - plastic_height) / 2 - land_orig_length

assert plastic_land_gap_width == plastic_land_gap_height
show("plastic_land_gap_width", plastic_land_gap_width)
show("plastic_land_gap_height", plastic_land_gap_height)
plastic_land_gap = plastic_land_gap_height

print("--- right")
land_right_inner = (plastic_width / 2) + plastic_land_gap
land_right_outer = land_right_inner + land_new_length
show("land_right_inner", land_right_inner)
show("land_right_outer", land_right_outer)
land_right_center = (land_right_inner + land_right_outer) / 2
show("land_right_center", land_right_center)
show("land width", land_new_length)
show("land height", land_width)

print("--- top")
land_top_inner = (plastic_height / 2) + plastic_land_gap
land_top_outer = land_top_inner + land_new_length
show("land_top_inner", land_top_inner)
show("land_top_outer", land_top_outer)
land_top_center = (land_top_inner + land_top_outer) / 2
show("land_top_center", land_top_center)
show("land width", land_width)
show("land height", land_new_length)
