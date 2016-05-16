#!/bin/bash
#
# @brief   Archiving target files
# @version ver.1.0
# @date    Mon Jul 15 21:48:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_NAME=archiving
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/logging.sh
. $UTIL/bin/devel.sh

declare -A TOOL_USAGE_TAR=(
    [TOOL_NAME]="__makeartar"
    [ARG1]="[ARCHIVE_STRUCTURE]  Path and file extension"
    [EX-PRE]="# Example create tar archive with png files"
    [EX]="__makeartar \$ARCHIVE_STRUCTURE"	
)

declare -A TOOL_USAGE_GZ=(
    [TOOL_NAME]="__makeartargz"
    [ARG1]="[ARCHIVE_STRUCTURE]  Path, file extension and archive name"
    [EX-PRE]="# Example create tar gz archive with gif images"
    [EX]="__makeartargz \$ARCHIVE_STRUCTURE"	
)

declare -A LOG=(
    [TOOL]="$UTIL_NAME"
    [FLAG]="error"
    [PATH]="$UTIL_LOG"
    [MSG]=""
)

#
# @brief  Find files by name and archive in *.tar  
# @param  Value required structure (location and file name)
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# ARCHIVE_STRUCTURE[PATH]="/some-path/" 
# ARCHIVE_STRUCTURE[FILE]="*.png"
#
# __makeartar $ARCHIVE_STRUCTURE 
# STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
# else
    # false
# fi
#
function __makeartar() {
	ARCHIVE_STRUCTURE=$1
    LOCATION=${ARCHIVE_STRUCTURE[PATH]}
    FILE_NAME=${ARCHIVE_STRUCTURE[FILE]}
    if [ -n "$LOCATION" ] && [ -n $FILE_NAME ]; then 
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n" "[Creating archive with files $FILE_NAME]"
        	printf "%s\n" "Generating archive file [$LOCATION/$FILE_NAME`date '+%d%m%Y'_archive.tar`]"
		fi
        find $LOCATION -type f -name $FILE_NAME | xargs tar -cvf $LOCATION/$FILE_NAME`date '+%d%m%Y'_archive.tar`
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n\n" "[Done]"
		fi
        return $SUCCESS
    fi 
    __usage $TOOL_USAGE_TAR
    return $NOT_SUCCESS
}

#
# @brief Find files by name and archive in *.tar 
# @param Value required structure path, file name and archive
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# ARCHIVE_STRUCTURE[PATH]="/some-path/" 
# ARCHIVE_STRUCTURE[FILE]="*.png"
# ARCHIVE_STRUCTURE[ARCH]="pngimages"
#
# __makeartargz $ARCHIVE_STRUCTURE
# STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
# else
    # false
# fi
#
function __makeartargz() {
	ARCHIVE_STRUCTURE=$1
    LOCATION=${ARCHIVE_STRUCTURE[PATH]}
    FILE_NAME=${ARCHIVE_STRUCTURE[FILE]}
    ARCHIVE=${ARCHIVE_STRUCTURE[ARCH]}
    if [ -n "$LOCATION" ] && [ -n "$FILE_NAME" ] && [ -n "$ARCHIVE" ]; then
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n" "[Creating archive with files $FILE_NAME]"
  	    	printf "%s\n" "Generating archive file [$ARCHIVE.tar.gz]"
		fi
        find $LOCATION -name $FILE_NAME -type f -print | xargs tar -cvzf $ARCHIVE.tar.gz
		if [ "$TOOL_DEBUG" == "true" ]; then        
			printf "%s\n\n" "[Done]"
		fi
        return $SUCCESS
    fi 
    __usage $TOOL_USAGE_GZ
    return $NOT_SUCCESS
}

