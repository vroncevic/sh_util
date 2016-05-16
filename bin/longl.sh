#!/bin/bash
#
# @brief   Print name of the file that contains lines longer then n chars
# @version ver.1.0
# @date    Fri Okt 02 09:59:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_NAME=longl
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/logging.sh
. $UTIL/bin/devel.sh

declare -A TOOL_USAGE=(
    [TOOL_NAME]="__$UTIL_NAME"
    [ARG1]="[NUMCHARS] an integer referring to minimum characters per line"
    [EX-PRE]="# Example print name of file that contain lines longer then 45 chars"
    [EX]="__$UTIL_NAME 45"	
)

declare -A LOG=(
    [TOOL]="$UTIL_NAME"
    [FLAG]="error"
    [PATH]="$UTIL_LOG"
    [MSG]=""
)

#
# @brief  Print name of the file that contains lines longer then n chars
# @params Values required number of characters and files
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __longl $NUMCHARS ${FILES[@]}
# STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
# else
#   # false
# fi
#
function __longl() {
    NUMCHARS=$1
    shift
    FILES=$@
    if [ -n "$NUMCHARS" ] && [ -n "$FILES" ]; then
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n" "[Print name of the file that contains lines longer then n chars]"
		fi
        case $NUMCHARS in
            +([0-9])) 
                for a in "${FILES[@]}" 
                do
                    COUNTER=0
                    IFS=\n
                    while read line 
                    do
                        if (( ${#line} > $NUMCHARS ));then
                            printf "%s %s %s\n" "Chars: ${#line} Line#: $COUNTER File: $a"
                        fi 
                        ((COUNTER++))
                    done < $a
                done 
                ;;
            *)
                LOG[MSG]="Wrong argument"
				if [ "$TOOL_DEBUG" == "true" ]; then
					printf "%s\n\n" "[Error] ${LOG[MSG]}"
				fi
                __logging $LOG
                return $NOT_SUCCESS
                ;;
        esac
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n\n" "[Done]"
		fi
    fi
    __usage $TOOL_USAGE
    return $NOT_SUCCESS
}

