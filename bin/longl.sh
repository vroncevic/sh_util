#!/bin/bash
#
# @brief   Print name of the file that contains lines longer then n chars
# @version ver.1.0
# @date    Fri Okt 02 09:59:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_LONGL=longl
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/devel.sh

declare -A LONGL_USAGE=(
    [TOOL_NAME]="__$UTIL_LONGL"
    [ARG1]="[NUMCHARS] an integer referring to minimum characters per line"
    [EX-PRE]="# Print file name, that contain lines longer then 45 chars"
    [EX]="__$UTIL_LONGL 45"	
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
# local STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
#   # notify admin | user
# else
#   # false
#   # missing argument(s) | wrong argument(s)
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __longl() {
    local NUMCHARS=$1
    shift
    local FILES=$@
    if [ -n "$NUMCHARS" ] && [ -n "$FILES" ]; then
		local FUNC=${FUNCNAME[0]}
		local MSG=""
		if [ "$TOOL_DBG" == "true" ]; then
			MSG="Print file name that contains lines longer then n chars"
			printf "$DSTA" "$UTIL_LONGL" "$FUNC" "$MSG"
		fi
        case $NUMCHARS in
            +([0-9])) 
                for a in "${FILES[@]}" 
                do
                    local COUNTER=0
                    IFS=\n
                    while read line 
                    do
                        if (( ${#line} > $NUMCHARS ));then
                            printf "%s %s %s\n" \
                            "Chars: ${#line}" \
                            "Line#: $COUNTER" \
                            "File: $a"
                        fi 
                        ((COUNTER++))
                    done < $a
                done 
                ;;
            *)
				MSG="Wrong argument"
				printf "$SEND" "$UTIL_LONGL" "$MSG"
                return $NOT_SUCCESS
                ;;
        esac
		if [ "$TOOL_DBG" == "true" ]; then
			printf "$DEND" "$UTIL_LONGL" "$FUNC" "Done"
		fi
    fi
    __usage $LONGL_USAGE
    return $NOT_SUCCESS
}

