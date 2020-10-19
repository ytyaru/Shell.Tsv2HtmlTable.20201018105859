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
		echo -e "$TSV" | while IFS= read line; do {
			local first_char_len=$(echo -e "$line" | cut -f1 | wc -m)
			[ 1 -lt $first_char_len ] && { echo "$line_length"; return; }
			let line_length++
		} done;
	}
	OutputThRows() {
		echo -e "$TSV" | head -n "$(OutputThRowLength)" | while IFS= read line; do { Enclose 'tr' "$(echo -e "$(OutputThRow "$line")" | Encloses 'th')"; } done;
	}
	OutputThRow() { paste <(echo -e "$1" | tr '\t' '\n') <(echo -e "$1" | echo -e "$(ColspanLength)" | echo -e "$(ColspanAttr)"); }
	# rowspan:
	#   0,0,8,0: 1行目の文字列長を区切文字ごとに取得する
	#   先頭からみて最初に0以外の値が来たら開始する
	#   次の列が0ならcolspanを+1する. colspan=1が初期値。もし2以上ならcolspan属性を付与する。
	#   [index]=colspan_value, ] 今回なら [[3]=2]. 1行目の3列目にあるthはcolspan=2である。
	TextContentLength() { echo -e "$(cat -)" | tr '\t' '\n' | while read line; do { v=$(echo -e "$line" | wc -m); let v--; echo $v; } done; }
	ColspanLength() {
		INPUT="$(echo -e "$(cat -)")"
		TextLens=($(echo -e "$INPUT" | TextContentLength))
		Colspans=($(echo -e "$INPUT" | TextContentLength))
		for ((i=0; i<${#TextLens[*]}; i++)); do
			[ "0" = "${TextLens[$i]}" ] && continue
			local span=1
			for ((c=$((i + 1)); c<${#TextLens[*]}; c++)); do
				[ ! "0" = "${TextLens[$c]}" ] && break
				let span++
			done
			[ 1 -lt $span ] && Colspans[$i]=$span
		done
		echo -e "$(IFS=$'\n'; echo -e "${Colspans[*]}")"
	}
	ColspanAttr() {
		echo -e "$(cat -)" | while read line; do
			[ 1 -lt $line ] && echo 'colspan="'"$line"'"' || echo ''
		done
	}

	OutputThColumns() { echo -e "$TSV" | tail -n +2 | cut -f 1 | while read TH; do { Enclose 'th' "$TH"; echo ""; } done; }
	OutputTds() { echo -e "$TSV" | tail -n +2 | cut -f 2- | while read TR; do { OutputTd "$TR"; echo ""; } done; }
	OutputTd() { echo -e "$1" | tr '\t' '\n' | while read TD; do { Enclose 'td' "$TD"; } done; }
	
	echo "--------"
	echo "$(OutputThRowLength)"
	echo "--------"
	echo -e "\t\tAlphabet\t" | TextContentLength
	echo "--------"
	echo -e "\t\tAlphabet\t" | ColspanLength
	echo "--------"
	echo -e "\t\tAlphabet\t" | ColspanLength | ColspanAttr
	echo "--------"
	paste <(echo -e "\t\tAlphabet\t" | tr '\t' '\n') <(echo -e "\t\tAlphabet\t" | ColspanLength | ColspanAttr)
	echo "--------"
	echo $(OutputThRowLength)
	echo -e "$(OutputThRows)"
#	local HTML="$(Enclose 'tr' "$(OutputThRow)")"
#	HTML+="$(echo -e "$(paste -d '' <(OutputThColumns) <(OutputTds))" | Encloses 'tr' )"
#	echo -e "$(Enclose 'table' "$HTML")"
}
Run "$@"
# echo -e ",,Alphabet,\n,,A,B\nNumber,1,X,Y\n,2,a,b" | $THIS
# echo -e "\t\tAlphabet\t\n\t\tA\tB\nNumber\t1\tX\tY\n\t2\ta\tb" | $THIS
