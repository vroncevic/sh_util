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

. $UTIL/bin/usage.sh
. $UTIL/bin/devel.sh

declare -A TAR_ARCHIVING_USAGE=(
    [TOOL]="__makeartar"
    [ARG1]="[ARCHIVE_STRUCTURE]  Path and file extension"
    [EX-PRE]="# Example create tar archive with png files"
    [EX]="__makeartar \$ARCHIVE_STRUCTURE"	
)

declare -A GZ_ARCHIVING_USAGE=(
    [TOOL]="__makeartargz"
    [ARG1]="[ARCHIVE_STRUCTURE]  Path, file extension and archive name"
    [EX-PRE]="# Example create tar gz archive with gif images"
    [EX]="__makeartargz \$ARCHIVE_STRUCTURE"	
)

#
# @brief  Find files by name and archive in *.tar  
# @param  Value required structure (location and file name)
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# declare -A ARCHIVE_STRUCTURE_TAR=()
# ARCHIVE_STRUCTURE_TAR[PATH]="/some-path/" 
# ARCHIVE_STRUCTURE_TAR[FILE]="*.png"
#
# __makeartar $ARCHIVE_STRUCTURE_TAR
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
	local ARCHIVE_STRUCTURE_TAR=$1
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
    __usage $TAR_ARCHIVING_USAGE
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
# declare -A ARCHIVE_STRUCTURE_GZ=()
# ARCHIVE_STRUCTURE_GZ[PATH]="/some-path/" 
# ARCHIVE_STRUCTURE_GZ["FILE"]="*.png"
# ARCHIVE_STRUCTURE_GZ["ARCH"]="pngimages"
#
# __makeartargz $ARCHIVE_STRUCTURE_GZ
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
	local ARCHIVE_STRUCTURE_GZ=$1
    local LOCATION=${ARCHIVE_STRUCTURE[PATH]}
    local FILE_NAME=${ARCHIVE_STRUCTURE[FILE]}
    local ARCHIVE_NAME=${ARCHIVE_STRUCTURE[ARCH]}
    if [ -n "$LOCATION" ] && [ -n "$FILE_NAME" ] && [ -n "$ARCHIVE_NAME" ]; then
		local FUNC=${FUNCNAME[0]}
		local MSG=""
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
    __usage $GZ_ARCHIVING_USAGE
    return $NOT_SUCCESS
}

