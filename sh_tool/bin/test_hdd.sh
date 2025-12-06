#!/bin/bash
#
# @brief   Test hard drive speed
# @version ver.1.0
# @date    Thu Mar 03 15:06:32 2016
# @company Frobas IT Department, www.frobas.com 2016
# @author  Vladimir Roncevic <elektron.ronca@gmail.com>
#
if [ -z "$__SH_UTIL_TEST_HDD" ]; then
    readonly __SH_UTIL_TEST_HDD=1

    UTIL_TEST_HDD=test_hdd
    UTIL_TEST_HDD_VERSION=ver.1.0
    UTIL=/root/scripts/sh_util/${UTIL_TEST_HDD_VERSION}
    UTIL_LOG=${UTIL}/log

    .    ${UTIL}/bin/usage.sh

    declare -A TEST_HDD_USAGE=(
        [USAGE_TOOL]="${UTIL_TEST_HDD}"
        [USAGE_ARG1]="[TIME_COUNT] Time count"
        [USAGE_EX_PRE]="# Creating zerofile and test hdd"
        [USAGE_EX]="${UTIL_TEST_HDD} 500"
    )

    #
    # @brief  Test hard drive speed
    # @param  Value required time count
    # @retval Success return 0, else return 1
    # @usage
    # @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    #
    # test_hdd $TIME_COUNT
    # local STATUS=$?
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
    function test_hdd {
        local TIME_COUNT=$1
        if [ -z "${TIME_COUNT}" ]; then
            usage TEST_HDD_USAGE
            return $NOT_SUCCESS
        fi
        local FUNC=${FUNCNAME[0]} MSG="None"
        MSG="Testing hard drive speed!"
        info_debug_message "$MSG" "$FUNC" "$UTIL_TEST_HDD"
        time (dd if=/dev/zero of=zerofile bs=1M count=${TIME_COUNT};sync);
        rm zerofile
        info_debug_message_end "Done" "$FUNC" "$UTIL_TEST_HDD"
        return $SUCCESS
    }
fi
