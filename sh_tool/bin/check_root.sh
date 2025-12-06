#!/bin/bash
#
# @brief   Check root permission from parent module
# @version ver.1.0
# @date    Mon Jun 01 18:36:32 2015
# @company None, free software to use 2015
# @author  Vladimir Roncevic <elektron.ronca@gmail.com>
#
if [ -z "$__SH_UTIL_CHECK_ROOT" ]; then
    readonly __SH_UTIL_CHECK_ROOT=1

    UTIL_CHECK_ROOT=check_root
    UTIL_CHECK_ROOT_VERSION=ver.1.0
    UTIL=/root/scripts/sh_util/${UTIL_CHECK_ROOT_VERSION}
    UTIL_LOG=${UTIL}/log

    .    ${UTIL}/bin/devel.sh

    # 
    # @brief  Check root permission from parent module
    # @param  None
    # @retval Success return 0, else return 1
    #
    # @usage
    # @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    #
    # check_root
    # local STATUS=$?
    #
    # if [ $STATUS -eq $SUCCESS ]; then
    #    # true
    #    # notify admin | user
    # else
    #    # false
    #    # you don't have root permission
    #    # return $NOT_SUCCESS
    #    # or
    #    # exit 127
    # fi
    #
    function check_root {
        local FUNC=${FUNCNAME[0]} MSG="None"
        MSG="Check permission for current session?"
        info_debug_message_que "$MSG" "$FUNC" "$UTIL_CHECK_ROOT"
        if [ "$(id -u)" != "0" ] || [ ${EUID} -ne $SUCCESS ]; then
            MSG="[not ok]"
            info_debug_message_ans "$MSG" "$FUNC" "$UTIL_CHECK_ROOT"
            MSG="Run App/Tool/Script as [root] user!"
            info_debug_message "$MSG" "$FUNC" "$UTIL_CHECK_ROOT"
            MSG="Force exit!"
            info_debug_message_end "$MSG" "$FUNC" "$UTIL_CHECK_ROOT"
            return $NOT_SUCCESS
        fi
        MSG="[ok]"
        info_debug_message_ans "$MSG" "$FUNC" "$UTIL_CHECK_ROOT"
        info_debug_message_end "Done" "$FUNC" "$UTIL_CHECK_ROOT"
        return $SUCCESS
    }
fi
