#!/bin/sh

for i in {0..254}; do
	# 1B is hex for an ESC character in ASCII's character encoding
	printf %b "\x1B[${i}m \\\x1B[${i}m - lorep ipsum dolor\x1B[0m\n"
	[ $# == 0 ] && sleep 0.02
done
