#!/bin/bash
#
# @brief   Print color text
# @version ver.1.0.0
# @date    Mon Nov 28 19:54:27 CET 2016
# @company None, free  software to use 2016
# @author  Vladimir Roncevic <elektron.ronca@gmail.com>
# 
UTIL_COL_PRINT=color_print
UTIL_COL_PRINT_VERSION=ver.1.0.0
UTIL=/root/scripts/sh_util/${UTIL_COL_PRINT_VERSION}
UTIL_COL_PRINT_CFG=${UTIL}/conf/${UTIL_COL_PRINT}.cfg
UTIL_LOG=${UTIL}/log

.    ${UTIL}/bin/devel.sh
.    ${UTIL}/bin/usage.sh

declare -A COL_PRINT_USAGE=(
    [USAGE_TOOL]="${UTIL_COL_PRINT}"
    [USAGE_ARG1]="[MSG] Message to text"
    [USAGE_ARG2]="[COL] Color for text"
    [USAGE_EX_PRE]="# Example printing color text"
    [USAGE_EX]="${UTIL_COL_PRINT} \$MSG \$BLUE"
)

BLACK='\E[30;47m'
RED='\E[31;47m'
GREEN='\E[32;47m'
YELLOW='\E[33;47m'
BLUE='\E[34;47m'
MAGENTA='\E[35;47m'
CYAN='\E[36;47m'
WHITE='\E[37;47m'
alias Reset="tput sgr0"

#
# @brief  Sending broadcast message
# @param  Value required broadcastmessage structure (message and note)
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# color_print "Feeling blue..." $BLUE
# local STATUS=$?
#
# color_print "Green with envy." $GREEN
# STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#    # true
#    # notify admin | user 
# else
#    # false
#    # missing argument(s)
#    # return $NOT_SUCCESS
#    # or
#    # exit 128
# fi
#
function color_print {
    local MSG2TXT=$1 COL2TXT=$2
    if [[ -n "${MSG2TXT}" && -n "${COL2TXT}" ]]; then
        local DEFMSG="No message passed." MSG COL
        MSG=${MSG2TXT:-${DEFMSG}}
        COL=${COL2TXT:-${BLACK}}
        echo -e "${COL}"
        echo "${MSG}"
        return $SUCCESS
    fi
    usage COL_PRINT_USAGE
    return $NOT_SUCCESS
}

