#!/bin/bash
#
# @brief   Calculate last working day of month in year
# @version ver.1.0
# @date    Mon Jul 15 21:44:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_NAME=calutils
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/devel.sh

declare -A TOOL_USAGE=(
    [TOOL_NAME]="__$UTIL_NAME"
    [ARG1]="[CALENDAR_STRUCTURE] Target month and year"
    [EX-PRE]="# Example geting last working day in May 1987"
    [EX]="__$UTIL_NAME \$CALENDAR_STRUCTURE"	
)

#
# @brief Calculate last working day of month in year
# @param Value required structure target month and Year
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# CALENDAR_STRUCTURE[MONTH]=$month
# CALENDAR_STRUCTURE[YEAR]=$year
#
# __calutils $CALENDAR_STRUCTURE
#
function __calutils() {
	CALENDAR_STRUCTURE=$1
    TARGET_MONTH=${CALENDAR_STRUCTURE[MONTH]}
    TARGET_YEAR=${CALENDAR_STRUCTURE[YEAR]}
    if [ -n "$TARGET_MONTH"  ] && [ -n "$TARGET_YEAR" ]; then
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n" "[Calculate last working day of month in year]"
		fi
        cal "$TARGET_MONTH" "$TARGET_YEAR" | egrep  "28|29|30|31" | tail -n 1 | awk 'BEGIN {
            var1=$NF;var2=NF;
        }
        {
            if (NF > 1 &&  NF < 7)
                val=$NF;
            else if (NF == 1)
                val=$NF-2;
            else if (NF == 7)
                val=$NF-1;
        }
        {
            print "Last Working Date is : " val;
        }'
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n" "[Done]"
		fi
        return $SUCCESS
    fi
    __usage $TOOL_USAGE
    return $NOT_SUCCESS
}

