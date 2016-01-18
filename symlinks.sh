#!/bin/bash
#
# @brief   Lists symbolic links in a directory
# @version ver.1.0
# @date    Mon Oct 12 22:23:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
TOOL_NAME=symlinks
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
	[ARG1]="[DIRECTORY] Directory path"
	[EX-PRE]="# Example listing symlinks"
	[EX]="__$TOOL_NAME /data/"	
)

declare -A LOG=(
	[TOOL]="$TOOL_NAME"
	[FLAG]="error"
	[PATH]="$TOOL_LOG"
	[MSG]=""
)

#
# @brief  Lists symbolic links in a directory
# @argument Value required directory path
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __symlinks $DIRECTORY
# STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#	# true
# else
#	# false
# fi
#
function __symlinks() {
	DIRECTORY=$1
	if [ -n "$DIRECTORY" ]; then
		printf "%s\n" "Symbolic links in directory \"$DIRECTORY\""
		for listedfile in "$(find $DIRECTORY -type l)"
		do
			printf "%s\n" " $listedfile"
		done | sort
		printf "%s\n" "Symbolic links in directory \"$DIRECTORY\""
		OLDIFS=$IFS
		IFS=:
		for listedfile in $(find $DIRECTORY -type l -printf "%p$IFS")
		do
			printf "%s\n" "$listedfile"
		done | sort
		return $SUCCESS
	fi
	__usage $TOOL_USAGE
	LOG[MSG]="Missing argument"
	__logging $LOG
	return $NOT_SUCCESS
}
