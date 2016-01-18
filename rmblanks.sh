#!/bin/bash
#
# @brief   Remove empty or blank lines from an ascii file and replace the original file
# @version ver.1.0
# @date    Fri Oct 02 09:59:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
TOOL_NAME=rmblanks
TOOL_VERSION=ver.1.0
TOOL_EXECUTABLE="${BASH_SOURCE[0]}"
TOOL_BIN=`dirname $TOOL_EXECUTABLE`
TOOL_HOME=`dirname $TOOL_BIN`
TOOL_LOG=$TOOL_HOME/log

. $TOOL_BIN/usage.sh
. $TOOL_BIN/logging.sh

SUCCESS=0
NOT_SUCCESS=1

declare -A TOOL_USAGE=(
	[TOOL_NAME]="__$TOOL"
	[ARG1]="[FILES] Name of file"
	[EX-PRE]="# Removing blank lines from file"
	[EX]="__$TOOL /data/test.txt"	
)

declare -A LOG=(
	[TOOL]="$TOOL_NAME"
	[FLAG]="error"
	[PATH]="$TOOL_LOG"
	[MSG]=""
)

#
# @brief Remove empty or blank lines from an ascii file and replace the original file
# @argument Value required name of file or path to the file
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __rmblanks $STATUS
# STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#	# true
# else
#	# false
# fi
#
function __rmblanks() {
	FILES=$@
	if [ -n "$FILES" ]; then 
		tmp_1=/tmp/tmp.${RANDOM}$$
		trap 'rm -f $tmp_1 >/dev/null 2>&1' 0
		trap "exit 1" 1 2 3 15
		for a in "${FILES[@]}"
		do
			if [ -f "$a" ]; then
				file "$a" | grep -q text
				CHECKTXT=$?
				if [ $CHECKTXT -eq $SUCCESS ]; then
					sed '/^[ 	]*$/d' < "$a" > $tmp_1 && mv $tmp_1 "$a"
				else
					printf "%s\n" "File [$a] is not in ascii type"
				fi
			else
				printf "%s\n" "File [$a] does not exist"
			fi
		done
		printf "%s\n" "Done..."
		return $SUCCESS
	fi
	__usage $TOOL_USAGE
	LOG[MSG]="Missing argument"
	__logging $LOG
	return $NOT_SUCCESS
}
