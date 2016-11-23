#!/bin/bash
#
# @brief   Sending an email to admin
# @version ver.1.0
# @date    Mon Jul 15 20:57:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_SENDMAIL=sendmail
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/checktool.sh
. $UTIL/bin/devel.sh

declare -A SENDMAIL_USAGE=(
    [TOOL_NAME]="__$UTIL_SENDMAIL"
    [ARG1]="[MSG]         Email text body"
    [ARG2]="[EMAIL2ADMIN] Full email address"
    [EX-PRE]="# Example sending simple message"
    [EX]="__$UTIL_SENDMAIL \"test\" \"vladimir.roncevic@frobas.com\""	
)

#
# @brief  Send an email to admin
# @params Values required message and admin email address
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __sendemail "$MESSAGE" "$ADMIN_EMAIL"
# local STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
#	# notify admin | user
# else
#   # false
#	# missing argument | missing tool 
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __sendmail() {
    local MESSAGE=$1
    local ADMIN_EMAIL=$2
    if [ -n "$MESSAGE" ] && [ -n "$ADMIN_EMAIL" ]; then
		local FUNC=${FUNCNAME[0]}
		local MSG=""
		local SENDMAIL="/usr/sbin/sendmail"
		if [ "$TOOL_DBG" == "true" ]; then
        	MSG="Send an email to admin"
        	printf "$DSTA" "$UTIL_SENDMAIL" "$FUNC" "$MSG"
		fi
        __checktool "$SENDMAIL"
        local STATUS=$?
        if [ "$STATUS" -eq "$SUCCESS" ]; then
			local HOST=$(hostname)
            cat <<EOF | sendmail -t
To: $ADMIN_EMAIL
Subject: [IT $UTIL_FROM_COMPANY] root@$HOST
From: root@$HOST

$MESSAGE
EOF
			if [ "$TOOL_DBG" == "true" ]; then            
				printf "$DSTA" "$UTIL_SENDMAIL" "$FUNC" "Email sent"
				printf "$DEND" "$UTIL_SENDMAIL" "$FUNC" "Done"
			fi
            return $SUCCESS
        fi 
        return $NOT_SUCCESS
    fi
    __usage $SENDMAIL_USAGE
    return $NOT_SUCCESS
}

