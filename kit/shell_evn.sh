#!/usr/bin/env zsh

# Add new path to environment path
ys-add-evn-path()
{
	PATH="$1:${PATH}"
	export PATH
}

ys-add-evn-path "$(pwd)/node_modules/.bin"