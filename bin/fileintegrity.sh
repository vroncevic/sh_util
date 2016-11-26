#!/bin/bash
#
# @brief   Checking whether files in a given directory have been tampered
# @version ver.1.0
# @date    Mon Oct 12 15:20:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_FILEINTEGRITY=fileintegrity
UTIL_FILEINTEGRITY_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_FILEINTEGRITY_VERSION
UTIL_FILEINTEGRITY_CFG=$UTIL/conf/$UTIL_FILEINTEGRITY.cfg
UTIL_LOG=$UTIL/log

. $UTIL/bin/loadutilconf.sh
. $UTIL/bin/usage.sh
. $UTIL/bin/checktool.sh
. $UTIL/bin/devel.sh

declare -A SETDB_USAGE=(
    ["TOOL"]="__setupdb"
    ["ARG1"]="[DB_STRUCTURE] DB file and path"
    ["EX-PRE"]="# Example set database"
    ["EX"]="__setupdb \$DB_STRUCTURE"	
)

declare -A CHECKDB_USAGE=(
    ["TOOL"]="__checkdb"
    ["ARG1"]="[DB_FILE] Database file"
    ["EX-PRE"]="# Example checking database"
    ["EX"]="__checkdb test.db"	
)

#
# @brief  Setup db file
# @params Values required structure db file and directory
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# declare -A DB_STRUCTURE=()
# DB_STRUCTURE[FILE]="info.db"
# DB_STRUCTURE[DIR]="/data/"
#
# __setupdb "$(declare -p DB_STRUCTURE)"
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#   # true
#   # notify admin | user
# else
#   # false
#	# missing argument | missing file
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __setupdb() {
	eval "declare -A DB_STRUCTURE="${1#*=}
    local DB_FILE=${DB_STRUCTURE["FILE"]}
    local DIR=${DB_STRUCTURE["DIR"]}
    if [ -n "$DB_FILE" ] && [ -n "$DIR" ]; then
		local FUNC=${FUNCNAME[0]}
		local MSG=""
		declare -A configfileintegrityutil=()
		__loadutilconf "$UTIL_FILEINTEGRITY_CFG" configfileintegrityutil
		local STATUS=$?
		if [ $STATUS -eq $SUCCESS ]; then
			local md5sum=${configfileintegrityutil[MD5SUM]}
		    if [ -f "$DB_FILE" ];
				if [ "$TOOL_DBG" == "true" ]; then
				    MSG="Write directory name to first line of file"
					printf "$DSTA" "$UTIL_FILEINTEGRITY" "$FUNC" "$MSG"
				fi
		        echo ""$DIR"" > "$DB_FILE"
				if [ "$TOOL_DBG" == "true" ]; then
		        	MSG="Append md5 checksums and filenames"
					printf "$DSTA" "$UTIL_FILEINTEGRITY" "$FUNC" "$MSG"
				fi
		        eval "$md5sum $DIR/* >> $DB_FILE"
				if [ "$TOOL_DBG" == "true" ]; then            
					printf "$DEND" "$UTIL_FILEINTEGRITY" "$FUNC" "Done"
				fi
		        return $SUCCESS
		    fi
			MSG="Please check file [$DB_FILE]"
			printf "$SEND" "$UTIL_FILEINTEGRITY" "$MSG"
		    return $NOT_SUCCESS
		fi
		return $NOT_SUCCESS
    fi
    __usage "$(declare -p SETDB_USAGE)"
    return $NOT_SUCCESS
}

#
# @brief  Checking db 
# @param  Value required path to db file
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# local DB_FILE="/opt/somedb.db"
# __checkdb "$DB_FILE"
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#   # true
#   # notify admin | user
# else
#   # false
#	# missing argument | missing file
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __checkdb() {
    local DB_FILE=$1
    local n=0
    local filename
    local checksum
    if [ -n "$DB_FILE" ]; then
		local FUNC=${FUNCNAME[0]}
		local MSG=""
		if [ "$TOOL_DBG" == "true" ]; then
			MSG="Checking db file [$DB_FILE]"
			printf "$DSTA" "$UTIL_FILEINTEGRITY" "$FUNC" "$MSG"
		fi
        if [ ! -r "$DB_FILE" ]; then
			if [ "$TOOL_DBG" == "true" ]; then
            	MSG="Unable to read checksum database file"
				printf "$DEND" "$UTIL_FILEINTEGRITY" "$FUNC" "$MSG"
			fi
            return $NOT_SUCCESS
        fi
        while read record[n]
        do
            directory_checked="${record[0]}"
            if [ "$directory_checked" != "$directory" ]; then
				if [ "$TOOL_DBG" == "true" ]; then
                	MSG="Directories do not match up"
                	printf "$DEND" "$UTIL_FILEINTEGRITY" "$FUNC" "$MSG"
				fi
                return $NOT_SUCCESS
            fi
            if [ "$n" -gt 0 ]; then
                local filename[n]=$(echo ${record[$n]} | awk '{ print $2 }')
                local checksum[n]=$(md5sum "${filename[n]}")
                if [ "${record[n]}" = "${checksum[n]}" ]; then
					if [ "$TOOL_DBG" == "true" ]; then
                    	MSG="${filename[n]} UNCHANGED"
						printf "$DSTA" "$UTIL_FILEINTEGRITY" "$FUNC" "$MSG"
					fi
                elif [ "`basename ${filename[n]}`" != "$DB_FILE" ]; then
					if [ "$TOOL_DBG" == "true" ]; then
						MSG="${filename[n]} CHECKSUM ERROR"
						printf "$DSTA" "$UTIL_FILEINTEGRITY" "$FUNC" "$MSG"
					fi
                fi
            fi
            let "n+=1"
        done < "$DB_FILE"
		if [ "$TOOL_DBG" == "true" ]; then
			printf "$DEND" "$UTIL_FILEINTEGRITY" "$FUNC" "Done"
		fi
        return $SUCCESS
    fi
    __usage "$(declare -p CHECKDB_USAGE)"
    return $NOT_SUCCESS
}

#
# @brief  Checking whether files in a given directory have been tampered
# @param  Value required directory
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# local DIR="/opt/"
# __fileintegrity "$DIR"
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#   # true
#   # notify admin | user
# else
#   # false
#	# check db file
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __fileintegrity() {
	local DIR=""
    if [ -z  "$1" ]; then
        DIR="$PWD"
    else
        DIR="$1"
    fi
    local FUNC=${FUNCNAME[0]}
    local MSG=""
	if [ "$TOOL_DBG" == "true" ]; then
    	MSG="Running file integrity check on [$DIR]"
		printf "$DSTA" "$UTIL_FILEINTEGRITY" "$FUNC" "$MSG"
	fi
    if [ ! -r "$DB_FILE" ]; then
		if [ "$TOOL_DBG" == "true" ]; then
        	MSG="Setting up database file, \""$DIR"/"$DB_FILE"\""
			printf "$DSTA" "$UTIL_FILEINTEGRITY" "$FUNC" "$MSG"
		fi
        __setupdb "$DB_FILE" "$DIR"
    fi
    __checkdb "$DB_FILE"
    local STATUS=$?
    if [ $STATUS -eq $SUCCESS ]; then
		if [ "$TOOL_DBG" == "true" ]; then        
			printf "$DEND" "$UTIL_FILEINTEGRITY" "$FUNC" "Done"
		fi
        return $SUCCESS
    fi
	if [ "$TOOL_DBG" == "true" ]; then
    	printf "$DEND" "$UTIL_FILEINTEGRITY" "$FUNC" "Force exit"
	fi
    return $NOT_SUCCESS
}

