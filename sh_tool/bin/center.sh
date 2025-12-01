#!/bin/bash
#
# @brief   Center logo on console
# @version ver.1.0
# @date    Mon Dec  1 05:21:16 PM CET 2025
# @company None, free software to use 2025
# @author  Vladimir Roncevic <elektron.ronca@gmail.com>
#
UTIL_CENTER=center
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh_util/${UTIL_VERSION}
UTIL_LOG=${UTIL}/log

.    ${UTIL}/bin/devel.sh
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
# @retval None
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
    tabs 4
    local ADDITIONAL_SHIFTER=${1}
    if [ -n "${ADDITIONAL_SHIFTER}" ]; then
        local CONSOLE_WIDTH=$(stty size 2>/dev/null | awk '{print $2}')
        if [ -z "${CONSOLE_WIDTH}" ] || [ "${CONSOLE_WIDTH}" -eq 0 ]; then
            CONSOLE_WIDTH=80
        fi
        local START_POSITION=$((${CONSOLE_WIDTH} / 2 - 21))
        local NUMBER_OF_TABS=$((
            ${START_POSITION} / 4 - 1 + ${ADDITIONAL_SHIFTER}
        ))
        if [ "${NUMBER_OF_TABS}" -lt 0 ]; then
            NUMBER_OF_TABS=0
        fi
        local TAB="$(printf '\011')"
        for ((I = 0; I <= ${NUMBER_OF_TABS}; I++))
        do
            printf "${TAB}"
        done
        return $SUCCESS
    fi
    usage CENTER_USAGE
    return $NOT_SUCCESS
}
