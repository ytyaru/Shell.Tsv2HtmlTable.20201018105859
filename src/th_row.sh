#!/usr/bin/env bash
set -Ceu
#---------------------------------------------------------------------------
# TSVをHTMLのtableタグに変換する。1行目をヘッダとする。
# CreatedAt: 2020-10-18
#---------------------------------------------------------------------------
Run() {
	THIS="$(realpath "${BASH_SOURCE:-0}")"; HERE="$(dirname "$THIS")"; PARENT="$(dirname "$HERE")"; THIS_NAME="$(basename "$THIS")"; APP_ROOT="$PARENT";
	. $HERE/lib/enclose.sh
	local TSV="$(cat -)"
	OutputTh() { echo -e "$TSV" | head -n 1 | tr '\t' '\n' | while read TH; do { Enclose 'th' "$TH"; } done; }
	OutputTds() { echo -e "$TSV" | tail -n +2 | while read TR; do { Enclose 'tr' "$(OutputTd "$TR")"; } done; }
	OutputTd() { echo -e "$1" | tr '\t' '\n' | Encloses 'td'; }
	local HTML="$(Enclose 'tr' "$(OutputTh)")"
	HTML+="$(OutputTds)"
	echo -e "$(Enclose 'table' "$HTML")"
}
Run "$@"
# echo -e "Id\tName\n0\tA\n1\tB" | 
