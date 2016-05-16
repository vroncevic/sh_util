#!/bin/bash
#
# @brief   Display network traffic on an interface
# @version ver.1.0
# @date    Wen Oct 07 23:27:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_NAME=bytetraf
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/logging.sh
. $UTIL/bin/devel.sh

declare -A TOOL_USAGE=(
    [TOOL_NAME]="__$UTIL_NAME"
    [ARG1]="[TEST_STRUCTURE] Time and name of interface"
    [EX-PRE]="# Display network traffic on an interface"
    [EX]="__$UTIL_NAME \"enp0s25\""	
)

declare -A LOG=(
    [TOOL]="$UTIL_NAME"
    [FLAG]="error"
    [PATH]="$UTIL_LOG"
    [MSG]=""
)

#
# @brief  Counting bytes (received | transmited)
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
# @param Value required some string text to delimit
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
# @brief  Checking interface
# @param  Value required interface name
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __interface_check "enp0s25"
# STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
# else
#   # false
# fi
#
function __interface_check() {
    INTERFACE=$1
    if [ -n "$INTERFACE" ]; then
        grep "$INTERFACE" /proc/net/dev &>/dev/null
        STATUS=$?
        if [ "$STATUS" -ne "$SUCCESS" ]; then
            printf "%s\n" "$INTERFACE is not up, can't find it in /proc/net/dev ..."
            return $NOT_SUCCESS
        fi
        return $SUCCESS
    fi
    return $NOT_SUCCESS
}

#
# @brief  Show short statistics of some interface
# @params Values required time and interface
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __bytetraf $TIME $INTERFACE
# STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
# else
#   # false
# fi
#
function __bytetraf() {
	TEST_STRUCTURE=$1
    TIME=${TEST_STRUCTURE[TIME]}
    INTERFACE=${TEST_STRUCTURE[INTERFACE]}
    if [ -n "$TIME" ] && [ -n "$INTERFACE" ]; then
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n" "[Display network traffic on an interface]"
		fi
        case "$TIME" in
            +([0-9])[smhd] )
                __interface_check "$INTERFACE"
                intg=${TIME%[s|m|h|d]*}
                unit=${TIME##*[!s|m|h|d]}
                [[ $unit == s ]] && div=1
                [[ $unit == m ]] && div=60
                [[ $unit == h ]] && div=3600
                [[ $unit == d ]] && div=86400
                while grep "$INTERFACE" < /proc/net/dev &>/dev/null 
                do
                    received=$(__byte_count "$INTERFACE" r)
                    transmit=$(__byte_count "$INTERFACE" t)
                    sleep $1
                    nreceived=$(__byte_count "$INTERFACE" r)
                    ntransmit=$(__byte_count "$INTERFACE" t)
                    rdiff=$((($nreceived - $received)))
                    tdiff=$((($ntransmit - $transmit)))
                    rate=$(((($rdiff + $tdiff)/( $div * $intg ))))
                    __string_intdelim received
                    __string_intdelim transmit
                    printf "%s %s %s %s %s %s %s\n" "$(date +%H:%M:%S) int: $INTERFACE recv: [+${rdiff}] $received tran: [+${tdiff}] $transmit rate: ${rate} b/s"
                done 
                ;;
            *) 
                LOG[MSG]="Wrong argument"
				if [ "$TOOL_DEBUG" == "true" ]; then
					printf "%s\n" "[Error] ${LOG[MSG]}"
				fi
                __logging $LOG
                return $NOT_SUCCESS
                ;;
        esac
        printf "%s\n\n" "[Done]"
        return $SUCCESS
    fi
    __usage $TOOL_USAGE
    return $NOT_SUCCESS
}

