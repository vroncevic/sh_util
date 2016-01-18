#!/bin/bash
#
# @brief   Print name of the file that contains lines longer then n chars
# @version ver.1.0
# @date    Fri Okt 02 09:59:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
TOOL_NAME=longl
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
    [ARG1]="[NUMCHARS] an integer referring to minimum characters per line"
    [EX-PRE]="# Example print name of file that contain lines longer then 45 chars"
    [EX]="__$TOOL 45"	
)

declare -A LOG=(
    [TOOL]="$TOOL_NAME"
    [FLAG]="error"
    [PATH]="$TOOL_LOG"
    [MSG]=""
)

#
# @brief Print name of the file that contains lines longer then n chars
# @argument Values required number of characters and files
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __longl $NUMCHARS ${FILES[@]}
# STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#	# true
# else
#	# false
# fi
#
function __longl() {
    NUMCHARS=$1
    shift
    FILES=$@
    if [ -n "$NUMCHARS" ] && [ -n "$FILES" ]; then
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
                __usage $TOOL_USAGE
                LOG[MSG]="Wrong argument"
                __logging $LOG
                return $NOT_SUCCESS
                ;;
        esac
    fi
    __usage $TOOL_USAGE
    LOG[MSG]="Missing argument"
    __logging $LOG
    return $NOT_SUCCESS
}
