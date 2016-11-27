#!/bin/bash
#
# @brief   Create a file n bytes size
# @version ver.1.0
# @date    Fri Okt 02 09:59:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_CRFILEN=crfilen
UTIL_CRFILEN_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_CRFILEN_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/devel.sh
. $UTIL/bin/usage.sh

declare -A CRFILEN_USAGE=(
    [USAGE_TOOL]="__$UTIL_CRFILEN"
    [USAGE_ARG1]="[CREATE_STRUCTURE] Number of bytes, file name and Character"
    [USAGE_EX_PRE]="# Example creating a file n bytes large"
    [USAGE_EX]="__$UTIL_CRFILEN \$CREATE_STRUCTURE"	
)

#
# @brief  Create a file of n bytes size
# @param  Value required structure
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# declare -A CREATE_STRUCTURE=(
# 	[NB]=8
# 	[FN]="test.ini"
# 	[CH]="D"
# )
#
# __crfilen CREATE_STRUCTURE
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#   # true
#   # notify admin | user
# else
#   # false
#	# missing argument | wrong argument
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __crfilen() {
	local -n CREATE_STRUCTURE=$1
    local NBYTES=${CREATE_STRUCTURE[NB]}
    local FILENAME=${CREATE_STRUCTURE[FN]}
    local CHARACHTER=${CREATE_STRUCTURE[CH]}
    if [ -n "$FILENAME" ] && [ -n "$NBYTES" ] && [ -n "$CHARACHTER" ]; then
		local FUNC=${FUNCNAME[0]}
		local MSG="None"
		if [ "$TOOL_DBG" == "true" ]; then
			MSG="Create a file n bytes size"
			printf "$DSTA" "$UTIL_CRFILEN" "$FUNC" "$MSG"
		fi
        case $NBYTES in
            *[!0-9]*) 
                __usage CRFILEN_USAGE
                return $NOT_SUCCESS
                ;;
            *)
				if [ "$TOOL_DBG" == "true" ]; then
                	MSG="Generating file [$FILENAME]"
					printf "$DSTA" "$UTIL_CRFILEN" "$FUNC" "$MSG"
				fi
				:
                ;;
        esac
		if [ "$TOOL_DBG" == "true" ]; then
        	MSG="Write to file [$FILENAME]"
			printf "$DSTA" "$UTIL_CRFILEN" "$FUNC" "$MSG"
		fi
        local COUNTER=0
        while(($COUNTER != $NBYTES))
        do
            echo -n "$CHARACHTER" >> "$FILENAME"
			if [ "$TOOL_DBG" == "true" ]; then            
				printf "%s" "."
			fi
            ((COUNTER++))
        done
		if [ "$TOOL_DBG" == "true" ]; then
        	printf "$DEND" "$UTIL_CRFILEN" "$FUNC" "Done"
		fi
        return $SUCCESS
    fi
    __usage CRFILEN_USAGE
    return $NOT_SUCCESS
}

