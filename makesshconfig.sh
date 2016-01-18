#!/bin/bash
#
# @brief   Generate Client SSH config file at
#          /home/<username>/.ssh/config
# @version ver.1.0
# @date    Mon Jun 07 21:12:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
TOOL_NAME=makesshconfig
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
    [ARG1]="[USERNAME]   System username"
    [ARG2]="[DEPARTMENT] System group"
    [EX-PRE]="# Generate SSH configuration"
    [EX]="__$TOOL_NAME rmuller users"	
)

declare -A LOG=(
    [TOOL]="$TOOL_NAME"
    [FLAG]="error"
    [PATH]="$TOOL_LOG"
    [MSG]=""
)

#
# @brief Generating SSH client config file at home dir
# @params Values required username and department
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __makesshconfig rmuller users
# STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#	# true
# else
#	# false
# fi
#
function __makesshconfig() {
    USERNAME=$1
    DEPARTMENT=$2
    if [ -n "$USERNAME" ] && [ -n "$DEPARTMENT" ]; then 
        printf "%s" "Checking dir /home/$USERNAME/.ssh/ "
        if [ ! -d "/home/$USERNAME/.ssh/" ]; then
            printf "%s\n" "[not ok]"
            printf "%s\n" "Create SSH configuration directory..."
            mkdir "/home/$USERNAME/.ssh/"
        else
            printf "%s\n" "[ok]"
        fi
        printf "%s\n" "Generating SSH config file [/home/$USERNAME/.ssh/config]"
        cat<<EOF>>"/home/$USERNAME/.ssh/config"
#
# SSH session to server1_suse, server2_centos and server3_debian
#

Host srvos
    HostName server1_suse
    Port 1234
    User $USERNAME
 
Host srvce
    HostName server2_centos
    Port 1235
    User $USERNAME

Host srvde
    HostName server3_debian
    Port 1236
    User $USERNAME
    
EOF
        printf "%s\n" "Set owner..."
        chown -R "$USERNAME.$DEPARTMENT" "/home/$USERNAME/.ssh/"
        printf "%s\n" "Set permissions..."
        chmod -R 700 "/home/$USERNAME/.ssh/"
        printf "%s\n" "Done..."
        return $SUCCESS
    fi 
    __usage $TOOL_USAGE
    LOG[MSG]="Missing argument"
    __logging $LOG
    return $NOT_SUCCESS
}
