#!/usr/bin/env bash
set -Ceu
#---------------------------------------------------------------------------
# TSVをHTMLのtableタグに変換する。1行目と1列目をヘッダとする。
# CreatedAt: 2020-10-18
#---------------------------------------------------------------------------
Run() {
	THIS="$(realpath "${BASH_SOURCE:-0}")"; HERE="$(dirname "$THIS")"; PARENT="$(dirname "$HERE")"; THIS_NAME="$(basename "$THIS")"; APP_ROOT="$PARENT";
#	cd "$HERE"
	Enclose() { echo -n '<'"$1"'>'"$2"'</'"$1"'>'; }
	local HTML=
	local TSV="$(cat -)"
	OutputThRow() {
		local HEADER="$(echo -e "$TSV" | head -n 1)"
		echo -e "$HEADER" | tr '\t' '\n' | while read TH; do {
			Enclose 'th' "$TH"
		} done;
	}
	OutputThColumns() {
		local HEADER="$(echo -e "$TSV" | tail -n +2 | cut -f 1)"
		echo -e "$HEADER" | while read TH; do {
			Enclose 'th' "$TH"
			echo ""
		} done;
	}
	OutputTds() {
		local DATA="$(echo -e "$TSV" | tail -n +2 | cut -f 2-)"
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
	HTML+="$(Enclose 'tr' "$(OutputThRow)")"
	HTML+="$(OutputTr "$(paste -d '' <(OutputThColumns) <(OutputTds))")"
#	HTML+="$(paste -d '' <(OutputThColumns) <(OutputTds))"
#	HTML="$(OutputTr "$HTML")"
#	HTML+="$(Enclose 'tr' "$(OutputTh)")"
#	HTML+="$(OutputTds)"
	echo -e "$(Enclose 'table' "$HTML")"
}
Run "$@"
# echo -e "\tA\tB\n1\tX\tY\n2\ta\tb" | 
