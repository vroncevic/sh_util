#!/bin/bash
#
# @brief   Directory utilities
# @version ver.1.0
# @date    Sun Oct 04 19:52:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_DIRUTILS=dirutils
UTIL_DIRUTILS_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_DIRUTILS_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/devel.sh
. $UTIL/bin/usage.sh

declare -A MKDIRF_USAGE=(
    [USAGE_TOOL]="__mkdirf"
    [USAGE_ARG1]="[DIR_PATH] Directory path"
    [USAGE_EX-PRE]="# Example creating directory"
    [USAGE_EX]="__mkdirf /opt/test/"
) 

declare -A DIRNAME_USAGE=(
    [USAGE_TOOL]="__getdirname"
    [USAGE_ARG1]="[DIR_PATH] Directory path"
    [USAGE_EX-PRE]="# Example creating directory"
    [USAGE_EX]="__mkdirf /opt/test/"
) 

declare -A BASENAME_USAGE=(
    [USAGE_TOOL]="__getbasename"
    [USAGE_ARG1]="[DIR_PATH] Directory path"
    [USAGE_EX-PRE]="# Example creating directory"
    [USAGE_EX]="__mkdirf /opt/test/"
) 

declare -A CLEANDIR_USAGE=(
    [USAGE_TOOL]="__clean"
    [USAGE_ARG1]="[DIR_PATH] Directory path"
    [USAGE_EX-PRE]="# Example creating directory"
    [USAGE_EX]="__mkdirf /opt/test/"
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
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#   # true
#   # notify admin | user
# else
#   # false
#	# missing argument | failed to create dir (already exist)
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __mkdirf() {
    local DIR_PATH=$1
    if [ -n "$DIR_PATH" ]; then
		local FUNC=${FUNCNAME[0]}
		local MSG="None"
		if [ "$TOOL_DBG" == "true" ]; then
			MSG="Check dir [$DIR_PATH/]"
			printf "$DQUE" "$UTIL_DIRUTILS" "$FUNC" "$MSG"
		fi
        if [ -d "$DIR_PATH" ]; then
			if [ "$TOOL_DBG" == "true" ]; then
				printf "%s\n" "[already exist]"
			fi 
			MSG="Dir [$DIR_PATH/] already exist"
			printf "$SEND" "$UTIL_DIRUTILS" "$MSG"
            return $NOT_SUCCESS
        fi
		if [ "$TOOL_DBG" == "true" ]; then
        	MSG="Creating dir [$DIR_PATH/]"
			printf "$DSTA" "$UTIL_DIRUTILS" "$FUNC" "$MSG"
		fi
        mkdir "$DIR_PATH"
		if [ "$TOOL_DBG" == "true" ]; then
        	printf "$DEND" "$UTIL_DIRUTILS" "$FUNC" "Done"
		fi
        return $SUCCESS
    fi
    __usage TOOL_MKDIR_USAGE
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
# local DIRNAME=$(__getdirname $FILE)
#
function __getdirname() {
    if [ -n "$1" ]; then
		local FUNC=${FUNCNAME[0]}
		local MSG="None"
		if [ "$TOOL_DBG" == "true" ]; then
			MSG="Get name of dir"
			printf "$DSTA" "$UTIL_DIRUTILS" "$FUNC" "$MSG"
		fi
        local _dir="${1%${1##*/}}"
        if [ "${_dir:=./}" != "/" ]; then
            _dir="${_dir%?}"
        fi
		if [ "$TOOL_DBG" == "true" ]; then
			printf "$DEND" "$UTIL_DIRUTILS" "$FUNC" "Done"
		fi
        echo "$_dir"
    fi
    __usage DIRNAME_USAGE
}

#
# @brief  Get basename of file
# @param  Value required file
# @retval full name of file
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# local BASENAME=$(__getbasename $FILE)
#
function __getbasename() {
    if [ -n "$1" ]; then
		local FUNC=${FUNCNAME[0]}
		local MSG="None"
		if [ "$TOOL_DBG" == "true" ]; then
			MSG="Get basename of file"
			printf "$DSTA" "$UTIL_DIRUTILS" "$FUNC" "$MSG"
		fi
        local _name="${1##*/}"
		if [ "$TOOL_DBG" == "true" ]; then
			printf "$DEND" "$UTIL_DIRUTILS" "$FUNC" "Done"
		fi
        echo "${_name%$2}"
    fi
    __usage BASENAME_USAGE
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
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#   # true
#   # notify admin | user
# else
#   # false
#	# missing argument | failed to clean dir
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __clean() {
    local DIRNAME=$1
    if [ -n "$DIRNAME" ]; then
		local FUNC=${FUNCNAME[0]}
		local MSG="None"
		if [ "$TOOL_DBG" == "true" ]; then
        	MSG="Checking dir [${config[TOOLS]}/]"
			printf "$DQUE" "$UTIL_DIRUTILS" "$FUNC" "$MSG"
		fi
        if [ -d "$DIRNAME" ]; then
			if [ "$TOOL_DBG" == "true" ]; then
		        printf "%s\n" "[ok]"
			fi
            rm -rf "$DIRNAME"
			if [ "$TOOL_DBG" == "true" ]; then
		    	printf "$DEND" "$UTIL_DIRUTILS" "$FUNC" "Done"
			fi
			return $SUCCESS
        fi
		if [ "$TOOL_DBG" == "true" ]; then
        	printf "%s\n" "[not ok]"
		fi
		MSG="Please check dir [$DIRNAME]"
		printf "$SEND" "$UTIL_DIRUTILS" "$MSG"
        return $NOT_SUCCESS
    fi
    __usage CLEANDIR_USAGE
    return $NOT_SUCCESS
}

