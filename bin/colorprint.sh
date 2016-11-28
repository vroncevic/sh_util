#!/bin/bash
#
# @brief   Print color text
# @version ver.1.0
# @date    Mon Nov 28 19:54:27 CET 2016
# @company None, free  software to use 2016
# @author  Vladimir Roncevic <elektron.ronca@gmail.com>
# 
UTIL_COLORPRINT=colorprint
UTIL_COLORPRINT_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_COLORPRINT_VERSION
UTIL_COLORPRINT_CFG=$UTIL/conf/$UTIL_COLORPRINT.cfg
UTIL_LOG=$UTIL/log

. $UTIL/bin/devel.sh
. $UTIL/bin/usage.sh

declare -A COLORPRINT_USAGE=(
	[USAGE_TOOL]="__$UTIL_COLORPRINT"
	[USAGE_ARG1]="[MESSAGE] Message to text"
	[USAGE_ARG2]="[COLOR] Color for text"
	[USAGE_EX_PRE]="# Example printing color text"
	[USAGE_EX]="__$UTIL_COLORPRINT \$MSG \$blue"	
)

black='\E[30;47m'
red='\E[31;47m'
green='\E[32;47m'
yellow='\E[33;47m'
blue='\E[34;47m'
magenta='\E[35;47m'
cyan='\E[36;47m'
white='\E[37;47m'
alias Reset="tput sgr0"

#
# @brief  Sending broadcast message
# @param  Value required broadcastmessage structure (message and note)
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __colorprint "Feeling blue..." $blue
# local STATUS=$?
#
# __colorprint "Green with envy." $green
# STATUS=$?
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
function __colorprint() {
	local message2txt=$1
	local color2txt=$2
	if [ -n "$message2txt" ] && [ -n "$color2txt" ]; then
		local default_msg="No message passed."
		local message=${message2txt:-$default_msg}
		local color=${color2txt:-$black}
		echo -e "$color"
		echo "$message"
		return $SUCCESS
	fi
	__usage COLORPRINT_USAGE
	return $NOT_SUCCESS
}

