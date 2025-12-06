#!/bin/bash
#
# @brief   Converts DD/MM/YYYY date format to ISO-8601 (YYYY-MM-DD)
# @version ver.1.0
# @date    Mon Jul 15 21:44:32 2015
# @company None, free software to use 2015
# @author  Vladimir Roncevic <elektron.ronca@gmail.com>
#
if [ -z "$__SH_UTIL_DATE_TO_ISO8601" ]; then
    readonly __SH_UTIL_DATE_TO_ISO8601=1

    UTIL_DATE_TO_ISO8601=date_to_iso8601
    UTIL_DATE_TO_ISO8601_VERSION=ver.1.0
    UTIL=/root/scripts/sh_util/${UTIL_DATE_TO_ISO8601_VERSION}
    UTIL_LOG=${UTIL}/log

    .    ${UTIL}/bin/usage.sh

    declare -A DATE_TO_ISO8601_USAGE=(
        [USAGE_TOOL]="${UTIL_DATE_TO_ISO8601}"
        [USAGE_ARG1]="[TOOL] Name of App/Tool/Script"
        [USAGE_EX_PRE]="# Converting time to iso8601"
        [USAGE_EX]="${UTIL_DATE_TO_ISO8601} \"tester.log\""
    )
    #
    # @brief  Converts DD/MM/YYYY date format to ISO-8601 (YYYY-MM-DD)
    # @param  Value required file name 
    # @retval Success return 0, else return 1
    #
    # @usage
    # @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    #
    # local FILE="/home/vroncevic/Documents/meeting_date.txt" STATUS
    # date_to_iso8601 "$FILE"
    # STATUS=$?
    #
    # if [ $STATUS -eq $SUCCESS ]; then
    #    # true
    #    # notify admin | user
    # else
    #    # false
    #    # missing argument
    #    # return $NOT_SUCCESS
    #    # or
    #    # exit 128
    # fi
    #
    function date_to_iso8601 {
        local FILE=$1
        if [ -z "${FILE}" ]; then
            usage DATE_TO_ISO8601_USAGE
            return $NOT_SUCCESS
        fi
        local FUNC=${FUNCNAME[0]} MSG="None"
        MSG="Converts DD/MM/YYYY date format to ISO-8601 (YYYY-MM-DD)!"
        info_debug_message "$MSG" "$FUNC" "$UTIL_DATE_TO_ISO8601"
        local EX='s_\([0-9]\{1,2\}\)/\([0-9]\{1,2\}\)/\([0-9]\{4\}\)_\3-\2-\1_g'
        sed ${EX} ${FILE}
        info_debug_message_end "Done" "$FUNC" "$UTIL_DATE_TO_ISO8601"
        return $SUCCESS
    }
fi
