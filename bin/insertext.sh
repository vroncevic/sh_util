#!/bin/bash
#
# @brief   Insert text file into another file at line n
# @version ver.1.0
# @date    Mon Oct 01 08:41:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_INSERTEXT=insertext
UTIL_INSERTEXT_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_INSERTEXT_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/devel.sh

declare -A INSERTEXT_USAGE=(
    ["TOOL"]="__$UTIL_INSERTEXT"
    ["ARG1"]="[LINE]  An integer referring to line number at which to insert the text file"
    ["ARG2"]="[TEXT]  The text file to insert"
    ["ARG3"]="[FILES] The text file to insert into"
    ["EX-PRE"]="# Example put text into file"
    ["EX"]="__$UTIL_INSERTEXT 3 test file"	
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
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#   # true
#   # notify admin | user
# else
#   # false
#   # missing argument(s) | wrong argument
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __insertext() {
    local LINE=$1
    local TEXT=$2
    shift 2
    local FILES=$@
    if [ -n "$LINE" ] && [ -n "$TEXT" ] && [ -n "$FILES" ]; then
		local FUNC=${FUNCNAME[0]}
		local MSG=""
		if [ "$TOOL_DBG" == "true" ]; then
			MSG="Insert text file into another file at line n"
			printf "$DSTA" "$UTIL_INSERTEXT" "$FUNC" "$MSG"
		fi
        local tmp1=/tmp/tmp.${RANDOM}$$
        local tmp2=/tmp/tmp.${RANDOM}$$
        trap 'rm -f $tmp1 $tmp2 >/dev/null 2>&1' 0 
        trap "exit 1" 1 2 3 15
        case "$LINE" in
            +([0-9])) 
                local n=$LINE
                for a in "${FILES[@]}" 
                do
                    if [ -f "$a" ]; then
                        if [[ $n == 1 ]];then
                            touch "$tmp1"
                            sed -n ''$n',$p' "$a" > "$tmp2"
                            cat "$tmp1" "$TEXT" "$tmp2" > "$a"
                            continue
                        fi
                        ((n--)) 
                        sed -n '1,'$n'p' "$a" > "$tmp1"
                        ((n++)) 
                        sed -n ''$n',$p' "$a" > "$tmp2"
                        cat "$tmp1" "$TEXT" "$tmp2" > "$a"
                    else
						MSG="Check file [$a]"
						printf "$SEND" "$UTIL_INSERTEXT" "$FUNC" "$MSG"
                    fi
                done 
                ;;
            *) 
                MSG="Wrong argument"
				printf "$SEND" "$UTIL_INSERTEXT" "$FUNC" "$MSG"
                return $NOT_SUCCESS
                ;;
        esac
		if [ "$TOOL_DBG" == "true" ]; then
        	printf "$DEND" "$UTIL_INSERTEXT" "$FUNC" "Done"
		fi
        return $SUCCESS
    fi
    __usage "$(declare -p INSERTEXT_USAGE)"
    return $NOT_SUCCESS
}

