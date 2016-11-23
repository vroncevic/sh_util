#!/bin/bash
#
# @brief   Look up abuse contact to report a spammer
# @version ver.1.0
# @date    Mon Oct 12 22:11:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_SPAMLOOKUP=spamlookup
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/checktool.sh
. $UTIL/bin/devel.sh

declare -A SPAMLOOKUP_USAGE=(
    [TOOL_NAME]="__$UTIL_SPAMLOOKUP"
    [ARG1]="[DOMAIN_NAME] Domain name"
    [EX-PRE]="# Example check www.domain.cc"
    [EX]="__$UTIL_SPAMLOOKUP www.domain.cc"	
)

#
# @brief  Look up abuse contact to report a spammer
# @param  Value required domain name
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __spamlookup "$DOMAIN_NAME"
# local STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
#   # notify admin | user
# else
#   # false
#   # missing argument | missing tool
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __spamlookup() {
    local DOMAIN_NAME=$1
    if [ -n "$DOMAIN_NAME" ]; then
		local FUNC=${FUNCNAME[0]}
		local MSG=""
		local DIG="/usr/bin/dig"
		if [ "$TOOL_DBG" == "true" ]; then
			MSG="Look up abuse contact to report a spammer"
			printf "$DSTA" "$UTIL_SPAMLOOKUP" "$FUNC" "$MSG"
		fi
		__checktool "$DIG"
		local STATUS=$?
		if [ "$STATUS" -eq "$NOT_SUCCESS" ]; then
			return $NOT_SUCCESS
		fi
		eval "$DIG +short $DOMAIN_NAME.contacts.abuse.net -c in -t txt"
		if [ "$TOOL_DBG" == "true" ]; then
			printf "$DEND" "$UTIL_SPAMLOOKUP" "$FUNC" "Done"
		fi
        return $SUCCESS
    fi
    __usage $SPAMLOOKUP_USAGE
    return $NOT_SUCCESS
}

