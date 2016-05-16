#!/bin/bash
#
# @brief   Sending an email to admin
# @version ver.1.0
# @date    Mon Jul 15 20:57:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_NAME=sendmail
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/logging.sh
. $UTIL/bin/checktool.sh
. $UTIL/bin/devel.sh

declare -A TOOL_USAGE=(
    [TOOL_NAME]="__$UTIL_NAME"
    [ARG1]="[MSG]         Email text body"
    [ARG2]="[EMAIL2ADMIN] Full email address"
    [EX-PRE]="# Example sending simple message"
    [EX]="__$UTIL_NAME \"test\" \"vladimir.roncevic@frobas.com\""	
)

declare -A LOG=(
    [TOOL]="$UTIL_NAME"
    [FLAG]="error"
    [PATH]="$UTIL_LOG"
    [MSG]=""
)

HOST=$(hostname)

#
# @brief  Send an email to admin
# @params Values required message and admin email address
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __sendemail "$MESSAGE" "$ADMIN_EMAIL"
# STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
# else
#   # false
# fi
#
function __sendmail() {
    MESSAGE=$1
    ADMIN_EMAIL=$2
    if [ -n "$MESSAGE" ] && [ -n "$ADMIN_EMAIL" ]; then
		if [ "$TOOL_DEBUG" == "true" ]; then
        	printf "%s\n" "[Send an email to admin]"
		fi
        __checktool "/usr/sbin/sendmail"
        STATUS=$?
        if [ "$STATUS" -eq "$SUCCESS" ]; then
            cat <<EOF | sendmail -t
To: $ADMIN_EMAIL
Subject: [CHECK] root@$HOST
From: root@$HOST

$MESSAGE
EOF
			if [ "$TOOL_DEBUG" == "true" ]; then            
				printf "%s\n" "Email sent"
				printf "%s\n\n" "[Done]"
			fi
            return $SUCCESS
        fi 
        LOG[MSG]="Check tool sendmail"
		if [ "$TOOL_DEBUG" == "true" ]; then
        	printf "%s\n" "[Error] ${LOG[MSG]}"
		fi
        __logging $LOG
        return $NOT_SUCCESS
    fi
    __usage $TOOL_USAGE
    return $NOT_SUCCESS
}

