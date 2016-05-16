#!/bin/bash
#
# @brief   Make a zip archive with single file
# @version ver.1.0
# @date    Fri Oct 02 09:59:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_NAME=zipfile
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/logging.sh
. $UTIL/bin/devel.sh

declare -A TOOL_USAGE=(
    [TOOL_NAME]="__$UTIL_NAME"
    [ARG1]="[FILE] Name of file"
    [EX-PRE]="# Example zipping a file"
    [EX]="__$UTIL_NAME freshtool.txt"
)

declare -A LOG=(
    [TOOL]="$UTIL_NAME"
    [FLAG]="error"
    [PATH]="$UTIL_LOG"
    [MSG]=""
)

#
# @brief  zip a single file
# @params Values required file(s)
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __zipfile "$FILES"
# STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
# else
#   # false
# fi
#
function __zipfile() {
    shift $(($OPTIND - 1))
    FILES=$@
	if [ "$TOOL_DEBUG" == "true" ]; then
		printf "%s\n" "[zip a single file]"
	fi
    if [ -n "$FILES" ]; then
        rm_input=
        while getopts hlr OPTIONS 
        do
            case $OPTIONS in
                r)  rm_input=on 
                    ;;
                \?) 
                    LOG[MSG]="Wrong argument"
					if [ "$TOOL_DEBUG" == "true" ]; then
						printf "%s\n\n" "[Error] ${LOG[MSG]}"
					fi
                    __logging $LOG
                    return $NOT_SUCCESS
                    ;;
            esac
        done
        for a in "${FILES[@]}" 
        do
            if [ -f ${a}.[zZ][iI][pP] ] || [[ ${a##*.} == [zZ][iI][pP] ]]; then
				if [ "$TOOL_DEBUG" == "true" ]; then
                	printf "%s\n"  "Skipping file [$a] - already zipped"
				fi
                continue
            else
                if [ ! -f $a ]; then
					if [ "$TOOL_DEBUG" == "true" ]; then                    
						printf "%s\n" "File [$a] does not exist"
					fi
                    continue 
                fi
				if [ "$TOOL_DEBUG" == "true" ]; then
                	printf "%s\n" "Zipping file [$a]"
				fi                
				zip -9 ${a}.zip $a 
                [[ $rm_input ]] && rm -f -- $a
            fi
        done
		if [ "$TOOL_DEBUG" == "true" ]; then
        	printf "%s\n\n" "[Done]"
		fi
        return $SUCCESS
    fi
    __usage $TOOL_USAGE
    return $NOT_SUCCESS
}

