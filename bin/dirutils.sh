#!/bin/bash
#
# @brief   Directory utilities
# @version ver.1.0
# @date    Sun Oct 04 19:52:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_NAME=dirutils
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/logging.sh
. $UTIL/bin/devel.sh

declare -A TOOL_USAGE_MKDIRF=(
    [TOOL_NAME]="__mkdirf"
    [ARG1]="[DIR_PATH] Directory path"
    [EX-PRE]="# Example creating directory"
    [EX]="__mkdirf /opt/test/"	
) 

declare -A TOOL_USAGE_DIRNAME=(
    [TOOL_NAME]="__getdirname"
    [ARG1]="[DIR_PATH] Directory path"
    [EX-PRE]="# Example creating directory"
    [EX]="__mkdirf /opt/test/"	
) 

declare -A TOOL_USAGE_BASENAME=(
    [TOOL_NAME]="__getbasename"
    [ARG1]="[DIR_PATH] Directory path"
    [EX-PRE]="# Example creating directory"
    [EX]="__mkdirf /opt/test/"	
) 

declare -A TOOL_USAGE_CLEAN=(
    [TOOL_NAME]="__clean"
    [ARG1]="[DIR_PATH] Directory path"
    [EX-PRE]="# Example creating directory"
    [EX]="__mkdirf /opt/test/"	
) 

declare -A LOG=(
    [TOOL]="$UTIL_NAME"
    [FLAG]="error"
    [PATH]="$UTIL_LOG"
    [MSG]=""
)

#
# @brief  Creating Directory 
# @param  Value required path of directory
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __mkdirf "$DIR_PATH"
# STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
# else
#   # false
# fi
#
function __mkdirf() {
    DIR_PATH=$1
    if [ -n "$DIR_PATH" ]; then 
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n" "[DIR Utilities: creating directory]"
		fi
        if [ -d "$DIR_PATH" ]; then
			if [ "$TOOL_DEBUG" == "true" ]; then
            	printf "%s\n\n" "Directory [$DIR_PATH] already exist"
			fi 
            return $NOT_SUCCESS
        fi
		if [ "$TOOL_DEBUG" == "true" ]; then
        	printf "%s\n" "Creating directory"
		fi
        mkdir "$DIR_PATH"
		if [ "$TOOL_DEBUG" == "true" ]; then
        	printf "%s\n\n" "[Done]"
		fi
        return $SUCCESS
    fi
    __usage $TOOL_MKDIR_USAGE
    return $NOT_SUCCESS
}

#
# @brief  Get directory of file
# @param  Value required file
# @retval directory path
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# DIRNAME=$(__getdirname $FILE)
#
function __getdirname() {
    if [ -n "$1" ]; then
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n" "[DIR Utilities: get name of directory]"
		fi
        local _dir="${1%${1##*/}}"
        if [ "${_dir:=./}" != "/" ]; then
            _dir="${_dir%?}"
        fi
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n\n" "[Done]"
		fi
        echo "$_dir"
    fi
    __usage $TOOL_USAGE_DIRNAME
}

#
# @brief  Get basename of file
# @param  Value required file
# @retval full name of file
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# BASENAME=$(__getbasename $FILE)
#
function __getbasename() {
    if [ -n "$1" ]; then
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n" "[DIR Utilities: get basename of file]"
		fi
        local _name="${1##*/}"
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n\n" "[Done]"
		fi
        echo "${_name%$2}"
    fi
    __usage $TOOL_USAGE_BASENAME
}

#
# @brief  Removing directory
# @param  Value required name of directory
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __clean "$DIRECTORY"
# STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
# else
#   # false
# fi
#
function __clean() {
    DIRNAME=$1
    if [ -n "$DIRNAME" ]; then
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n" "[DIR Utilities: remove directory]"
        	printf "%s" "Checking directory "
		fi
        if [ -d "$DIRNAME" ]; then
			if [ "$TOOL_DEBUG" == "true" ]; then
		        printf "%s\n" "[ok]"
		        printf "%s\n" "Removing empty dir"
			fi
            rm -rf "$DIRNAME"
			if [ "$TOOL_DEBUG" == "true" ]; then
		    	printf "%s\n" "[Done]"
			fi
			return $SUCCESS
        fi
		if [ "$TOOL_DEBUG" == "true" ]; then
        	printf "%s\n" "[not ok]"
		fi
		LOG[MSG]="Check directory [$DIRNAME]"
		if [ "$TOOL_DEBUG" == "true" ]; then
        	printf "%s\n\n" "[Error] ${LOG[MSG]}"
		fi
        __logging $LOG
        return $NOT_SUCCESS
    fi
    __usage $TOOL_USAGE_CLEAN
    return $NOT_SUCCESS
}

