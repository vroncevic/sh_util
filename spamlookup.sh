#!/bin/bash
#
# @brief   Look up abuse contact to report a spammer
# @version ver.1.0
# @date    Mon Oct 12 22:11:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
TOOL_NAME=spamlookup
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
    [ARG1]="[DOMAIN_NAME] Domain name"
    [EX-PRE]="# Example check www.google.com"
    [EX]="__$TOOL_NAME $DOMAIN_NAME"	
)

declare -A LOG=(
    [TOOL]="$TOOL_NAME"
    [FLAG]="error"
    [PATH]="$TOOL_LOG"
    [MSG]=""
)

#
# @brief Look up abuse contact to report a spammer
# @argument Value required domain name
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __spamlookup $DOMAIN_NAME
# STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#	# true
# else
#	# false
# fi
#
function __spamlookup() {
    DOMAIN_NAME=$1
    if [ -n "$DOMAIN_NAME" ]; then
        dig +short $DOMAIN_NAME.contacts.abuse.net -c in -t txt
        return $SUCCESS
    fi
    return $NOT_SUCCESS
}
