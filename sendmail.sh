#!/bin/bash
#
# @brief   Sending an email
# @version ver.1.0
# @date    Mon Jul 15 20:57:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
TOOL_NAME=sendmail
TOOL_VERSION=ver.1.0
TOOL_EXECUTABLE="${BASH_SOURCE[0]}"
TOOL_BIN=`dirname $TOOL_EXECUTABLE`
TOOL_HOME=`dirname $TOOL_BIN`
TOOL_LOG=$TOOL_HOME/log

. $TOOL_BIN/usage.sh
. $TOOL_BIN/logging.sh
. $TOOL_BIN/checktool.sh

SUCCESS=0
NOT_SUCCESS=1

declare -A TOOL_USAGE=(
    [TOOL_NAME]="__$TOOL_NAME"
    [ARG1]="[MSG]         Email text body"
    [ARG2]="[EMAIL2ADMIN] Full email address"
    [EX-PRE]="# Example sending simple message"
    [EX]="__$TOOL_NAME \"test\" \"vladimir.roncevic@frobas.com\""	
)

declare -A LOG=(
    [TOOL]="$TOOL_NAME"
    [FLAG]="error"
    [PATH]="$TOOL_LOG"
    [MSG]=""
)

#
# @brief Send email to admin
# @params Values required message and admin email address
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __sendemail $MESSAGE $ADMIN_EMAIL
# STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#	# true
# else
#	# false
# fi
#
function __sendmail() {
    MESSAGE=$1
    ADMIN_EMAIL=$2
    if [ -n "$MESSAGE" ] && [ -n "$ADMIN_EMAIL" ]; then
        __checktool "/usr/sbin/sendmail"
        CHECK_TOOL=$?
        printf "%s\n" "Sending email..."
        if [ $CHECK_TOOL -eq $SUCCESS ]; then
            cat <<EOF | sendmail -t
To: $ADMIN_EMAIL
Subject: [IT FROBAS NS] root@localhost
From: root@localhost

$MESSAGE
EOF
            printf "%s\n" "Email sent..."
            return $SUCCESS
        fi 
        return $NOT_SUCCESS
    fi
    __usage $TOOL_USAGE
    LOG[MSG]="Missing argument"
    __logging $LOG
    return $NOT_SUCCESS
}
