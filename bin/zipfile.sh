#!/bin/bash
#
# @brief   Make a zip archive with single target file
# @version ver.1.0
# @date    Fri Oct 02 09:59:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_ZIPFILE=zipfile
UTIL_ZIPFILE_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_ZIPFILE_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/devel.sh

declare -A ZIPFILE_USAGE=(
    ["TOOL"]="__$UTIL_ZIPFILE"
    ["ARG1"]="[FILE] Name of file"
    ["EX-PRE"]="# Example zipping a file"
    ["EX"]="__$UTIL_ZIPFILE freshtool.txt"
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
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#   # true
#   # notify admin | user
# else
#   # false
#   # missing argument(s
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __zipfile() {
    shift $(($OPTIND - 1))
    local FILES=$@
    if [ -n "$FILES" ]; then
		local FUNC=${FUNCNAME[0]}
		local MSG=""
        local rm_input=
        while getopts hlr OPTIONS 
        do
            case $OPTIONS in
                r)  rm_input=on 
                    ;;
                \?) 
					MSG="Wrong argument"
					printf "$SEND" "$UTIL_ZIPFILE" "$MSG"
                    return $NOT_SUCCESS
                    ;;
            esac
        done
        for a in "${FILES[@]}" 
        do
            if [ -f ${a}.[zZ][iI][pP] ] || [[ ${a##*.} == [zZ][iI][pP] ]]; then
				if [ "$TOOL_DBG" == "true" ]; then
                	MSG="Skipping file [$a] - already zipped"
					printf "$DSTA" "$UTIL_ZIPFILE" "$FUNC" "$MSG"
				fi
                continue
            else
                if [ ! -f $a ]; then
					if [ "$TOOL_DBG" == "true" ]; then                    
						MSG="File [$a] does not exist"
						printf "$DSTA" "$UTIL_ZIPFILE" "$FUNC" "$MSG"
					fi
                    continue 
                fi
				if [ "$TOOL_DBG" == "true" ]; then
                	MSG="Zipping file [$a]"
					printf "$DSTA" "$UTIL_ZIPFILE" "$FUNC" "$MSG"
				fi                
				zip -9 ${a}.zip $a 
                [[ $rm_input ]] && rm -f -- $a
            fi
        done
		if [ "$TOOL_DBG" == "true" ]; then
        	printf "$DEND" "$UTIL_ZIPFILE" "$FUNC" "Done"
		fi
        return $SUCCESS
    fi
    __usage "$(declare -p ZIPFILE_USAGE)"
    return $NOT_SUCCESS
}

