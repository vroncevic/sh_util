#!/bin/bash
#
# @brief Testing point po point connection
# @version ver.1.0
# @date    Sun Oct 11 02:08:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
#
SUCCESS=0
NOT_SUCCESS=1

PROCNAME=pppd
INTERVAL=2

#
# @brief Testing point po point connection
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __onlineconnect
#
function __onlineconnect() {
    PID_NUMBER=$(ps ax | grep -v "ps ax" | grep -v grep | grep $PROCNAME | awk '{ print $1 }')
    if [ -z "$PID_NUMBER" ] && [ -n "$PID_NUMBER" ]; then
        printf "%s\n" "Not connected..."
        return $NOT_SUCCESS
    fi
    while [ true ]
    do
        if [ ! -e "/proc/$PID_NUMBER/$PROCFILENAME" ]; then
            printf "%s\n" "Disconnected..."
            return $NOT_SUCCESS
        fi
        netstat -s | grep "Packets received..."
        netstat -s | grep "Packets delivered..."
        sleep $INTERVAL
    done
    return $SUCCESS
}
