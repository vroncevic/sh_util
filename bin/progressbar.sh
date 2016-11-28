#!/bin/bash
#
# @brief   Generating progressbar
# @version ver.1.0
# @date    Mon Nov 28 18:44:21 CET 2016
# @company None, free  software to use 2016
# @author  Vladimir Roncevic <elektron.ronca@gmail.com>
# 
UTIL_PROGRESSBAR=progressbar
UTIL_PROGRESSBAR_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_PROGRESSBAR_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/devel.sh
. $UTIL/bin/usage.sh

declare -A PROGRESSBAR_USAGE=(
	[USAGE_TOOL]="__$UTIL_PROGRESSBAR"
	[USAGE_ARG1]="[BAR_WIDTH] Width of bar"
	[USAGE_ARG2]="[MAX_PERCENT] Maximal percent"
	[USAGE_EX_PRE]="# Example drawing progressbar"
	[USAGE_EX]="__$UTIL_PROGRESSBAR \$PROGRESSBAR_STRUCTURE"	
)

#
# @brief  Render progressbar 
# @param  Values required width bar and max percent
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# BAR_WIDTH=$1
# BAR_COUNT=$2
#
# __draw_bar $BAR_WIDTH $BAR_COUNT
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#   # true
#	# notify admin | user 
# else
#   # false
#	# missing argument(s)
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __draw_bar() {
	local BAR_WIDTH=$1
	local BAR_COUNT=$2
	if [ -n "$BAR_WIDTH" ] && [ -n "$BAR_COUNT" ]; then
		local BAR_CHAR_START="["
		local BAR_CHAR_END="]"
		local BAR_CHAR_EMPTY="."
		local BAR_CHAR_FULL="="
		local BRACKET_CHARS=2
		local LIMIT=100
		let "full_limit = ((($BAR_WIDTH - $BRACKET_CHARS) * $BAR_COUNT) / $LIMIT)"
		let "empty_limit = ($BAR_WIDTH - $BRACKET_CHARS) - ${full_limit}"
		local bar_line="${BAR_CHAR_START}"
		for ((j=0; j<full_limit; j++)) 
		do
			bar_line="${bar_line}${BAR_CHAR_FULL}"
		done
		for ((j=0; j<empty_limit; j++))
		do
			bar_line="${bar_line}${BAR_CHAR_EMPTY}"
		done
		bar_line="${bar_line}${BAR_CHAR_END}"
		printf "%3d%% %s" $BAR_COUNT ${bar_line}
		return $SUCCESS
	fi
	return $NOT_SUCCESS
}

#
# @brief  Generating progressbar
# @param  Value required progressbar structure (width and max percent)
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# declare -A PB_STRUCTURE=(
# 	[BAR_WIDTH]=50
# 	[MAX_PERCENT]=100
#	[SLEEP]=0.1
# )
#
# __progressbar PB_STRUCTURE
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#   # true
#	# notify admin | user 
# else
#   # false
#	# missing argument(s)
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __progressbar() {
	local -n PROGRESSBAR_STRUCTURE=$1
	local bar_width=${PROGRESSBAR_STRUCTURE[BAR_WIDTH]}
	local max_percent=${PROGRESSBAR_STRUCTURE[MAX_PERCENT]}
	local sleep_time=${PROGRESSBAR_STRUCTURE[SLEEP]}
	if [ -n "$bar_width" ] && [ -n "$max_percent" ]; then
		for ((i=0; i<=max_percent; i++))
		do
			sleep $sleep_time
			__draw_bar ${bar_width} ${i}
			echo -en "\r"
		done
		return $SUCCESS
	fi
	__usage PROGRESSBAR_USAGE
	return $NOT_SUCCESS
}

