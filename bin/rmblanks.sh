#!/bin/bash
#
# @brief   Remove blank lines from an ascii file and replace the original file
# @version ver.1.0
# @date    Fri Oct 02 09:59:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_RMBLANKS=rmblanks
UTIL_RMBLANKS_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_RMBLANKS_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/devel.sh

declare -A RMBLANKS_USAGE=(
    [TOOL]="__$UTIL_RMBLANKS"
    [ARG1]="[FILES] Name of file"
    [EX-PRE]="# Removing blank lines from file"
    [EX]="__$UTIL_RMBLANKS /data/test.txt"	
)

#
# @brief  Remove blank lines from an ascii file and replace the original file
# @param  Value required name of file or path to the file
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __rmblanks "test.ini"
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#   # true
#   # notify admin | user
# else
#   # false
#   # missing argument(s)
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __rmblanks() {
    local FILES=$@
    if [ -n "$FILES" ]; then
		local FUNC=${FUNCNAME[0]}
		local MSG=""
		if [ "$TOOL_DBG" == "true" ]; then
        	MSG="Remove blank lines from an ascii file, replace original file"
			printf "$DSTA" "$UTIL_RMBLANKS" "$FUNC" "$MSG"
		fi
        local tmp1=/tmp/tmp.${RANDOM}$$
        trap 'rm -f $tmp1 >/dev/null 2>&1' 0
        trap "exit 1" 1 2 3 15
        for a in "${FILES[@]}"
        do
			if [ "$TOOL_DBG" == "true" ]; then
				MSG="Checking file [$a]"
				printf "$DQUE" "$UTIL_RMBLANKS" "$FUNC" "$MSG"
			fi
            if [ -f "$a" ]; then
				if [ "$TOOL_DBG" == "true" ]; then
					printf "%s\n" "[ok]"
				fi
                file "$a" | grep -q text
                local STATUS=$?
                if [ $STATUS -eq $SUCCESS ]; then
                    sed '/^[ 	]*$/d' < "$a" > $tmp1 && mv $tmp1 "$a"
                else
					if [ "$TOOL_DBG" == "true" ]; then
                    	MSG="File [$a] is not in ascii type"
						printf "$DSTA" "$UTIL_RMBLANKS" "$FUNC" "$MSG"
					fi
					:
                fi
            else
				printf "%s\n" "[not ok]"
				MSG="Please check file [$a]"
				printf "$SEND" "$UTIL_RMBLANKS" "$MSG"
            fi
            :
        done
		if [ "$TOOL_DBG" == "true" ]; then
        	printf "$DEND" "$UTIL_RMBLANKS" "$FUNC" "Done"
		fi
        return $SUCCESS
    fi
    __usage $RMBLANKS_USAGE
    return $NOT_SUCCESS
}

