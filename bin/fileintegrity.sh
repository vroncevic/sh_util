#!/bin/bash
#
# @brief   Checking whether files in a given directory have been tampered
# @version ver.1.0
# @date    Mon Oct 12 15:20:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_NAME=fileintegrity
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/logging.sh
. $UTIL/bin/devel.sh

declare -A TOOL_USAGE_SEDB=(
    [TOOL_NAME]="__setupdb"
    [ARG1]="[DB_STRUCTURE] DB file and path"
    [EX-PRE]="# Example set database"
    [EX]="__setupdb \$DB_STRUCTURE"	
)

declare -A TOOL_USAGE_CHDB=(
    [TOOL_NAME]="__checkdb"
    [ARG1]="[DB_FILE] Database file"
    [EX-PRE]="# Example checking database"
    [EX]="__checkdb test.db"	
)

declare -A LOG=(
    [TOOL]="$UTIL_NAME"
    [FLAG]="error"
    [PATH]="$UTIL_LOG"
    [MSG]=""
)

#
# @brief  Setup db file
# @params Values required structure db file and directory
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# DB_STRUCTURE[FILE]="info.db"
# DB_STRUCTURE[DIR]="/data/"
#
# __setupdb $DB_STRUCTURE
# STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
# else
#   # false
# fi
#
function __setupdb() {
	DB_STRUCTURE=$1
    DB_FILE=${DB_STRUCTURE[FILE]}
    DIR=${DB_STRUCTURE[DIR]}
    if [ -n "$DB_FILE" ] && [ -n "$DIR" ]; then
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n" "[Setup db file]"
		fi
        if [ -f "$DB_FILE" ];
			if [ "$TOOL_DEBUG" == "true" ]; then
		        printf "%s\n" "Setup db"
		        printf "%s\n" "Write directory name to first line of file"
			fi
            echo ""$DIR"" > "$DB_FILE"
			if [ "$TOOL_DEBUG" == "true" ]; then
            	printf "%s\n" "Append md5 checksums and filenames"
			fi
            md5sum "$DIR"/* >> "$DB_FILE"
			if [ "$TOOL_DEBUG" == "true" ]; then            
				printf "%s\n\n" "[Done]" 
			fi
            return $SUCCESS
        fi
        LOG[MSG]="Check file [$DB_FILE]"
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n\n" "[Error] ${LOG[MSG]}"
		fi
        __logging $LOG
        return $NOT_SUCCESS
    fi
    __usage $TOOL_USAGE_SEDB
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
# __checkdb "$DB_FILE"
# STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
# else
#   # false
# fi
#
function __checkdb() {
    DB_FILE=$1
    local n=0
    local filename
    local checksum
    if [ -n "$DB_FILE" ]; then
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n" "[Checking db file]"
		fi
        if [ ! -r "$DB_FILE" ]; then
			LOG[MSG]="Unable to read checksum database file"
			if [ "$TOOL_DEBUG" == "true" ]; then
            	printf "%s\n\n" "[Error] ${LOG[MSG]}"
			fi
            __logging $LOG
            return $NOT_SUCCESS
        fi
        while read record[n]
        do
            directory_checked="${record[0]}"
            if [ "$directory_checked" != "$directory" ]; then
				LOG[MSG]="Directories do not match up"
				if [ "$TOOL_DEBUG" == "true" ]; then
                	printf "%s\n\n" "[Error] ${LOG[MSG]}"
				fi
                __logging $LOG
                return $NOT_SUCCESS
            fi
            if [ "$n" -gt 0 ]; then
                filename[n]=$(echo ${record[$n]} | awk '{ print $2 }')
                checksum[n]=$(md5sum "${filename[n]}")
                if [ "${record[n]}" = "${checksum[n]}" ]; then
					if [ "$TOOL_DEBUG" == "true" ]; then
                    	printf "%s\n" "${filename[n]} UNCHANGED"
					fi
                elif [ "`basename ${filename[n]}`" != "$DB_FILE" ]; then.
					if [ "$TOOL_DEBUG" == "true" ]; then                    
						printf "%s\n" "${filename[n]} CHECKSUM ERROR"
					fi
                fi
            fi
            let "n+=1"
        done < "$DB_FILE"
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n" "[Done]"
		fi
        return $SUCCESS
    fi
    __usage $TOOL_USAGE_CHDB
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
# __fileintegrity "$DIR"
# STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
# else
#   # false
# fi
#
function __fileintegrity() {
    if [ -z  "$1" ]; then
        DIR="$PWD"
    else
        DIR="$1"
    fi
	if [ "$TOOL_DEBUG" == "true" ]; then
		printf "%s\n" "[Checking whether files in a given directory have been tampered]"
    	printf "%s\n" "Running file integrity check on [$DIR]"
	fi
    if [ ! -r "$DB_FILE" ]; then
		if [ "$TOOL_DEBUG" == "true" ]; then
        	printf "%s\n" "Setting up database file, \""$DIR"/"$DB_FILE"\""
		fi
        __setupdb "$DB_FILE" "$DIR"
    fi
    __checkdb "$DB_FILE"
    STATUS=$?
    if [ "$STATUS" -eq "$SUCCESS" ]; then
		if [ "$TOOL_DEBUG" == "true" ]; then        
			printf "%s\n\n" "[Done]"
		fi
        return $SUCCESS
    fi
	if [ "$TOOL_DEBUG" == "true" ]; then
    	printf "%s\n\n" "Force exit"
	fi
    return $NOT_SUCCESS
}

