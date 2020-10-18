#!/usr/bin/env bash
set -Ceu
#---------------------------------------------------------------------------
# TSVをHTMLのtableタグに変換する。1行目をヘッダとする。
# CreatedAt: 2020-10-18
#---------------------------------------------------------------------------
Run() {
	THIS="$(realpath "${BASH_SOURCE:-0}")"; HERE="$(dirname "$THIS")"; PARENT="$(dirname "$HERE")"; THIS_NAME="$(basename "$THIS")"; APP_ROOT="$PARENT";
#	cd "$HERE"
	Enclose() { echo -n '<'"$1"'>'"$2"'</'"$1"'>'; }
	local HTML=
	local TSV="$(cat -)"
	OutputTh() {
		local HEADER="$(echo -e "$TSV" | head -n 1)"
		echo -e "$HEADER" | tr '\t' '\n' | while read TH; do {
			Enclose 'th' "$TH"
		} done;
	}
	OutputTds() {
		local DATA="$(echo -e "$TSV" | tail -n +2)"
		echo -e "$DATA" | while read TR; do {
			Enclose 'tr' "$(OutputTd "$TR")"
		} done;
	}
	OutputTd() {
		echo -e "$1" | tr '\t' '\n' | while read TD; do {
			Enclose 'td' "$TD"
		} done;
	}
	HTML+="$(Enclose 'tr' "$(OutputTh)")"
	HTML+="$(OutputTds)"
	echo -e "$(Enclose 'table' "$HTML")"
}
Run "$@"
