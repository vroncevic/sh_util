#!/bin/bash
#
# @brief   Make a zip archive with single file
# @version ver.1.0
# @date    Fri Oct 02 09:59:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
TOOL_NAME=zipfile
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
    [TOOL_NAME]="__$TOOL"
    [ARG1]="[FILE] Name of file"
    [EX-PRE]="# Example zipping a file"
    [EX]="__$TOOL freshtool.txt"
)

declare -A LOG=(
    [TOOL]="$TOOL_NAME"
    [FLAG]="error"
    [PATH]="$TOOL_LOG"
    [MSG]=""
)

#
# @brief zip a single file
# @params Values required file(s)
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __zipfile $FILES
# STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#	# true
# else
#	# false
# fi
#
function __zipfile() {
    shift $(($OPTIND - 1))
    FILES=$@
    if [ -n "$FILES" ]; then
        rm_input=
        while getopts hlr OPTIONS 
        do
            case $OPTIONS in
                r)  rm_input=on 
                    ;;
                \?) 
                    __usage $TOOL_USAGE
                    LOG[MSG]="Wrong argument"
                    __logging $LOG
                    return $NOT_SUCCESS
                    ;;
            esac
        done
        for a in "${FILES[@]}" 
        do
            if [ -f ${a}.[zZ][iI][pP] ] || [[ ${a##*.} == [zZ][iI][pP] ]]; then
                printf "%s\n"  "Skipping file [$a] - already zipped"
                continue
            else
                if [ ! -f $a ]; then
                    printf "%s\n" "File [$a] does not exist"
                    continue 
                fi
                printf "%s\n" "Zipping file [$a]..."
                zip -9 ${a}.zip $a 
                [[ $rm_input ]] && rm -f -- $a
            fi
        done
        printf "%s\n" "Done..."
        return $SUCCESS
    fi
    __usage $TOOL_USAGE
    LOG[MSG]="Missing argument"
    __logging $LOG
    return $NOT_SUCCESS
}
