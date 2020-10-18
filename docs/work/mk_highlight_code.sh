#!/usr/bin/env bash
Run() {
	THIS="$(realpath "${BASH_SOURCE:-0}")"; HERE="$(dirname "$THIS")"; PARENT="$(dirname "$HERE")"; THIS_NAME="$(basename "$THIS")"; APP_ROOT="$PARENT";
	cd "$HERE"
	highlight -O html -S bash -s 'darkness' -u 'utf-8' run.sh 
	echo ""
	highlight -O html -S html -s 'darkness' -u 'utf-8' html.html
}
Run "$@"
