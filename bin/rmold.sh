#!/bin/bash
#
# @brief   Remove files and directories whose name is 
#          a timestamp older than a certain time
# @version ver.1.0
# @date    Mon Jul 15 21:44:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_NAME=rmold
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/devel.sh

#
# @brief Remove files and directories whose name is 
#        a timestamp older than a certain time
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __rmold
#
function __rmold() {
	if [ "$TOOL_DEBUG" == "true" ]; then
		printf "%s\n" "[Remove files and directories whose name is a timestamp older than a certain time]"
	fi
    ls | grep '....-..-..-......' | xargs -I {} bash -c "[[ x{} < x$(date -d '3 days ago' +%Y-%m-%d-%H%M%S) ]] && rm -rfv {}"
	if [ "$TOOL_DEBUG" == "true" ]; then
		printf "%s\n\n" "[Done]"
	fi
}

