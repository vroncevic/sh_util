#!/bin/bash
#
# @brief   Show 10 Largest Open Files
# @version ver.1.0
# @date    Mon Jul 15 21:44:32 2015
# @company None, free software to use 2015
# @author  Vladimir Roncevic <elektron.ronca@gmail.com>
#
if [ -z "$__SH_UTIL_SLOF" ]; then
    readonly __SH_UTIL_SLOF=1

    UTIL_SLOF=slof
    UTIL_SLOF_VERSION=ver.1.0
    UTIL=/root/scripts/sh_util/${UTIL_SLOF_VERSION}
    UTIL_LOG=${UTIL}/log

    .    ${UTIL}/bin/usage.sh

    declare -A SLOF_USAGE=(
        [USAGE_TOOL]="${UTIL_SLOF}"
        [USAGE_ARG1]="[SIZE] LIst in GB/MB"
        [USAGE_EX_PRE]="# Show 10 Largest Open Files in GB"
        [USAGE_EX]="${UTIL_SLOF} large"
    )

    #
    # @brief  Show 10 Largest Open Files
    # @param  Value required size in GB or MB
    # @retval Success return 0, else return 1
    #
    # @usage
    # @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    #
    # slof 10
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
    function slof {
        local SIZE=$1
        if [ -z "${SIZE}" ]; then
            usage SLOF_USAGE
            return $NOT_SUCCESS
        fi
        local FUNC=${FUNCNAME[0]} MSG="None" AWK_CMD_G AWK_CMD_M
        MSG="Show 10 Largest Open Files!"
        info_debug_message "$MSG" "$FUNC" "$UTIL_SLOF"
        AWK_CMD_G='{if($7 > 1048576) print $7/1048576 "GB" " " $9 " " $1}'
        AWK_CMD_M='{if($7 > 1048576) print $7/1048576 "MB" " " $9 " " $1}'
        if [ "${SIZE}" == "large" ]; then
            eval "lsof / | awk '${AWK_CMD_G}' | sort -n -u | tail"
        else
            eval "lsof / | awk '${AWK_CMD_M}' | sort -n -u | tail"
        fi
        info_debug_message_end "Done" "$FUNC" "$UTIL_SLOF"
        return $SUCCESS
    }
fi
