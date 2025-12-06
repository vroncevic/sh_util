#!/bin/bash
#
# @brief   Center logo on console
# @version ver.1.0
# @date    Mon Dec  1 05:21:16 PM CET 2025
# @company None, free software to use 2025
# @author  Vladimir Roncevic <elektron.ronca@gmail.com>
#
if [ -z "$__SH_UTIL_CENTER" ]; then
    readonly __SH_UTIL_CENTER=1

    UTIL_CENTER=center
    UTIL_VERSION=ver.1.0
    UTIL=/root/scripts/sh_util/${UTIL_VERSION}
    UTIL_LOG=${UTIL}/log

    .    ${UTIL}/bin/usage.sh

    declare -A CENTER_USAGE=(
        [USAGE_TOOL]="${UTIL_CENTER}"
        [USAGE_ARG1]="[ADDITIONAL_SHIFTER] An additional number of tabs to shift"
        [USAGE_EX_PRE]="# Example of centering logo in terminal"
        [USAGE_EX]="${UTIL_CENTER} 5"
    )

    #
    # @brief  Display logo centered in the terminal.
    # @param  ADDITIONAL_SHIFTER (int): An additional number of tabs to shift 
    #         the logo to the right. Use 0 for no additional shift.
    # @retval Success 0, else 1
    #
    # @usage
    # @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    #
    # center 0
    # local STATUS=$?
    #
    # if [ $STATUS -eq $SUCCESS ]; then
    #    # true
    #    # notify admin | user
    # else
    #    # false
    #    # missing additional shifter argument
    #    # return $NOT_SUCCESS
    #    # or
    #    # exit 128
    # fi
    #
    function center {
        local ADDITIONAL_SHIFTER=$1
        if [ -z "${ADDITIONAL_SHIFTER}" ]; then
            usage CENTER_USAGE
            return $NOT_SUCCESS
        fi
        local CONSOLE_WIDTH=$(tput cols 2>/dev/null)
        if [[ -z "${CONSOLE_WIDTH}" || "${CONSOLE_WIDTH}" -eq 0 ]]; then
            CONSOLE_WIDTH=80
        fi
        local SHIFTER=$((10#${ADDITIONAL_SHIFTER:-0}))
        local REFERENCE_LENGTH=42
        local PADDING_SPACES=$(( (CONSOLE_WIDTH - REFERENCE_LENGTH) / 2 + SHIFTER ))
        if [[ "${PADDING_SPACES}" -lt 0 ]]; then
            PADDING_SPACES=0
        fi
        printf "%*s" "${PADDING_SPACES}" ""
        return $SUCCESS
    }
fi
