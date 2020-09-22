#!/bin/bash

while :; do
	rm -f splat
	clear
	make
	inotifywait *.c *.h
done
