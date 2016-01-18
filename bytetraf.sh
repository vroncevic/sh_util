#!/bin/bash
#
# @brief   Display network traffic on an interface
# @version ver.1.0
# @date    Wen Oct 07 23:27:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
TOOL_NAME=bytetraf
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
    [ARG1]="[INTERFACE_NAME] Name of interface"
    [EX-PRE]="# Display network traffic on an interface"
    [EX]="__$TOOL_NAME \"enp0s25\""	
)

declare -A LOG=(
    [TOOL]="$TOOL_NAME"
    [FLAG]="error"
    [PATH]="$TOOL_LOG"
    [MSG]=""
)

#
# @brief Counting bytes (received | transmited)
# @params Values required interface and direction
# @retval byte counts
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# BYTE_COUNT=$(__byte_count $INTERFACE $OPTION)
#
function __byte_count() {
    INTERFACE=$1
    DIRECTION=$2
    if [ -n "$INTERFACE" ] && [ -n "$DIRECTION" ]; then
        while read line
        do
            if [[ $line == $INTERFACE:* ]];then
                [[ $DIRECTION == r ]] && { set -- ${line#*:}; echo $1; }
                [[ $DIRECTION == t ]] && { set -- ${line#*:}; echo $9; }
            fi
        done < /proc/net/dev
    fi
}

#
# @brief Delimit some string
# @argument Value required some string text to delimit
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __string_intdelim SOME_STRING
#
function __string_intdelim() {
    VAR_STRING2DELIM=\$"$1"
    STRING2DELIM=`eval "expr \"$VAR_STRING2DELIM\" "`
    echo $1=$STRING2DELIM
    DELIMITED=$(echo $STRING2DELIM | sed '{ s/$/@/; : loop; s/\(...\)@/@.\1/; t loop; s/@//; s/^\.//; }')
    eval "$1=\"$DELIMITED\""
}

#
# @brief Checking interface
# @argument Value required interface name
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __interface_check "enp0s25"
# STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#	# true
# else
#	# false
# fi
#
function __interface_check() {
    INTERFACE=$1
    if [ -n "$INTERFACE" ]; then
        grep $interface /proc/net/dev &>/dev/null
        INTERFACE_STATUS=$?
        if [ $INTERFACE_STATUS -ne $SUCCESS ]; then
            printf "%s\n" "$INTERFACE is not up, cant find it in /proc/net/dev ..."
            return $NOT_SUCCESS
        fi
        return $SUCCESS
    fi
    return $NOT_SUCCESS
}

#
# @brief Show short statistics of some interface
# @params Values required time and interface
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __bytetraf $TIME $INTERFACE
# STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#	# true
# else
#	# false
# fi
#
function __bytetraf() {
    TIME=$1
    INTERFACE=$2
    if [ -n "$TIME" ] && [ -n "$INTERFACE" ]; then
        case $TIME in
            +([0-9])[smhd] )
                            __interface_check $INTERFACE
                            intg=${TIME%[s|m|h|d]*}
                            unit=${TIME##*[!s|m|h|d]}
                            [[ $unit == s ]] && div=1
                            [[ $unit == m ]] && div=60
                            [[ $unit == h ]] && div=3600
                            [[ $unit == d ]] && div=86400
                            while grep $INTERFACE < /proc/net/dev &>/dev/null 
                            do
                                received=$(__byte_count r)
                                transmit=$(__byte_count t)
                                sleep $1
                                nreceived=$(__byte_count r)
                                ntransmit=$(__byte_count t)
                                rdiff=$((($nreceived - $received)))
                                tdiff=$((($ntransmit - $transmit)))
                                rate=$(((($rdiff + $tdiff)/( $div * $intg ))))
                                __string_intdelim received
                                __string_intdelim transmit
                                printf "%s %s %s %s %s %s %s\n" "$(date +%H:%M:%S) int: $INTERFACE recv: [+${rdiff}] $received tran: [+${tdiff}] $transmit rate: ${rate} b/s"
                            done 
                            ;;
            *) 
                            __usage $TOOL_USAGE
                            LOG[MSG]="Wrong argument"
                            __logging $LOG
                            return $NOT_SUCCESS
                            ;;
        esac
        printf "%s\n" "Done..."
        return $SUCCESS
    fi
    __usage $TOOL_USAGE
    LOG[MSG]="Missing argument"
    __logging $LOG
    return $NOT_SUCCESS
}
