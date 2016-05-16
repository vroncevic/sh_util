#!/bin/bash
#
# @brief   Blot out some file
# @version ver.1.0
# @date    Tue Oct 13 16:14:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_NAME=blotout
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/logging.sh
. $UTIL/bin/devel.sh

declare -A TOOL_USAGE=(
    [TOOL_NAME]="__$UTIL_NAME"
    [ARG1]="[FILE_NAME] Name of file"
    [EX-PRE]="# Example delete file with high security"
    [EX]="__$UTIL_NAME /opt/test.ini"	
)

declare -A LOG=(
    [TOOL]="$UTIL_NAME"
    [FLAG]="error"
    [PATH]="$UTIL_LOG"
    [MSG]=""
)

PASSES=7
BLOCKSIZE=1

#
# @brief  Blot out some file
# @param  Value required file name
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __blotout "$FILE_NAME"
# STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
# else
#   # false
# fi
#
function __blotout() {
    FILE=$1
    if [ -n "$FILE" ]; then
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n" "[Blot out file]"
			printf "%s" "Checking file [$FILE] "
		fi
        if [ ! -e "$FILE" ]; then
			LOG[MSG]="Check file [$FILE]"
			if [ "$TOOL_DEBUG" == "true" ]; then
				printf "%s\n" "[not ok]"
            	printf "%s\n\n" "[Error] ${LOG[MSG]}"
			fi
            __logging $LOG
            return $NOT_SUCCESS
        fi
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n" "[ok]"
		fi
        printf "%s\n" "Are you absolutely sure you want to blot out [$FILE] (y/n)? "
        read answer
        case "$answer" in
            [nN]) 
				if [ "$TOOL_DEBUG" == "true" ]; then
                	printf "%s\n" "Changed your mind, huh?"
				fi
                return $NOT_SUCCESS
                ;;
            *)
				if [ "$TOOL_DEBUG" == "true" ]; then
                	printf "%s\n" "Blotting out file \"$FILE\""
				fi
				:
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
		if [ "$TOOL_DEBUG" == "true" ]; then
        	printf "%s\n" "File [$FILE] blotted out and deleted"
			printf "%s\n\n" "[Done]"
		fi
        return $SUCCESS
    fi
    __usage $TOOL_USAGE
    return $NOT_SUCCESS
}

