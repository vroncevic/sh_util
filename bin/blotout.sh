#!/bin/bash
#
# @brief   Blot out some file
# @version ver.1.0
# @date    Tue Oct 13 16:14:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_BLOTOUT=blotout
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/devel.sh

declare -A BLOTOUT_USAGE=(
    [TOOL_NAME]="__$UTIL_BLOTOUT"
    [ARG1]="[FILE_NAME] Name of file"
    [EX-PRE]="# Example delete file with high security"
    [EX]="__$UTIL_BLOTOUT /opt/test.ini"	
)

#
# @brief  Blot out some file
# @param  Value required file name
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __blotout "$FILE_NAME"
# local STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
#	# notify admin | user
# else
#   # false
#	# missing argument | break | failed to delete file
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __blotout() {
    local FILE=$1
    if [ -n "$FILE" ]; then
		local FUNC=${FUNCNAME[0]}
		local MSG=""
		local PASSES=7
		local BLOCKSIZE=1
		if [ "$TOOL_DBG" == "true" ]; then
			MSG="Checking file [$FILE]"
			printf "$DQUE" "$UTIL_BLOTOUT" "$FUNC" "$MSG"
		fi
        if [ ! -e "$FILE" ]; then
			if [ "$TOOL_DBG" == "true" ]; then
				printf "%s\n" "[not ok]"
			fi
			MSG="Check file [$FILE]"
			printf "$SEND" "$UTIL_BLOTOUT" "$MSG"
            return $NOT_SUCCESS
        fi
		if [ "$TOOL_DBG" == "true" ]; then
			printf "%s\n" "[ok]"
		fi
        printf "\n%s\n" "Are you sure you want to blot out [$FILE] (y/n)? "
        read answer
        case "$answer" in
            [nN]) 
				if [ "$TOOL_DBG" == "true" ]; then
                	printf "%s\n" ""
                	MSG="Changed your mind, huh?"
                	printf "$DSTA" "$UTIL_BLOTOUT" "$FUNC" "$MSG"
				fi
                return $NOT_SUCCESS
                ;;
            *)
				if [ "$TOOL_DBG" == "true" ]; then
                	MSG="Blotting out file \"$FILE\""
                	printf "$DSTA" "$UTIL_BLOTOUT" "$FUNC" "$MSG" 
				fi
				:
                ;;
        esac
        local flength=$(ls -l "$FILE" | awk '{print $5}')
        local pass_count=1
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
		if [ "$TOOL_DBG" == "true" ]; then
        	MSG="File [$FILE] blotted out and deleted"
        	printf "$DSTA" "$UTIL_BLOTOUT" "$FUNC" "$MSG"
			printf "$DEND" "$UTIL_BLOTOUT" "$FUNC" "Done"
		fi
        return $SUCCESS
    fi
    __usage $BLOTOUT_USAGE
    return $NOT_SUCCESS
}
