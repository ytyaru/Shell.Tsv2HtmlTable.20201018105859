#!/usr/bin/env bash
set -Ceu
#---------------------------------------------------------------------------
# TSVをHTMLのtableタグに変換する。空白セルを結合する。
# CreatedAt: 2020-10-18
#---------------------------------------------------------------------------
Run() {
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

	# 以下の場合、大A,中Aはrowspanを持つ。だが、中Bは持たない。
	# 列位置単位で空白数分だけrowspanを増加する。ただし自分の左方向がすべて空白のときのみ。
	# もし右方向に空白があるならcolspanを増加する。
	# 大A	中A	小A
	# 		小B
	# 	中B	小C
	# 大B		
	# 大C		小D
	#	中C	
	OutputThColumns() {
		local RowLen="$(OutputThRowLength)"
		let RowLen++
#		echo "$RowLen"
#		echo -e "$TSV" | tail -n +$RowLen
		echo -e "$TSV" | tail -n +$RowLen | while read line; do { paste <(th) <(td) | Encloses 'tr'; } done;
#		echo -e "$TSV" | tail -n +2 | cut -f 1 | while read TH; do { Enclose 'th' "$TH"; echo ""; } done;
#		paste <(th) <(td) | Encloses 'tr'
	}
#	OutputThColumns() { echo -e "$TSV" | tail -n +2 | cut -f 1 | while read TH; do { Enclose 'th' "$TH"; echo ""; } done; }
	OutputTds() { echo -e "$TSV" | tail -n +2 | cut -f 2- | while read TR; do { OutputTd "$TR"; echo ""; } done; }
	OutputTd() { echo -e "$1" | tr '\t' '\n' | while read TD; do { Enclose 'td' "$TD"; } done; }
	
	OutputBodyThs() {
		
	}

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
#	OutputThColumnLength
#	OutputThColumns
	echo -e "$(OutputThColumnLength)"
	echo -e "$(OutputThColumns)"

#	local HTML="$(Enclose 'tr' "$(OutputThRow)")"
#	HTML+="$(echo -e "$(paste -d '' <(OutputThColumns) <(OutputTds))" | Encloses 'tr' )"
#	echo -e "$(Enclose 'table' "$HTML")"
}
Run "$@"
# echo -e ",,Alphabet,\n,,A,B\nNumber,1,X,Y\n,2,a,b" | $THIS
# echo -e "\t\tAlphabet\t\n\t\tA\tB\nNumber\t1\tX\tY\n\t2\ta\tb" | $THIS
