#!/bin/bash
#
# @brief   Calculate last working day of month in year
# @version ver.1.0
# @date    Mon Jul 15 21:44:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_CAL_UTILS=cal_utils
UTIL_CAL_UTILS_VERSION=ver.1.0
UTIL=/root/scripts/sh_util/${UTIL_CAL_UTILS_VERSION}
UTIL_LOG=${UTIL}/log

.    ${UTIL}/bin/devel.sh
.    ${UTIL}/bin/usage.sh

declare -A CAL_UTILS_USAGE=(
    [USAGE_TOOL]="${UTIL_CAL_UTILS}"
    [USAGE_ARG1]="[CAL_STRUCT] Target month and year"
    [USAGE_EX_PRE]="# Example geting last working day in May 1987"
    [USAGE_EX]="${UTIL_CAL_UTILS} \$CAL_STRUCT"
)

#
# @brief  Calculate last working day of month in year
# @param  Value required structure target month and Year
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# declare -A CAL_STRUCT=(
#    [MONTH]=$month
#    [YEAR]=$year
# )
#
# cal_utils CAL_STRUCT
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#    # true
#    # print last working day of month in year
# else
#    # false
#    # missing argument | wrong argument
#    # return $NOT_SUCCESS
#    # or
#    # exit 128
# fi
#
function cal_utils {
    local -n CAL_STRUCT=$1
    local MONTH=${CAL_STRUCT[MONTH]} YEAR=${CAL_STRUCT[YEAR]}
    if [[ -n "${MONTH}" && -n "${YEAR}" ]]; then
        local FUNC=${FUNCNAME[0]} MSG="None"
        MSG="Calculate last working day of month in year!"
        info_debug_message "$MSG" "$FUNC" "$UTIL_CAL_UTILS"
        local CALCMD="cal ${MONTH} ${YEAR}"
        local EGREPCMD="egrep  \"28|29|30|31\"" TAILCMD="tail -n 1"
        local AWKCMD="awk 'BEGIN {
        var1=\$NF;var2=NF;
        }
        {
            if (NF > 1 &&  NF < 7) val=\$NF;
            else if (NF == 1) val=\$NF-2;
            else if (NF == 7) val=\$NF-1;
        }
        {
            print \"Last Working Date is : \" val;
        }'"
        eval "${CALCMD} | ${EGREPCMD} | ${TAILCMD} | ${AWKCMD}"
        info_debug_message_end "Done" "$FUNC" "$UTIL_CAL_UTILS"
        return $SUCCESS
    fi
    usage CAL_UTILS_USAGE
    return $NOT_SUCCESS
}

