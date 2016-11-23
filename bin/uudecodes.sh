#!/bin/bash
#
# @brief   Decode a binary representation
# @version ver.1.0
# @date    Fri Oct 02 09:59:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_UUDECODES=uudecodes
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/checktool.sh
. $UTIL/bin/devel.sh

declare -A UUDECODES_USAGE=(
    [TOOL_NAME]="__$UTIL_UUDECODES"
    [ARG1]="[FILE_NAME] Path to binary file"
    [EX-PRE]="# Example decode thunderbird binary"
    [EX]="__$UTIL_UUDECODES thunderbird-bin"	
)

#
# @brief  Decode a binary representation
# @param  Value required path to file 
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __uudecodes $FILE_PATH
# local STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
#   # notify admin | user
# else
#   # false
#   # missing argument | missing file | missing tool
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __uudecodes() {
    local FILE_PATH=$1
	if [ -n "$FILE_PATH" ]; then
		local FUNC=${FUNCNAME[0]}
		local MSG=""
		local UUDEC="/usr/bin/uudecode"
		__checktool "$UUDEC"
		local STATUS=$?
		if [ "$STATUS" -eq "$SUCCESS" ]; then
			if [ "$TOOL_DBG" == "true" ]; then
				MSG="Checking file [$FILE_PATH]"
				printf "$DQUE" "$UTIL_UUDECODES" "$FUNC" "$MSG"
			fi
			if [ -e "$FILE_PATH" ]; then
				if [ "$TOOL_DBG" == "true" ]; then
					printf "%s\n" "[ok]"
					MSG="Decoding [$FILE_PATH]"
					printf "$DSTA" "$UTIL_UUDECODES" "$FUNC" "$MSG"
				fi
				eval "$UUDEC $FILE_PATH"
				if [ "$TOOL_DBG" == "true" ]; then
					printf "$DEND" "$UTIL_UUDECODES" "$FUNC" "Done"
				fi
				return $SUCCESS
			fi
			if [ "$TOOL_DBG" == "true" ]; then
				printf "%s\n" "[not ok]"
			fi
			MSG="Please check file path [$FILE_PATH]"
			printf "$SEND" "$UTIL_UUDECODES" "$MSG"
			return $NOT_SUCCESS
		fi
		return $NOT_SUCCESS
	fi
    __usage $UUDECODES_USAGE
    return $NOT_SUCCESS
}

#
# @brief  Decode a binary representations in folder
# @param  Value required path to file 
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __uudecodes_all "$FILE_PATH"
# local STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
#   # notify admin | user
# else
#   # false
#   # missing argument | missing file | missing tool
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __uudecodes_all() {
	local FILE_PATH=$1
    if [ -z "$FILE_PATH" ]; then
		local FUNC=${FUNCNAME[0]}
		local MSG=""
		local UUDEC="/usr/bin/uudecode"
		__checktool "$UUDEC"
		local STATUS=$?
		if [ "$STATUS" -eq "$SUCCESS" ]; then
			if [ "$TOOL_DBG" == "true" ]; then
				MSG="Decode a binary representations at [$FILE_PATH/]"
				printf "$DSTA" "$UTIL_UUDECODES" "$FUNC" "$MSG"
			fi
			for filedecode in *
			do
				local search1=`head -$lines $filedecode | grep begin | wc -w`
				local search2=`tail -$lines $filedecode | grep end | wc -w`
				if [ "$search1" -gt 0 ]; then
					if [ "$search2" -gt 0 ]; then
						if [ "$TOOL_DBG" == "true" ]; then
							MSG="Decoding [$filedecode]"
							printf "$DSTA" "$UTIL_UUDECODES" "$FUNC" "$MSG"
						fi
						eval "$UUDEC $filedecode"
					fi
				fi
			done
			if [ "$TOOL_DBG" == "true" ]; then
				printf "$DEND" "$UTIL_UUDECODES" "$FUNC" "Done"
			fi
			return $SUCCESS
        fi
        return $NOT_SUCCESS
    fi
    __usage $UUDECODES_USAGE
    return $NOT_SUCCESS
}

