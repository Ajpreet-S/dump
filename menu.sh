#!/bin/sh

script=$(curl -fsSL 'https://api.github.com/repos/Ajpreet-S/dump/contents/' | grep '"name": "[^"]*\.sh"' | cut -d'"' -f4 | fzf)
curl -fsSL "https://raw.githubusercontent.com/Ajpreet-S/dump/main/$script" | sh
