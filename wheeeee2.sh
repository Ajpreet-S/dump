#!/bin/sh

# Get screen x,y dimensions
xMax=$(tput cols)
yMax=$(tput lines)
xCenter=$((xMax / 2))
yCenter=$((yMax / 2))

# Functions
movePosition() { printf "\e[${1}H"; }
animateWrite() {
	string=$1
	rate=${2:-0.05}
	for ((i=0;i<${#string};i++)); do
		printf ${string:$i:1}
		sleep $rate
	done
}
showCursor() { printf '\e[?25h'; }
hideCursor() { printf '\e[?25l'; }
clearScreen() { printf '\e[2J'; }
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
# Wipe the terminal screen
stty -echo
printf '\e[?1049h'
hideCursor
clearScreen

# Print title
title=Wheeee2
movePosition "$((yCenter - 3));$((xCenter - (${#title} / 2) + 1))"
animateWrite "$title" 0.1
read -rsn1 -t1

text="Select your character (WASD controls)"
movePosition "$((yCenter - 1));$((xCenter - (${#text} / 2) + 1))"
printf "$text"

players='\u2654 \u2655 \u2656 \u263A \u25C9 \u25C8 \u25C7 \u25A3'
totalPlayers=$(echo $players | wc -w)
playerPointer=0
player=$(echo $players | cut -d' ' -f$((playerPointer + 1)))
text="\u2190 $player \u2192"
movePosition "$((yCenter + 1));$((xCenter - 1))"
printf "$text\e[3D"
while true; do
	read -rsn1 -t1 key
	case "$key" in
		a)
			playerPointer=$((playerPointer - 1))
			;;
		d)
			playerPointer=$((playerPointer + 1))
			;;
		w)
			direction=up
			break
			;;
		s)
			direction=down
			break
			;;
		q) printf '\e[?1049l'; exit 0;;
	esac

	player=$(echo $players | cut -d' ' -f$((((playerPointer > 0 ? playerPointer : -playerPointer) % totalPlayers) + 1)))
	printf "$player\e[1D"
done

clearScreen	
movePosition "$((yCenter + 1));$((xCenter + 1))"
printf "$player\e[1D"

while true; do
	read -t0.4 -rsn1 key

	# core gameplay loop controls
	case "$key" in
		w) direction=up;;
		s) direction=down;;
		a) direction=left;;
		d) direction=right;;
		q) printf '\e[?1049l'; exit 0;;
	esac

	case "$direction" in
		up)
			printf "\u2191\e[1D"
			go up
			printf "$player\e[1D"
			;;
		down)
			printf "\u2193\e[1D"
			go down
			printf "$player\e[1D"
			;;
		left)
			printf "\u2190\e[1D"
			go left
			printf "$player\e[1D"
			;;
		right)
			printf "\u2192\e[1D"
			go right
			printf "$player\e[1D"
			;;
	esac
done

sleep 2


# Exit
printf '\e[?1049l'
showCursor
stty echo
exit 0
