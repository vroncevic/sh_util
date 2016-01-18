#!/bin/bash
#
# @brief   Blot out some file
# @version ver.1.0
# @date    Tue Oct 13 16:14:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
TOOL_NAME=blotout
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
    [TOOL_NAME]="__$TOOL_NAME"
    [ARG1]="[FILE_NAME] Name of file"
    [EX-PRE]="# Example delete file with high security"
    [EX]="__$TOOL_NAME /data/test.cfg"	
)

declare -A LOG=(
    [TOOL]="$TOOL_NAME"
    [FLAG]="error"
    [PATH]="$TOOL_LOG"
    [MSG]=""
)

PASSES=7
BLOCKSIZE=1

#
# @brief Blot out some file
# @argument Value required file name
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __blotout $FILE_NAME
# STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#	# true
# else
#	# false
# fi
#
function __blotout() {
    FILE=$1
    if [ -n "$FILE" ]; then
        if [ ! -e "$FILE" ]; then
            printf "%s\n" " File [$FILE] not found"
            return $NOT_SUCCESS
        fi
        printf "%s\n" "Are you absolutely sure you want to blot out [$FILE] (y/n)? "
        read answer
        case "$answer" in
            [nN]) 
                            printf "%s\n" "Changed your mind, huh?"
                            return $NOT_SUCCESS
                            ;;
            *)
                            printf "%s\n" "Blotting out file \"$FILE\""
                            ;;
        esac
        flength=$(ls -l "$FILE" | awk '{print $5}')
        pass_count=1
        chmod u+w "$FILE"
        while [ "$pass_count" -le "$PASSES" ]
        do
            printf "%s\n" "Pass #$pass_count"
            sync
            dd if=/dev/urandom of=$FILE bs=$BLOCKSIZE count=$flength
            sync
            dd if=/dev/zero of=$FILE bs=$BLOCKSIZE count=$flength
            sync
            let "pass_count += 1"
        done
        rm -f $FILE
        sync
        printf "%s\n" "File [$FILE] blotted out and deleted"
        return $SUCCESS
    fi
    __usage $TOOL_USAGE
    LOG[MSG]="Missing argument"
    __logging $LOG
    return $NOT_SUCCESS
}
