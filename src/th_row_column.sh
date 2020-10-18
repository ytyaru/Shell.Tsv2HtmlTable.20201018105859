#!/usr/bin/env bash
set -Ceu
#---------------------------------------------------------------------------
# TSVをHTMLのtableタグに変換する。1行目と1列目をヘッダとする。
# CreatedAt: 2020-10-18
#---------------------------------------------------------------------------
Run() {
	THIS="$(realpath "${BASH_SOURCE:-0}")"; HERE="$(dirname "$THIS")"; PARENT="$(dirname "$HERE")"; THIS_NAME="$(basename "$THIS")"; APP_ROOT="$PARENT";
	. $HERE/lib/enclose.sh
	local TSV="$(cat -)"
	OutputThRow() { echo -e "$TSV" | head -n 1 | tr '\t' '\n' | while read TH; do { Enclose 'th' "$TH"; } done; }
	OutputThColumns() { echo -e "$TSV" | tail -n +2 | cut -f 1 | while read TH; do { Enclose 'th' "$TH"; echo ""; } done; }
	OutputTds() { echo -e "$TSV" | tail -n +2 | cut -f 2- | while read TR; do { OutputTd "$TR"; echo ""; } done; }
	OutputTd() { echo -e "$1" | tr '\t' '\n' | while read TD; do { Enclose 'td' "$TD"; } done; }
	local HTML="$(Enclose 'tr' "$(OutputThRow)")"
	HTML+="$(echo -e "$(paste -d '' <(OutputThColumns) <(OutputTds))" | Encloses 'tr' )"
	echo -e "$(Enclose 'table' "$HTML")"
}
Run "$@"
# echo -e "\tA\tB\n1\tX\tY\n2\ta\tb" | $THIS
