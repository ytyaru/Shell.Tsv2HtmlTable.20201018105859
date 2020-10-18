#!/usr/bin/env bash
set -Ceu
#---------------------------------------------------------------------------
# TSVをHTMLのtableタグに変換する。テスト実行。
# CreatedAt: 2020-10-18
#---------------------------------------------------------------------------
Run() {
	THIS="$(realpath "${BASH_SOURCE:-0}")"; HERE="$(dirname "$THIS")"; PARENT="$(dirname "$HERE")"; THIS_NAME="$(basename "$THIS")"; APP_ROOT="$PARENT";
	echo -e "Id\tName\n0\tA\n1\tB" | "$HERE"/th_row.sh
	echo -e "Id\t0\t1\nName\tA\tB" | "$HERE"/th_column.sh
	echo -e "\tA\tB\n1\tX\tY\n2\ta\tb" | "$HERE"/th_row_column.sh
}
Run "$@"
