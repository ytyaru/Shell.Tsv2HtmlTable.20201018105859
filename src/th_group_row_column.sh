#!/usr/bin/env bash
set -Ceu
#---------------------------------------------------------------------------
# TSVをHTMLのtableタグに変換する。1行目と1列目をヘッダとする。空白セルは結合する。
# CreatedAt: 2020-10-18
#---------------------------------------------------------------------------
Run() {
	THIS="$(realpath "${BASH_SOURCE:-0}")"; HERE="$(dirname "$THIS")"; PARENT="$(dirname "$HERE")"; THIS_NAME="$(basename "$THIS")"; APP_ROOT="$PARENT";
	. $HERE/lib/enclose.sh
	local TSV="$(cat -)"
	# colspan: 何列目が何個か
	# rowspan: 何行目が何個か

	# 何列目までが列ヘッダか
	#   1列目の値の長さが0の列数が、列ヘッダ数である。
	# 何行目までが行ヘッダか
	#   どうやって判断する？
	#   1列目の値の長さが0より大きい場合、その行より上までが行ヘッダと判断できる。
	OutputThRowLength() {
		local line_length=0
		echo -e "$TSV" | while read line; do {
			let line_length++
			local first_char_len=$(echo -e "$line" | cut -f1 | wc -l)
			[ 0 -lt $first_char_len ] && { echo "$line_length"; return; }
		} done;
		echo '0'
	}
	OutputThRows() {
		echo -e "$TSV" | head -n "$(OutputThRowLength)" | while read line; do { Enclose 'tr' "$(OutputThRow "$line")"; } done;
	}
	OutputThRow() { echo -e "$1" | tr '\t' '\n' | while read TH; do { Enclose 'th' "$TH"; } done; }
	# rowspan:
	#   0,0,8,0: 1行目の文字列長を区切文字ごとに取得する
	#   先頭からみて最初に0以外の値が来たら開始する
	#   次の列が0ならcolspanを+1する. colspan=1が初期値。もし2以上ならcolspan属性を付与する。
	#   [index]=colspan_value, ] 今回なら [[3]=2]. 1行目の3列目にあるthはcolspan=2である。
	Colspan() {
		local LENGTH="$(echo -e "$1" | tr '\t' '\n' | xargs -I@ bash -c 'wc -l "@"')"
		# 4行出力。3行目のみcolspan="2"。これをthのtext-contentリストとpasteして、thタグを作る
		#
		#
		#colspan="2"
		#
		# ----------
		# \t
		# \t
		# Alphabet\tcolspan="2"
		# \t
	}
	Colspans() {
		local LENGTH="$(echo -e "$TSV" | head -n 1 | tr '\t' '\n' | xargs -I@ bash -c 'wc -l "@"')"
	}
#	OutputThRow() { echo -e "$TSV" | head -n 1 | tr '\t' '\n' | while read TH; do { Enclose 'th' "$TH"; } done; }
	OutputThColumns() { echo -e "$TSV" | tail -n +2 | cut -f 1 | while read TH; do { Enclose 'th' "$TH"; echo ""; } done; }
	OutputTds() { echo -e "$TSV" | tail -n +2 | cut -f 2- | while read TR; do { OutputTd "$TR"; echo ""; } done; }
	OutputTd() { echo -e "$1" | tr '\t' '\n' | while read TD; do { Enclose 'td' "$TD"; } done; }
#	local HTML="$(Enclose 'tr' "$(OutputThRow)")"
#	HTML+="$(echo -e "$(paste -d '' <(OutputThColumns) <(OutputTds))" | Encloses 'tr' )"
#	echo -e "$(Enclose 'table' "$HTML")"
}
Run "$@"
# echo -e ",,Alphabet,\n,,A,B\nNumber,1,X,Y\n,2,a,b" | $THIS
# echo -e "\t\tAlphabet\t\n\t\tA\tB\nNumber\t1\tX\tY\n\t2\ta\tb" | $THIS
