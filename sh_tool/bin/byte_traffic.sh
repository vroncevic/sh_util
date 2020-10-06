#!/bin/bash
#
# @brief   Display network traffic on an interface
# @version ver.1.0.0
# @date    Wen Oct 07 23:27:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_BYTE_TRAFFIC=byte_traffic
UTIL_BYTE_TRAFFIC_VERSION=ver.1.0
UTIL=/root/scripts/sh_util/${UTIL_BYTE_TRAFFIC_VERSION}
UTIL_LOG=${UTIL}/log

.    ${UTIL}/bin/devel.sh
.    ${UTIL}/bin/usage.sh

declare -A BYTE_TRAFFIC_Usage=(
    [Usage_TOOL]="${UTIL_BYTE_TRAFFIC}"
    [Usage_ARG1]="[TEST_STRUCT] Time and name of interface"
    [Usage_EX_PRE]="# Display network traffic on an interface"
    [Usage_EX]="${UTIL_BYTE_TRAFFIC} \$TEST_STRUCT"
)

#
# @brief  Counting bytes (RECEIVED | transmited)
# @params Values required interface and direction
# @retval byte counts
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# local BYTE_COUNT=$(byte_count $INTER $OPTION)
#
function byte_count {
    local INTER=$1 DIREC=$2
    if [[ -n "${INTER}" && -n "${DIREC}" ]]; then
        local FUNC=${FUNCNAME[0]} MSG="None" LINE
        MSG="Counting bytes from interface [${INTER}]!"
        info_debug_message "$MSG" "$FUNC" "$UTIL_BYTE_TRAFFIC"
        while read LINE
        do
            if [[ $LINE == $INTER:* ]]; then
                [[ $DIREC == r ]] && { set -- ${LINE#*:}; echo $1; }
                [[ $DIREC == t ]] && { set -- ${LINE#*:}; echo $9; }
            fi
        done < /proc/net/dev
    fi
    MSG="Force exit!"
    info_debug_message_end "$MSG" "$FUNC" "$UTIL_BYTE_TRAFFIC"
}

#
# @brief  Delimit some string
# @param  Value required some string text to delimit
# @retval None
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# string_intdelim SOME_STRING
#
function string_intdelim {
    local VAR_STRING2DELIM=\$"$1"
    local STRING2DELIM=`eval "expr \"${VAR_STRING2DELIM}\" "`
    echo $1=${STRING2DELIM}
    local DELIMITED=$(echo ${STRING2DELIM} | \
        sed '{ s/$/@/; : loop; s/\(...\)@/@.\1/; t loop; s/@//; s/^\.//; }')
    eval "$1=\"${DELIMITED}\""
}

#
# @brief  Checking interface
# @param  Value required interface name
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# local interface="enp0s25"
# interface_check "$interface"
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#    # true
#    # interface is up and running
# else
#    # false
#    # missing argument | interface isn't up
#    # return $NOT_SUCCESS
#    # or
#    # exit 128
# fi
#
function interface_check {
    local INTER=$1
    if [ -n "${INTER}" ]; then
        local FUNC=${FUNCNAME[0]} MSG="None" STATUS
        MSG="Checking interface [$INTER]!"
        info_debug_message "$MSG" "$FUNC" "$UTIL_BYTE_TRAFFIC"
        grep "${INTER}" /proc/net/dev &>/dev/null
        STATUS=$?
        if [ $STATUS -ne $SUCCESS ]; then
            MSG="${INTER} is not up, can't find it in /proc/net/dev!"
            info_debug_message "$MSG" "$FUNC" "$UTIL_BYTE_TRAFFIC"
            MSG="Force exit!"
            info_debug_message_end "$MSG" "$FUNC" "$UTIL_BYTE_TRAFFIC"
            return $NOT_SUCCESS
        fi
        info_debug_message_end "Done" "$FUNC" "$UTIL_BYTE_TRAFFIC"
        return $SUCCESS
    fi
    MSG="Force exit!"
    info_debug_message_end "$MSG" "$FUNC" "$UTIL_BYTE_TRAFFIC"
    return $NOT_SUCCESS
}

#
# @brief  Show short statistics of some interface
# @params Values required time and interface
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# declare -A TEST_STRUCT=(
#    [TIME]=$TIME
#    [INTER]=$INTER
# )
#
# byte_traffic TEST_STRUCT
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#    # true
#    # interface is ok, you can see speed
# else
#    # false
#    # missing argument(s) | interface is down
#    # return $NOT_SUCCESS
#    # or
#    # exit 128
# fi
#
function byte_traffic {
    local -n TEST_STRUCT=$1
    local TIME=${TEST_STRUCT[TIME]} INTER=${TEST_STRUCT[INTER]}
    if [[ -n "${TIME}" && -n "${INTER}" ]]; then
        local FUNC=${FUNCNAME[0]} MSG="None" STATUS
        MSG="Display network traffic on an interface [${INTER}]!"
        info_debug_message "$MSG" "$FUNC" "$UTIL_BYTE_TRAFFIC"
        case "${TIME}" in
            ^[0-9]+[smhd]$)
                interface_check "${INTER}"
                STATUS=$?
                if [ $STATUS -eq $SUCCESS ]; then
                    local INTG=${TIME%[s|m|h|d]*} UNIT=${TIME##*[!s|m|h|d]} DIV
                    [[ ${UNIT} == s ]] && DIV=1
                    [[ ${UNIT} == m ]] && DIV=60
                    [[ ${UNIT} == h ]] && DIV=3600
                    [[ ${UNIT} == d ]] && DIV=86400
                    while grep "${INTER}" < /proc/net/dev &>/dev/null
                    do
                        local RECEIVED=$(byte_count "${INTER}" r) RATE
                        local TRANSMIT=$(byte_count "${INTER}" t)
                        sleep ${TIME}
                        local NRECEIVED=$(byte_count "${INTER}" r)
                        local NTRANSMIT=$(byte_count "${INTER}" t)
                        local RDIFF=$(((${NRECEIVED} - ${RECEIVED})))
                        local TDIFF=$(((${NTRANSMIT} - ${TRANSMIT})))
                        RATE=$((((${RDIFF} + ${TDIFF})/(${DIV} * ${INTG}))))
                        string_intdelim RECEIVED
                        string_intdelim TRANSMIT
                        printf "%s %s %s %s %s %s %s\n" \
                                "$(date +%H:%M:%S)" \
                                "int: ${INTER} " \
                                "recv: [+${RDIFF}] ${RECEIVED} " \
                                "tran: [+${TDIFF}] ${TRANSMIT} " \
                                "RATE: ${RATE} b/s"
                    done
                    info_debug_message_end "Done" "$FUNC" "$UTIL_BYTE_TRAFFIC"
                    return $SUCCESS
                fi
                ;;
            *)
                MSG="Wrong argument [${TIME}]!"
                info_debug_message "$MSG" "$FUNC" "$UTIL_BYTE_TRAFFIC"
                ;;
        esac
        MSG="Force exit!"
        info_debug_message_end "$MSG" "$FUNC" "$UTIL_BYTE_TRAFFIC"
        return $NOT_SUCCESS
    fi
    usage BYTE_TRAFFIC_Usage
    return $NOT_SUCCESS
}

