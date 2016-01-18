#!/bin/bash
#
# @brief   Archiving targets
# @version ver.1.0
# @date    Mon Jul 15 21:48:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
TOOL_NAME=archiving
TOOL_VERSION=ver.1.0
TOOL_EXECUTABLE="${BASH_SOURCE[0]}"
TOOL_BIN=`dirname $TOOL_EXECUTABLE`
TOOL_HOME=`dirname $TOOL_BIN`
TOOL_LOG=$TOOL_HOME/log

. $TOOL_BIN/usage.sh
. $TOOL_BIN/logging.sh

SUCCESS=0
NOT_SUCCESS=1

declare -A TOOL_USAGE_TAR=(
    [TOOL_NAME]="__makeartar"
    [ARG1]="[LOCATION]  Path to specific location"
    [ARG2]="[FILE_NAME] File extension"
    [EX-PRE]="# Example create tar archive with png files"
    [EX]="__makeartar /data/ *.png"	
)

declare -A TOOL_USAGE_GZ=(
    [TOOL_NAME]="__makeartargz"
    [ARG1]="[LOCATION]  Path to specific location"
    [ARG2]="[FILE_NAME] File extension"
    [ARG3]="[ARCHIVE]   Name of archive file"
    [EX-PRE]="# Example create tar gz archive with gif images"
    [EX]="__makeartargz /data/ *.gif gif-images"	
)

declare -A LOG=(
    [TOOL]="$TOOL_NAME"
    [FLAG]="error"
    [PATH]="$TOOL_LOG"
    [MSG]=""
)

#
# @brief Find and archive in *.tar archive files by name
# @params Values required location and file name
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __makeartar /some-path/ *.png
# STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#	# true
# else
#	# false
# fi
#
function __makeartar() {
    LOCATION=$1
    FILE_NAME=$2
    if [ -n "$LOCATION" ] && [ -n $FILE_NAME ]; then 
        printf "%s\n" "Generated archive file: $LOCATION/$FILE_NAME`date '+%d%m%Y'_archive.tar`"
        find $LOCATION -type f -name $FILE_NAME | xargs tar -cvf $LOCATION/$FILE_NAME`date '+%d%m%Y'_archive.tar`
        printf "%s\n" "Done..."
        return $SUCCESS
    fi 
    __usage $TOOL_USAGE_TAR
    LOG[MSG]="Missing argument"
    __logging $LOG
    return $NOT_SUCCESS
}

#
# @brief Find and archive in *.tar archive files by name
# @params Values required location, file name and archive
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __makeartargz /some-path/ *.gif gif-images
# STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#	# true
# else
#	# false
# fi
#
function __makeartargz() {
    LOCATION=$1
    FILE_NAME=$2
    ARCHIVE=$3
    if [ -n "$LOCATION" ] && [ -n "$FILE_NAME" ] && [ -n "$ARCHIVE" ]; then 
        printf "%s\n" " Generated archive file: $ARCHIVE.tar.gz"
        find $LOCATION -name $FILE_NAME -type f -print | xargs tar -cvzf $ARCHIVE.tar.gz
        printf "%s\n" " Done..."
        return $SUCCESS
    fi 
    __usage $TOOL_USAGE_GZ
    LOG[MSG]="Missing argument"
    __logging $LOG
    return $NOT_SUCCESS
}
