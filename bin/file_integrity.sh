#!/bin/bash
#
# @brief   Checking whether files in a given directory have been tampered
# @version ver.1.0
# @date    Mon Oct 12 15:20:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_FILE_INTEGRITY=file_integrity
UTIL_FILE_INTEGRITY_VERSION=ver.1.0
UTIL=/root/scripts/sh_util/${UTIL_FILE_INTEGRITY_VERSION}
UTIL_FILE_INTEGRITY_CFG=${UTIL}/conf/${UTIL_FILE_INTEGRITY}.cfg
UTIL_LOG=${UTIL}/log

.    ${UTIL}/bin/devel.sh
.    ${UTIL}/bin/usage.sh
.    ${UTIL}/bin/check_tool.sh
.    ${UTIL}/bin/load_util_conf.sh

declare -A SET_DB_USAGE=(
    [USAGE_TOOL]="setup_db"
    [USAGE_ARG1]="[DB_STRUCT] DB file and path"
    [USAGE_EX_PRE]="# Example set database"
    [USAGE_EX]="setup_db \$DB_STRUCT"
)

declare -A CHECK_DB_USAGE=(
    [USAGE_TOOL]="check_db"
    [USAGE_ARG1]="[FILE] Database file"
    [USAGE_EX_PRE]="# Example checking database"
    [USAGE_EX]="check_db test.db"
)

#
# @brief  Setup db file
# @params Values required structure db file and directory
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# declare -A DB_STRUCT=(
#    [FILE]="info.db"
#    [DIR]="/data/"
# )
#
# setup_db DB_STRUCT
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#    # true
#    # notify admin | user
# else
#    # false
#    # missing argument | missing file
#    # return $NOT_SUCCESS
#    # or
#    # exit 128
# fi
#
function setup_db {
    local -n DB_STRUCT=$1
    local FILE=${DB_STRUCT[FILE]} DIR=${DB_STRUCT[DIR]}
    if [[ -n "${FILE}" && -n "${DIR}" ]]; then
        local FUNC=${FUNCNAME[0]} MSG="None" STATUS
        declare -A config_file_integrity=()
        load_util_conf "$UTIL_FILE_INTEGRITY_CFG" config_file_integrity
        STATUS=$?
        if [ $STATUS -eq $SUCCESS ]; then
            local MD5SUM=${config_file_integrity[MD5SUM]}
            if [ -e "${FILE}" ];
                MSG="Write directory name to first line of file!"
                info_debug_message "$MSG" "$FUNC" "$UTIL_FILE_INTEGRITY"
                echo "${DIR}" > "${FILE}"
                MSG="Append md5 checksums and filenames!"
                info_debug_message "$MSG" "$FUNC" "$UTIL_FILE_INTEGRITY"
                eval "${MD5SUM} ${DIR}/* >> ${FILE}"
                info_debug_message_end "Done" "$FUNC" "$UTIL_FILE_INTEGRITY"
                return $SUCCESS
            fi
            MSG="Please check file [${FILE}]!"
            info_debug_message "$MSG" "$FUNC" "$UTIL_FILE_INTEGRITY"
            MSG="Force exit!"
            info_debug_message_end "$MSG" "$FUNC" "$UTIL_FILE_INTEGRITY"
            return $NOT_SUCCESS
        fi
        MSG="Force exit!"
        info_debug_message_end "$MSG" "$FUNC" "$UTIL_FILE_INTEGRITY"
        return $NOT_SUCCESS
    fi
    usage SET_DB_USAGE
    return $NOT_SUCCESS
}

