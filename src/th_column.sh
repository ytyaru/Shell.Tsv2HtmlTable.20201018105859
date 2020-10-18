#!/usr/bin/env bash
set -Ceu
#---------------------------------------------------------------------------
# TSVをHTMLのtableタグに変換する。1列目をヘッダとする。
# CreatedAt: 2020-10-18
#---------------------------------------------------------------------------
Run() {
	THIS="$(realpath "${BASH_SOURCE:-0}")"; HERE="$(dirname "$THIS")"; PARENT="$(dirname "$HERE")"; THIS_NAME="$(basename "$THIS")"; APP_ROOT="$PARENT";
	. $HERE/lib/enclose.sh
	local TSV="$(cat -)"
	OutputTh() { echo -e "$TSV" | cut -f1 | while read TH; do { Enclose 'th' "$TH"; echo ""; } done; }
	OutputTds() { echo -e "$TSV" | cut -f 2- | while read TR; do { OutputTd "$TR"; echo ""; } done; }
	OutputTd() { echo -e "$1" | tr '\t' '\n' | while read TD; do { Enclose 'td' "$TD"; } done; }
	local HTML="$(paste -d '' <(OutputTh) <(OutputTds))"
	HTML="$(echo -e "$HTML" | Encloses 'tr')"
	echo -e "$(Enclose 'table' "$HTML")"
}
Run "$@"
# echo -e "Id\t0\t1\nName\tA\tB" | 
