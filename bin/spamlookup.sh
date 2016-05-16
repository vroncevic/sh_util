#!/bin/bash
#
# @brief   Look up abuse contact to report a spammer
# @version ver.1.0
# @date    Mon Oct 12 22:11:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_NAME=spamlookup
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/devel.sh

declare -A TOOL_USAGE=(
    [TOOL_NAME]="__$UTIL_NAME"
    [ARG1]="[DOMAIN_NAME] Domain name"
    [EX-PRE]="# Example check www.domain.cc"
    [EX]="__$UTIL_NAME www.domain.cc"	
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
# STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
# else
#   # false
# fi
#
function __spamlookup() {
    DOMAIN_NAME=$1
    if [ -n "$DOMAIN_NAME" ]; then
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n" "[Look up abuse contact to report a spammer]"
		fi
        dig +short $DOMAIN_NAME.contacts.abuse.net -c in -t txt
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n\n" "[Done]"
		fi
        return $SUCCESS
    fi
    __usage $TOOL_USAGE
    return $NOT_SUCCESS
}

