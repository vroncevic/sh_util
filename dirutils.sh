#!/bin/bash
#
# @brief   Directory utils
# @version ver.1.0
# @date    Sun Oct 04 19:52:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
TOOL_NAME=dirutils
TOOL_VERSION=ver.1.0
TOOL_EXECUTABLE="${BASH_SOURCE[0]}"
TOOL_BIN=`dirname $TOOL_EXECUTABLE`
TOOL_HOME=`dirname $TOOL_BIN`
TOOL_LOG=$TOOL_HOME/log

. $TOOL_BIN/usage.sh
. $TOOL_BIN/logging.sh

SUCCESS=0
NOT_SUCCESS=1

declare -A TOOL_USAGE_MKDIRF=(
    [TOOL_NAME]="__mkdirf"
    [ARG1]="[DIR_PATH] Directory path"
    [EX-PRE]="# Example creating directory"
    [EX]="__mkdirf /data/test/"	
) 

declare -A TOOL_USAGE_DIRNAME=(
    [TOOL_NAME]="__getdirname"
    [ARG1]="[DIR_PATH] Directory path"
    [EX-PRE]="# Example creating directory"
    [EX]="__mkdirf /data/test/"	
) 

declare -A TOOL_USAGE_BASENAME=(
    [TOOL_NAME]="__getbasename"
    [ARG1]="[DIR_PATH] Directory path"
    [EX-PRE]="# Example creating directory"
    [EX]="__mkdirf /data/test/"	
) 

declare -A TOOL_USAGE_CLEAN=(
    [TOOL_NAME]="__clean"
    [ARG1]="[DIR_PATH] Directory path"
    [EX-PRE]="# Example creating directory"
    [EX]="__mkdirf /data/test/"	
) 

declare -A LOG=(
    [TOOL]="$TOOL_NAME"
    [FLAG]="error"
    [PATH]="$TOOL_LOG"
    [MSG]=""
)

#
# @brief Creating Directory 
# @argument Value required path of directory
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __mkdirf $DIR_PATH
# STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#	# true
# else
#	# false
# fi
#
function __mkdirf() {
    DIR_PATH=$1
    if [ -n "$DIR_PATH" ]; then 
        if [ -d "$DIR_PATH" ]; then
            printf "%s\n" "Directory [$DIR_PATH] already exist" 
            return $NOT_SUCCESS
        fi
        printf "%s\n" "Creating directory..."
        mkdir "$DIR_PATH"
        printf "%s\n" "Done..."
        return $SUCCESS
    fi
    __usage $TOOL_MKDIR_USAGE
    LOG[MSG]="Missing argument"
    __logging $LOG
    return $NOT_SUCCESS
}

#
# @brief Get directory of file
# @argument Value required file
# @retval directory path
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# DIRNAME=$(__getdirname $FILE)
#
function __getdirname() {
    if [ -n "$1" ]; then
        local _dir="${1%${1##*/}}"
        if [ "${_dir:=./}" != "/" ]; then
            _dir="${_dir%?}"
        fi
        echo "$_dir"
    fi
    __usage $TOOL_USAGE_DIRNAME
    LOG[MSG]="Missing argument"
    __logging $LOG
}

#
# @brief Get basename of file
# @argument Value required file
# @retval full name of file
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# BASENAME=$(__getbasename $FILE)
#
function __getbasename() {
    if [ -n "$1" ]; then
        local _name="${1##*/}"
        echo "${_name%$2}"
    fi
    __usage $TOOL_USAGE_BASENAME
    LOG[MSG]="Missing argument"
    __logging $LOG
}

#
# @brief Removing directory
# @argument Value required name of directory
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __clean $DIRECTORY
# STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#	# true
# else
#	# false
# fi
#
function __clean() {
    DIRNAME=$1
    if [ -n "$DIRNAME" ]; then
        printf "%s" "Checking directory "
        if [ -d "$DIRNAME" ]; then
            printf "%s\n" "[ok]"
            printf "%s\n" "Removing empty dir..."
            rm -rf "$DIRNAME"
        fi
        printf "%s\n" "[not ok]"
        printf "%s\n" "Check directory [$DIRNAME]"
        return $NOT_SUCCESS
    fi
    __usage $TOOL_USAGE_CLEAN
    LOG[MSG]="Missing argument"
    __logging $LOG
    return $NOT_SUCCESS
}
