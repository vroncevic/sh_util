#!/bin/bash
#
# @brief   List files of same size in current dir
# @version ver.1.0
# @date    Fri Oct 02 09:59:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_SAME_SIZE=same_size
UTIL_SAME_SIZE_VERSION=ver.1.0
UTIL=/root/scripts/sh_util/${UTIL_SAME_SIZE_VERSION}
UTIL_LOG=${UTIL}/log

.    ${UTIL}/bin/devel.sh
.    ${UTIL}/bin/usage.sh

declare -A SAME_SIZE_Usage=(
    [USAGE_TOOL]="${UTIL_SAME_SIZE}"
    [USAGE_ARG1]="[DIR] Directory path"
    [USAGE_EX_PRE]="# List files of same size in dir"
    [USAGE_EX]="${UTIL_SAME_SIZE} /data/"
)

#
# @brief  List files of same size in current dir
# @param  Value required path to directory
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# same_size $DIR
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#    # true
#    # notify admin | user
# else
#    # false
#    # missing argument | missing dir
#    # return $NOT_SUCCESS
#    # or
#    # exit 128
# fi
#
function same_size {
    local DIR=$1
    if [ -n "${DIR}" ]; then
        local FUNC=${FUNCNAME[0]} MSG="None" A
        MSG="Check directory [${DIR}/]?"
        info_debug_message "$MSG" "$FUNC" "$UTIL_SAME_SIZE"
        if [ -d "${DIR}" ]; then
            MSG="[ok]"
            info_debug_message_ans "$MSG" "$FUNC" "$UTIL_SAME_SIZE"
            local TMP1=/tmp/tmp.${RANDOM}$$
            trap 'rm -f $TMP1 >/dev/null 2>&1' 0
            trap "exit 2" 1 2 3 15
            for A in ${DIR}/*
            do
                local FSIZE=$(set -- $(ls -l -- "${A}"); echo $5)
                local MDEP="-maxdepth 1" TYPE="-type f !" SIZE="-size ${FSIZE}"
                eval "find . ${MDEP} ${TYPE} -name ${A} ${SIZE} > ${TMP1}"
                [ -s ${TMP1} ] && {
                    echo "File with same size as file \"${A}\": ";
                    cat ${TMP1};
                }
            done
            info_debug_message_end "Done" "$FUNC" "$UTIL_SAME_SIZE"
            return $SUCCESS
        fi
        MSG="[not ok]"
        info_debug_message_ans "$MSG" "$FUNC" "$UTIL_SAME_SIZE"
        MSG="Please check directory [${DIR}/]!"
        info_debug_message "$MSG" "$FUNC" "$UTIL_SAME_SIZE"
        MSG="Force exit!"
        info_debug_message_end "$MSG" "$FUNC" "$UTIL_SAME_SIZE"
        return $NOT_SUCCESS
    fi
    usage SAME_SIZE_Usage
    return $NOT_SUCCESS
}

