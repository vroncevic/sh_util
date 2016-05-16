#!/bin/bash
#
# @brief   Insert text file into another file at line n
# @version ver.1.0
# @date    Mon Oct 01 08:41:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_NAME=insertext
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/logging.sh
. $UTIL/bin/devel.sh

declare -A TOOL_USAGE=(
    [TOOL_NAME]="__$UTIL_NAME"
    [ARG1]="[LINE]  An integer referring to line number at which to insert the text file"
    [ARG2]="[TEXT]  The text file to insert"
    [ARG3]="[FILES] The text file to insert into"
    [EX-PRE]="# Example put text into file"
    [EX]="__$UTIL_NAME 3 test file"	
)

declare -A LOG=(
    [TOOL]="$UTIL_NAME"
    [FLAG]="error"
    [PATH]="$UTIL_LOG"
    [MSG]=""
)

#
# @brief  Insert text file into another file at line n
# @params Values required line, text and files
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __insertext $LINE $TEXT ${FILES[@]}
# STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
# else
#   # false
# fi
#
function __insertext() {
    LINE=$1
    TEXT=$2
    shift 2
    FILES=$@
    if [ -n "$LINE" ] && [ -n "$TEXT" ] && [ -n "$FILES" ]; then
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n" "[Insert text file into another file at line n]"
		fi
        tmp_1=/tmp/tmp.${RANDOM}$$
        tmp_2=/tmp/tmp.${RANDOM}$$
        trap 'rm -f $tmp_1 $tmp_2 >/dev/null 2>&1' 0 
        trap "exit 1" 1 2 3 15
        case "$LINE" in
            +([0-9])) 
                n=$LINE
                for a in "${FILES[@]}" 
                do
                    if [ -f "$a" ]; then
                        if [[ $n == 1 ]];then
                            touch "$tmp_1"
                            sed -n ''$n',$p' "$a" > "$tmp_2"
                            cat "$tmp_1" "$TEXT" "$tmp_2" > "$a"
                            continue
                        fi
                        ((n--)) 
                        sed -n '1,'$n'p' "$a" > "$tmp_1"
                        ((n++)) 
                        sed -n ''$n',$p' "$a" > "$tmp_2"
                        cat "$tmp_1" "$TEXT" "$tmp_2" > "$a"
                    else
						LOG[MSG]="Check file [$a]"
						if [ "$TOOL_DEBUG" == "true" ]; then
                        	printf "%s\n" "[Error] ${LOG[MSG]}"
						fi
                        __logging $LOG
                    fi
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
        return $SUCCESS
    fi
    __usage $TOOL_USAGE
    return $NOT_SUCCESS
}

