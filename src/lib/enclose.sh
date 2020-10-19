#!/usr/bin/env bash
set -Ceu
#---------------------------------------------------------------------------
# HTMLタグで囲む。
# CreatedAt: 2020-10-18
#---------------------------------------------------------------------------
#Enclose() { echo -n '<'"$1"'>'"$2"'</'"$1"'>'; }
Enclose() { #$1=element, $2=text-content, $3=attribute
	local attr="${@:3:($#-2)}"
	[ ! "" = "$attr" ] && attr=' '"$attr"
	echo -n '<'"${1}${attr}"'>'"$2"'</'"$1"'>';
}
Encloses() { # stdin: TSV(1:text-content, 2:attribute), $1=element
	cat - | while read line; do {
#		Enclose "$1" "$line"
#		[ $(echo -e "$line" | grep $'\t') ] && {
		[ "$(echo -e "$line" | grep $'\t')" ] && {
			Enclose "$1" "$(echo -e "$line" | cut -f1)" "$(echo -e "$line" | cut -f2)"
		} || {
			Enclose "$1" "$line"
		}
	} done;
}
