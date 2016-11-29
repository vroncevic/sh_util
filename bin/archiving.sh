#!/bin/bash
#
# @brief   Archiving target files
# @version ver.1.0
# @date    Mon Jul 15 21:48:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_ARCHIVING=archiving
UTIL_ARCHIVING_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_ARCHIVING_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/devel.sh
. $UTIL/bin/usage.sh

declare -A TAR_ARCHIVING_USAGE=(
    [USAGE_TOOL]="__makeartar"
    [USAGE_ARG1]="[ARCHIVE_STRUCTURE]  Path and file extension"
    [USAGE_EX_PRE]="# Example create tar archive with png files"
    [USAGE_EX]="__makeartar \$ARCHIVE_STRUCTURE"	
)

declare -A GZ_ARCHIVING_USAGE=(
    [USAGE_TOOL]="__makeartargz"
    [USAGE_ARG1]="[ARCHIVE_STRUCTURE]  Path, file extension and archive name"
    [USAGE_EX_PRE]="# Example create tar gz archive with gif images"
    [USAGE_EX]="__makeartargz \$ARCHIVE_STRUCTURE"	
)

#
# @brief  Find files by name and archive in *.tar format
# @param  Value required structure (location and file name)
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# declare -A ARCHIVE_STRUCTURE_TAR=(
# 	[PATH]="/some-path/" 
# 	[FILE]="*.png"
# )
#
# __makeartar ARCHIVE_STRUCTURE_TAR
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#   # true
#	# notify admin | user
# else
#	# false
#	# missing agrument(s) | failed to generate archive
#	# return $NOT_SUCCESS
#	# or 
#	# exit 128
# fi
#
function __makeartar() {
	local -n ARCHIVE_STRUCTURE_TAR=$1
    local LOCATION=${ARCHIVE_STRUCTURE_TAR[PATH]}
    local FILE_NAME=${ARCHIVE_STRUCTURE_TAR[FILE]}
    if [ -n "$LOCATION" ] && [ -n $FILE_NAME ]; then
		local FUNC=${FUNCNAME[0]}
		local MSG=""
		local FIND="find $LOCATION -type f -name $FILE_NAME"
		local XARGS="xargs tar -cvf"
		local ARCHIVE="$LOCATION/$FILE_NAME`date '+%d%m%Y'_archive.tar`"
		if [ "$TOOL_DBG" == "true" ]; then
			MSG="Generating archive [$ARCHIVE]"
        	printf "$DSTA" "$UTIL_ARCHIVING" "$FUNC" "$MSG"
		fi
        eval "$FIND | $XARGS $ARCHIVE"
		if [ "$TOOL_DBG" == "true" ]; then
			printf "$DEND" "$UTIL_ARCHIVING" "$FUNC" "Done"
		fi
        return $SUCCESS
    fi 
    __usage TAR_ARCHIVING_USAGE
    return $NOT_SUCCESS
}

#
# @brief  Find files by name and archive in *.tar 
# @param  Value required structure path, file name and archive
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# declare -A ARCHIVE_STRUCTURE_GZ=(
# 	[PATH]="/some-path/" 
# 	[FILE]="*.png"
# 	[ARCH]="pngimages"
# )
#
# __makeartargz ARCHIVE_STRUCTURE_GZ
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#   # true
#	# notify admin | user
# else
#	# false
#	# missing agrument(s) | failed to generate archive
#	# return $NOT_SUCCESS
#	# or 
#	# exit 128
# fi
#
function __makeartargz() {
	local -n ARCHIVE_STRUCTURE_GZ=$1
    local LOCATION=${ARCHIVE_STRUCTURE[PATH]}
    local FILE_NAME=${ARCHIVE_STRUCTURE[FILE]}
    local ARCHIVE_NAME=${ARCHIVE_STRUCTURE[ARCH]}
    if [ -n "$LOCATION" ] && [ -n "$FILE_NAME" ] && [ -n "$ARCHIVE_NAME" ]; then
		local FUNC=${FUNCNAME[0]}
		local MSG="None"
		local FIND="find $LOCATION -name $FILE_NAME -type f -print"
		local XARGS="xargs tar -cvzf"
		local ARCHIVE="$ARCHIVE_NAME.tar.gz"
		if [ "$TOOL_DBG" == "true" ]; then
			MSG="Generating archive [$ARCHIVE]"
  	    	printf "$DSTA" "$UTIL_ARCHIVING" "$FUNC" "$MSG"
		fi
        eval "$FIND | $XARGS $ARCHIVE"
		if [ "$TOOL_DBG" == "true" ]; then        
			printf "$DEND" "$UTIL_ARCHIVING" "$FUNC" "Done"
		fi
        return $SUCCESS
    fi 
    __usage GZ_ARCHIVING_USAGE
    return $NOT_SUCCESS
}

