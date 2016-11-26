#!/bin/bash
#
# @brief   Detecting low swap
# @version ver.1.0
# @date    Wed Sep 30 22:49:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_LOWSWAP=lowswap
UTIL_LOWSWAP_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_LOWSWAP_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/sendmail.sh
. $UTIL/bin/devel.sh

declare -A LOWSWAP_USAGE=(
    ["TOOL"]="__$UTIL_LOWSWAP"
    ["ARG1"]="[LOW_LIMIT]   An integer referring to MB"
    ["ARG2"]="[ADMIN_EMAIL] Administrator email address"
    ["EX-PRE"]="# Checking swap memory, is under 12 MB"
    ["EX"]="__$UTIL_LOWSWAP 12 vladimir.roncevic@frobas.com"	
)

#
# @brief  Notify when free swap memory is less then n Megabytes
# @params Values required count of MB and Admin email
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __lowswap "$MEM_LIMIT" "$ADMIN_EMAIL"
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#   # true
#   # notify admin | user
# else
#   # false
#   # missing argument(s) | wrong argument(s) | failed to send email
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __lowswap() {
    local SWAP_LIMIT=$1
    local ADMIN_EMAIL=$2
    if [ -n "$SWAP_LIMIT" ] && [ -n "$ADMIN_EMAIL" ]; then
		local FUNC=${FUNCNAME[0]}
		local MSG=""
		if [ "$TOOL_DBG" == "true" ]; then
        	MSG="Checking swap memory, limit [$SWAP_LIMIT]"
			printf "$DSTA" "$UTIL_LOWSWAP" "$FUNC" "$MSG"
		fi
        case $SWAP_LIMIT in
            +([0-9]))
                SWAP_FREE=$(free -mo | grep Swap | { read a b c d; echo $d; })
                if [[ $SWAP_FREE < $SWAP_LIMIT ]]; then
					local EMSG="Swap is running low! Less then $SWAP_LIMIT MB."
                    __sendmail "$EMSG" "$ADMIN_EMAIL"
                    local STATUS=$?
                    if [ "$STATUS" -eq "$NOT_SUCCESS" ]; then
						return $NOT_SUCCESS
                    fi
					if [ "$TOOL_DBG" == "true" ]; then
						printf "$DEND" "$UTIL_LOWSWAP" "$FUNC" "Done"
					fi
                    return $SUCCESS
                fi
				if [ "$TOOL_DBG" == "true" ]; then
					MSG="Swap memory [ok]"
					printf "$DSTA" "$UTIL_LOWSWAP" "$FUNC" "$MSG"
					printf "$DEND" "$UTIL_LOWSWAP" "$FUNC" "Done"
				fi
                return $NOT_SUCCESS 
                ;;
            *) 
				MSG="Wrong argument"
				printf "$SEND" "$UTIL_LOWSWAP" "$MSG"
				return $NOT_SUCCESS 
                ;;
        esac
    fi
    __usage "$(declare -p LOWSWAP_USAGE)"
    return $NOT_SUCCESS
}

