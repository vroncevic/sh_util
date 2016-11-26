#!/bin/bash
#
# @brief   Display network traffic on an interface
# @version ver.1.0
# @date    Wen Oct 07 23:27:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_BYTETRAF=bytetraf
UTIL_BYTETRAF_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_BYTETRAF_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/devel.sh

declare -A BYTETRAF_USAGE=(
    ["TOOL"]="__$UTIL_BYTETRAF"
    ["ARG1"]="[TEST_STRUCTURE] Time and name of interface"
    ["EX-PRE"]="# Display network traffic on an interface"
    ["EX"]="__$UTIL_BYTETRAF \"enp0s25\""
)

#
# @brief  Counting bytes (received | transmited)
# @params Values required interface and direction
# @retval byte counts
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# local BYTE_COUNT=$(__byte_count $INTERFACE $OPTION)
#
function __byte_count() {
    local INTERFACE=$1
    local DIRECTION=$2
    if [ -n "$INTERFACE" ] && [ -n "$DIRECTION" ]; then
		local FUNC=${FUNCNAME[0]}
		local MSG=""
		if [ "$TOOL_DBG" == "true" ]; then
			MSG="Counting bytes from interface [$INTERFACE]"
			printf "$DSTA" "$UTIL_BYTETRAF" "$FUNC" "$MSG"
		fi
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
# @brief  Delimit some string
# @param  Value required some string text to delimit
# @retval None
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __string_intdelim SOME_STRING
#
function __string_intdelim() {
    local VAR_STRING2DELIM=\$"$1"
    local STRING2DELIM=`eval "expr \"$VAR_STRING2DELIM\" "`
    echo $1=$STRING2DELIM
    local DELIMITED=$(echo $STRING2DELIM | \
		sed '{ s/$/@/; : loop; s/\(...\)@/@.\1/; t loop; s/@//; s/^\.//; }')
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
# local interface="enp0s25"
# __interface_check "$interface"
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#   # true
#	# interface is up and running
# else
#   # false
#	# missing argument | interface isn't up
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __interface_check() {
    local INTERFACE=$1
    if [ -n "$INTERFACE" ]; then
		local FUNC=${FUNCNAME[0]}
		local MSG=""
		if [ "$TOOL_DBG" == "true" ]; then
			MSG="Checking interface [$INTERFACE]"
			printf "$DSTA" "$UTIL_BYTETRAF" "$FUNC" "$MSG"
		fi
        grep "$INTERFACE" /proc/net/dev &>/dev/null
        local STATUS=$?
        if [ "$STATUS" -ne "$SUCCESS" ]; then
			if [ "$TOOL_DBG" == "true" ]; then
				MSG="$INTERFACE is not up, can't find it in /proc/net/dev"
				printf "$DSTA" "$UTIL_BYTETRAF" "$FUNC" "$MSG"
			fi
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
# declare -A TEST_STRUCTURE=()
# TEST_STRUCTURE["TIME"]=$TIME
# TEST_STRUCTURE["INTERFACE"]=$INTERFACE
#
# __bytetraf "$(declare -p TEST_STRUCTURE)"
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#   # true
#	# interface is ok, you can see speed
# else
#   # false
#	# missing argument(s) | interface is down
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __bytetraf() {
	eval "declare -A TEST_STRUCTURE="${1#*=}
    local TIME=${TEST_STRUCTURE[TIME]}
    local INTERFACE=${TEST_STRUCTURE[INTERFACE]}
    if [ -n "$TIME" ] && [ -n "$INTERFACE" ]; then
		local FUNC=${FUNCNAME[0]}
		local MSG=""
		if [ "$TOOL_DBG" == "true" ]; then
			MSG="Display network traffic on an interface [$INTERFACE]"
			printf "$DSTA" "$UTIL_BYTETRAF" "$FUNC" "$MSG"
		fi
        case "$TIME" in
            +([0-9])[smhd] )
                __interface_check "$INTERFACE"
                local STATUS=$?
                if [ $STATUS -eq $SUCCESS ]; then
					local intg=${TIME%[s|m|h|d]*}
					local unit=${TIME##*[!s|m|h|d]}
					[[ $unit == s ]] && div=1
					[[ $unit == m ]] && div=60
					[[ $unit == h ]] && div=3600
					[[ $unit == d ]] && div=86400
					while grep "$INTERFACE" < /proc/net/dev &>/dev/null 
					do
						local received=$(__byte_count "$INTERFACE" r)
						local transmit=$(__byte_count "$INTERFACE" t)
						sleep $1
						local nreceived=$(__byte_count "$INTERFACE" r)
						local ntransmit=$(__byte_count "$INTERFACE" t)
						local rdiff=$((($nreceived - $received)))
						local tdiff=$((($ntransmit - $transmit)))
						local rate=$(((($rdiff + $tdiff)/( $div * $intg ))))
						__string_intdelim received
						__string_intdelim transmit
						printf "%s %s %s %s %s %s %s\n" \
								"$(date +%H:%M:%S)" \
								"int: $INTERFACE " \
								"recv: [+${rdiff}] $received " \
								"tran: [+${tdiff}] $transmit " \
								"rate: ${rate} b/s"
					done 
					if [ "$TOOL_DBG" == "true" ]; then
						printf "$DEND" "$UTIL_BYTETRAF" "$FUNC" "Done"
					fi
					return $SUCCESS
                fi
                ;;
            *) 
				MSG="Wrong argument [$TIME]"
				printf "$SSTA" "$UTIL_BYTETRAF" "$MSG"
                ;;
        esac
		return $NOT_SUCCESS
    fi
    __usage "$(declare -p BYTETRAF_USAGE)"
    return $NOT_SUCCESS
}

