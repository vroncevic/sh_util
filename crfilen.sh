#!/bin/bash
#
# @brief   Create a file n bytes large
# @version ver.1.0
# @date    Fri Okt 02 09:59:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
TOOL_NAME=crfilen
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
    [ARG1]="[BYTES]      First argument must be an integer"
    [ARG2]="[FILE_NAME]  Name of file"
    [ARG2]="[CHARACHTER] Charachter which will be written in file"
    [EX-PRE]="# Example creating a file n bytes large"
    [EX]="__$TOOL 8 test"	
)

declare -A LOG=(
    [TOOL]="$TOOL_NAME"
    [FLAG]="error"
    [PATH]="$TOOL_LOG"
    [MSG]=""
)

#
# @brief Create a file of n bytes size
# @params Values required number of bytes, name of file and charachter
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __crfilen $BYTES $FILE_NAME $CHARACHTER
# STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#	# true
# else
#	# false
# fi
#
function __crfilen() {
    NBYTES=$1
    FILENAME=$2
    CHARACHTER=$3
    if [ -n "$FILENAME" ] && [ -n "$NBYTES" ] && [ -n "$CHARACHTER" ]; then
        case $NBYTES in
                *[!0-9]*) 
                        __usage $TOOL_USAGE
                        LOG[MSG]="Wrong argument"
                        __logging $LOG
                        return $NOT_SUCCESS
                        ;;
                *)
                        printf "%s" "Generating file"
                        ;;
        esac
        COUNTER=0
        while(($COUNTER != $NBYTES))
        do
            echo -n $CHARACHTER >> "$FILENAME"
            printf "%s" "."
            ((COUNTER++))
        done
        printf "\n%s\n" "Done..."
        return $SUCCESS
    fi
    __usage $TOOL_USAGE
    LOG[MSG]="Missing argument"
    __logging $LOG
    return $NOT_SUCCESS
}
