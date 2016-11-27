#!/bin/bash
#
# @brief   Calculate last working day of month in year
# @version ver.1.0
# @date    Mon Jul 15 21:44:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_CALUTILS=calutils
UTIL_CALUTILS_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_CALUTILS_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/devel.sh
. $UTIL/bin/usage.sh

declare -A CALUTILS_USAGE=(
    [USAGE_TOOL]="__$UTIL_CALUTILS"
    [USAGE_ARG1]="[CALENDAR_STRUCTURE] Target month and year"
    [USAGE_EX_PRE]="# Example geting last working day in May 1987"
    [USAGE_EX]="__$UTIL_CALUTILS \$CALENDAR_STRUCTURE"	
)

#
# @brief  Calculate last working day of month in year
# @param  Value required structure target month and Year
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# declare -A CALENDAR_STRUCTURE=(
# 	[MONTH]=$month
# 	[YEAR]=$year
# )
#
# __calutils CALENDAR_STRUCTURE
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#   # true
#	# print last working day of month in year
# else
#   # false
#	# missing argument | wrong argument
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __calutils() {
	local -n CALENDAR_STRUCTURE=$1
    local TARGET_MONTH=${CALENDAR_STRUCTURE[MONTH]}
    local TARGET_YEAR=${CALENDAR_STRUCTURE[YEAR]}
    if [ -n "$TARGET_MONTH"  ] && [ -n "$TARGET_YEAR" ]; then
		local FUNC=${FUNCNAME[0]}
		local MSG="None"
		if [ "$TOOL_DBG" == "true" ]; then
			MSG="Calculate last working day of month in year"
			printf "$DSTA" "$UTIL_CALUTILS" "$FUNC" "$MSG"
		fi
		local CALENDAR_CMD="cal $TARGET_MONTH $TARGET_YEAR"
		local EGREP_CMD="egrep  \"28|29|30|31\""
		local TAIL_CMD="tail -n 1"
		local AWK_CMD="awk 'BEGIN {
		var1=\$NF;var2=NF;
        }
        {
            if (NF > 1 &&  NF < 7)
                val=\$NF;
            else if (NF == 1)
                val=\$NF-2;
            else if (NF == 7)
                val=\$NF-1;
        }
        {
            print \"Last Working Date is : \" val;
        }'"
        eval "$CALENDAR_CMD | $EGREP_CMD | $TAIL_CMD | $AWK_CMD"
		if [ "$TOOL_DBG" == "true" ]; then
			printf "$DEND" "$UTIL_CALUTILS" "$FUNC" "Done"
		fi
        return $SUCCESS
    fi
    __usage CALUTILS_USAGE
    return $NOT_SUCCESS
}

