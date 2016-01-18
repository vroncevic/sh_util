#!/bin/bash
#
# @brief   Insert text file into another file at line n
# @version ver.1.0
# @date    Mon Oct 01 08:41:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
TOOL_NAME=insertext
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
	[TOOL_NAME]="__$TOOL_NAME"
	[ARG1]="[LINE]  An integer referring to line number at which to insert the text file"
	[ARG2]="[TEXT]  The text file to insert"
	[ARG3]="[FILES] The text file to insert into"
	[EX-PRE]="# Example put text into file"
	[EX]="__$TOOL_NAME 3 test file"	
)

declare -A LOG=(
	[TOOL]="$TOOL_NAME"
	[FLAG]="error"
	[PATH]="$TOOL_LOG"
	[MSG]=""
)

#
# @brief Insert text file into another file at line n
# @params Values required line, text and files
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __insertext $LINE $TEXT ${FILES[@]}
# STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#	# true
# else
#	# false
# fi
#
function __insertext() {
	LINE=$1
	TEXT=$2
	shift 2
	FILES=$@
	if [ -n "$LINE" ] && [ -n "$TEXT" ] && [ -n "$FILES" ]; then
		tmp_1=/tmp/tmp.${RANDOM}$$
		tmp_2=/tmp/tmp.${RANDOM}$$
		trap 'rm -f $tmp_1 $tmp_2 >/dev/null 2>&1' 0 
		trap "exit 1" 1 2 3 15
		case "$LINE" in
			+([0-9])) 
					n=$LINE
					for a in "${FILES[@]}" 
					do
						if [ -f $a ]; then
							if [[ $n == 1 ]];then
								touch $tmp_1
								sed -n ''$n',$p' $a > $tmp_2
								cat $tmp_1 $TEXT $tmp_2 > $a
								continue
							fi
							((n--)) 
							sed -n '1,'$n'p' $a > $tmp_1
							((n++)) 
							sed -n ''$n',$p' $a > $tmp_2
							cat $tmp_1 $TEXT $tmp_2 > $a
						else
							printf "%s\n" "[$a] does not exist or is not a file..."
						fi
					done 
					;;
			*) 
					__usage $TOOL_USAGE
					LOG[MSG]="Missing argument"
					__logging $LOG
					return $NOT_SUCCESS
					;;
		esac
		printf "%s\n" "Done..."
		return $SUCCESS
	fi
	__usage $TOOL_USAGE
	LOG[MSG]="Missing argument"
	__logging $LOG
	return $NOT_SUCCESS
}
