#!/bin/bash
#
# @brief   Checking whether files in a given directory have been tampered
# @version ver.1.0
# @date    Mon Oct 12 15:20:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
TOOL_NAME=fileintegrity
TOOL_VERSION=ver.1.0
TOOL_EXECUTABLE="${BASH_SOURCE[0]}"
TOOL_BIN=`dirname $TOOL_EXECUTABLE`
TOOL_HOME=`dirname $TOOL_BIN`
TOOL_LOG=$TOOL_HOME/log

. $TOOL_BIN/usage.sh
. $TOOL_BIN/logging.sh

SUCCESS=0
NOT_SUCCESS=1

declare -A TOOL_USAGE_SEDB=(
    [TOOL_NAME]="__setupdb"
    [ARG1]="[DB_FILE] Database file"
    [ARG2]="[DIR]     Directory with files"
    [EX-PRE]="# Example set database"
    [EX]="__setupdb test.db /data/"	
)

declare -A TOOL_USAGE_CHDB=(
    [TOOL_NAME]="__checkdb"
    [ARG1]="[DB_FILE] Database file"
    [EX-PRE]="# Example checking database"
    [EX]="__checkdb test.db"	
)

declare -A LOG=(
    [TOOL]="$TOOL_NAME"
    [FLAG]="error"
    [PATH]="$TOOL_LOG"
    [MSG]=""
)

#
# @brief Setup db file
# @argument Value required name of db file and directory
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __setupdb $DB_FILE $DIR
# STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#	# true
# else
#	# false
# fi
#
function __setupdb() {
    DB_FILE=$1
    DIR=$2
    if [ -n "$DB_FILE" ] && [ -n "$DIR" ]; then
        printf "%s\n" "Setup db..."
        printf "%s\n" "Write directory name to first line of file"
        echo ""$DIR"" > "$DB_FILE"
        printf "%s\n" "Append md5 checksums and filenames"
        md5sum "$DIR"/* >> "$DB_FILE"
        printf "%s\n" "Done..." 
        return $SUCCESS
    fi
    __usage $TOOL_USAGE_SEDB
    LOG[MSG]="Missing argument"
    __logging $LOG
    return $NOT_SUCCESS
}

#
# @brief Checking db 
# @argument Value required path to db file
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __checkdb $DB_FILE
# CHECK_DB=$?
#
# if [ $CHECK_DB -eq $SUCCESS ]; then
#	# true
# else
#	# false
# fi
#
function __checkdb() {
    DB_FILE=$1
    local n=0
    local filename
    local checksum
    if [ -n "$DB_FILE" ]; then
        if [ ! -r "$DB_FILE" ]; then
                printf "%s\n" "Unable to read checksum database file"
                return $NOT_SUCCESS
        fi
        while read record[n]
        do
            directory_checked="${record[0]}"
            if [ "$directory_checked" != "$directory" ]; then
                printf "%s\n" "Directories do not match up"
                return $NOT_SUCCESS
            fi
            if [ "$n" -gt 0 ]; then
                filename[n]=$(echo ${record[$n]} | awk '{ print $2 }')
                checksum[n]=$(md5sum "${filename[n]}")
                if [ "${record[n]}" = "${checksum[n]}" ]; then
                    printf "%s\n" "${filename[n]} UNCHANGED"
                elif [ "`basename ${filename[n]}`" != "$DB_FILE" ]; then.
                    printf "%s\n" "${filename[n]} CHECKSUM ERROR"
                fi
            fi
            let "n+=1"
        done <"$DB_FILE"
        return $SUCCESS
    fi
    __usage $TOOL_USAGE_CHDB
    LOG[MSG]="Missing argument"
    __logging $LOG
    return $NOT_SUCCESS
}

#
# @brief Checking whether files in a given directory have been tampered
# @argument Value required directory
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __fileintegrity $DIR
# STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#	# true
# else
#	# false
# fi
#
function __fileintegrity() {
    if [ -z  "$1" ]; then
        DIR="$PWD"
    else
        DIR="$1"
    fi
    printf "%s\n" "Running file integrity check on [$DIR]"
    if [ ! -r "$DB_FILE" ]; then
        printf "%s\n" "Setting up database file, \""$DIR"/"$DB_FILE"\""
        __setupdb $DB_FILE $DIR
    fi
    __checkdb $DB_FILE
    CHECK_DB=$?
    if [ $CHECK_DB -eq $SUCCESS ]; then
        printf "%s\n" "Complete..."
        return $SUCCESS
    fi
    printf "%s\n" "Force exit..."
    return $NOT_SUCCESS
}
