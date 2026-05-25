#!/bin/sh

PLAYER='\u2B25'

go() {
	local direction
	case "$1" in
		up)
			direction=A
			;;
		down)
			direction=B
			;;
		right)
			direction=C
			;;
		left)
			direction=D
			;;
	esac

	steps=${2:-1}
	printf "\e[${steps}${direction}"
}

while true; do
	printf "$PLAYER"
	go left
	read -p '' -rsn1 key
	case "$key" in 
		h)
			printf '\u2190'
			go left 2
			;;
		j)
			printf '\u2193'
			go left
			go down
			;;
		k)
			printf '\u2191'
			go left
			go up
			;;
		l)
			printf '\u2192'
			;;
	esac
done
