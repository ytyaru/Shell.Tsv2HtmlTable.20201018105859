#!/usr/bin/env bash
set -Ceu
#---------------------------------------------------------------------------
# TSVをHTMLのtableタグに変換する。1列目をヘッダとする。
# CreatedAt: 2020-10-18
#---------------------------------------------------------------------------
Run() {
	THIS="$(realpath "${BASH_SOURCE:-0}")"; HERE="$(dirname "$THIS")"; PARENT="$(dirname "$HERE")"; THIS_NAME="$(basename "$THIS")"; APP_ROOT="$PARENT";
#	cd "$HERE"
	Enclose() { echo -n '<'"$1"'>'"$2"'</'"$1"'>'; }
	local HTML=
	local TSV="$(cat -)"
	OutputTh() {
		local HEADER="$(echo -e "$TSV" | cut -f1)"
		echo -e "$HEADER" | while read TH; do {
			Enclose 'th' "$TH"
			echo ""
		} done;
	}
	OutputTds() {
		local DATA="$(echo -e "$TSV" | cut -f 2-)"
		echo -e "$DATA" | while read TR; do {
			OutputTd "$TR"
			echo ""
		} done;
	}
	OutputTd() {
		echo -e "$1" | tr '\t' '\n' | while read TD; do {
			Enclose 'td' "$TD"
		} done;
	}
	OutputTr() {
		echo -e "$1" | while read line; do {
			Enclose 'tr' "$line"
		} done;
	}
	HTML="$(paste -d '' <(OutputTh) <(OutputTds))"
	HTML="$(OutputTr "$HTML")"
	echo -e "$(Enclose 'table' "$HTML")"
}
Run "$@"
# echo -e "Id\t0\t1\nName\tA\tB" | 