#
# @brief  Checking db 
# @param  Value required path to db file
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# local FILE="/opt/somedb.db" STATUS
# check_db "$FILE"
# STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#    # true
#    # notify admin | user
# else
#    # false
#    # missing argument | missing file
#    # return $NOT_SUCCESS
#    # or
#    # exit 128
# fi
#
function check_db {
    local FILE=$1
    if [ -n "${FILE}" ]; then
        local FUNC=${FUNCNAME[0]} MSG="None" N=0 FILENAME CHECKSUM
        MSG="Checking db file [${FILE}]?"
        info_debug_message_que "$MSG" "$FUNC" "$UTIL_FILE_INTEGRITY"
        if [ ! -r "${FILE}" ]; then
            MSG="[not ok]"
            info_debug_message_ans "$MSG" "$FUNC" "$UTIL_FILE_INTEGRITY"
            MSG="Unable to read CHECKSUM database file!"
            info_debug_message "$MSG" "$FUNC" "$UTIL_FILE_INTEGRITY"
            MSG="Force exit!"
            info_debug_message_end "$MSG" "$FUNC" "$UTIL_FILE_INTEGRITY"
            return $NOT_SUCCESS
        fi
        MSG="[ok]"
        info_debug_message_ans "$MSG" "$FUNC" "$UTIL_FILE_INTEGRITY"
        while read RECORD[N]
        do
            local DIRCHECKED=${RECORD[0]}
            if [ "$DIRCHECKED" != "$directory" ]; then
                MSG="Directories do not match up!"
                info_debug_message "$MSG" "$FUNC" "$UTIL_FILE_INTEGRITY"
                MSG="Force exit!"
                info_debug_message_end "$MSG" "$FUNC" "$UTIL_FILE_INTEGRITY"
                return $NOT_SUCCESS
            fi
            if [ ${N} -gt 0 ]; then
                local FILENAME[n]=$(echo ${RECORD[$N]} | awk '{ print $2 }')
                local CHECKSUM[n]=$(md5sum "${FILENAME[N]}")
                if [ "${RECORD[N]}" == "${CHECKSUM[N]}" ]; then
                    MSG="${FILENAME[N]} UNCHANGED"
                    info_debug_message "$MSG" "$FUNC" "$UTIL_FILE_INTEGRITY"
                elif [ "`basename ${FILENAME[N]}`" != "$FILE" ]; then
                    MSG="${FILENAME[N]} CHECKSUM ERROR"
                    info_debug_message "$MSG" "$FUNC" "$UTIL_FILE_INTEGRITY"
                fi
            fi
            let "N+=1"
        done < "${FILE}"
        info_debug_message_end "Done" "$FUNC" "$UTIL_FILE_INTEGRITY"
        return $SUCCESS
    fi
    usage CHECK_DB_USAGE
    return $NOT_SUCCESS
}

#
# @brief  Checking whether files in a given directory have been tampered
# @param  Value required directory
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# local DIR="/opt/" STATUS
# file_integrity "$DIR"
# STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#    # true
#    # notify admin | user
# else
#    # false
#    # check db file
#    # return $NOT_SUCCESS
#    # or
#    # exit 128
# fi
#
function file_integrity {
    local DIR="" FUNC=${FUNCNAME[0]} MSG="None" STATUS
    if [ -z  "${1}" ]; then
        DIR="$PWD"
    else
        DIR="${1}"
    fi
    MSG="Running file integrity check on [${DIR}/]!"
    info_debug_message "$MSG" "$FUNC" "$UTIL_FILE_INTEGRITY"
    if [ ! -r "${FILE}" ]; then
        MSG="Setting up database file, \""${DIR}"/"${FILE}"\""
        info_debug_message "$MSG" "$FUNC" "$UTIL_FILE_INTEGRITY"
        setup_db "${FILE}" "${DIR}"
    fi
    check_db "${FILE}"
    STATUS=$?
    if [ $STATUS -eq $SUCCESS ]; then
        info_debug_message_end "Done" "$FUNC" "$UTIL_FILE_INTEGRITY"
        return $SUCCESS
    fi
    MSG="Force exit!"
    info_debug_message_end "$MSG" "$FUNC" "$UTIL_FILE_INTEGRITY"
    return $NOT_SUCCESS
}

