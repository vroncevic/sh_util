#!/bin/bash
#
# @brief   Directory utilities
# @version ver.1.0.0
# @date    Sun Oct 04 19:52:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_DIR_UTILS=dir_utils
UTIL_DIR_UTILS_VERSION=ver.1.0
UTIL=/root/scripts/sh_util/${UTIL_DIR_UTILS_VERSION}
UTIL_LOG=${UTIL}/log

.    ${UTIL}/bin/devel.sh
.    ${UTIL}/bin/usage.sh

declare -A MKDIRF_Usage=(
    [Usage_TOOL]="mkdirf"
    [Usage_ARG1]="[DIRPATH] Directory path"
    [Usage_EX-PRE]="# Example creating directory"
    [Usage_EX]="mkdirf /opt/test/"
)

declare -A DIRNAME_Usage=(
    [Usage_TOOL]="get_dir_name"
    [Usage_ARG1]="[DIRPATH] Directory path"
    [Usage_EX-PRE]="# Example get name directory"
    [Usage_EX]="get_dir_name /opt/test/"
)

declare -A BASENAME_Usage=(
    [Usage_TOOL]="getbasename"
    [Usage_ARG1]="[DIRPATH] Directory path"
    [Usage_EX-PRE]="# Example get base directory"
    [Usage_EX]="getbasename /opt/test/"
)

declare -A CLEANDIR_Usage=(
    [Usage_TOOL]="clean"
    [Usage_ARG1]="[DIRPATH] Directory path"
    [Usage_EX-PRE]="# Example clean directory"
    [Usage_EX]="clean /opt/test/"
)

#
# @brief  Creating Directory 
# @param  Value required path of directory
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# mkdirf "$DIRPATH"
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#    # true
#    # notify admin | user
# else
#    # false
#    # missing argument | failed to create dir (already exist)
#    # return $NOT_SUCCESS
#    # or
#    # exit 128
# fi
#
function mkdirf {
    local DIRPATH=$1
    if [ -n "${DIRPATH}" ]; then
        local FUNC=${FUNCNAME[0]} MSG="None"
        MSG="Check directory [${DIRPATH}/]?"
        info_debug_message_que "$MSG" "$FUNC" "$UTIL_DIR_UTILS"
        if [ -d "${DIRPATH}/" ]; then
            MSG="[exist]"
            info_debug_message_ans "$MSG" "$FUNC" "$UTIL_DIR_UTILS"
            MSG="Directory [${DIRPATH}/] already exist!"
            info_debug_message "$MSG" "$FUNC" "$UTIL_DIR_UTILS"
            MSG="Force exit!"
            info_debug_message_end "$MSG" "$FUNC" "$UTIL_DIR_UTILS"
            return $NOT_SUCCESS
        fi
        MSG="[not exist]"
        info_debug_message_ans "$MSG" "$FUNC" "$UTIL_DIR_UTILS"
        MSG="Creating directory [${DIRPATH}/]!"
        info_debug_message "$MSG" "$FUNC" "$UTIL_DIR_UTILS"
        mkdir "${DIRPATH}"
        info_debug_message_end "Done" "$FUNC" "$UTIL_DIR_UTILS"
        return $SUCCESS
    fi
    usage TOOL_MKDIR_Usage
    return $NOT_SUCCESS
}

#
# @brief  Get directory of file
# @param  Value required file
# @retval directory path
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# local DIRNAME=$(get_dir_name $FILE)
#
function get_dir_name {
    if [ -n "${1}" ]; then
        local FUNC=${FUNCNAME[0]} MSG="None" _dir
        MSG="Get name of directory!"
        info_debug_message "$MSG" "$FUNC" "$UTIL_DIR_UTILS"
        _dir="${1%${1##*/}}"
        if [ "${_dir:=./}" != "/" ]; then
            _dir="${_dir%?}"
        fi
        info_debug_message_end "Done" "$FUNC" "$UTIL_DIR_UTILS"
        echo "$_dir"
    fi
    usage DIRNAME_Usage
}

#
# @brief  Get basename of file
# @param  Value required file
# @retval full name of file
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# local BASENAME=$(getbasename $FILE)
#
function getbasename {
    if [ -n "${1}" ]; then
        local FUNC=${FUNCNAME[0]} MSG="None" _name
        MSG="Get basename of file!"
        info_debug_message "$MSG" "$FUNC" "$UTIL_DIR_UTILS"
        _name="${1##*/}"
        info_debug_message_end "Done" "$FUNC" "$UTIL_DIR_UTILS"
        echo "${_name%$2}"
    fi
    usage BASENAME_Usage
}

#
# @brief  Removing directory
# @param  Value required name of directory
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# clean "$DIRECTORY"
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#    # true
#    # notify admin | user
# else
#    # false
#    # missing argument | failed to clean dir
#    # return $NOT_SUCCESS
#    # or
#    # exit 128
# fi
#
function clean {
    local DIRNAME=$1
    if [ -n "${DIRNAME}" ]; then
        local FUNC=${FUNCNAME[0]} MSG="None"
        MSG="Checking directory [${DIRNAME}/]?"
        info_debug_message_que "$MSG" "$FUNC" "$UTIL_DIR_UTILS"
        if [ -d "${DIRNAME}" ]; then
            MSG="[ok]"
            info_debug_message_ans "$MSG" "$FUNC" "$UTIL_DIR_UTILS"
            rm -rf "${DIRNAME}/"
            info_debug_message_end "Done" "$FUNC" "$UTIL_DIR_UTILS"
            return $SUCCESS
        fi
        MSG="[not ok]"
        info_debug_message_ans "$MSG" "$FUNC" "$UTIL_DIR_UTILS"
        MSG="Please check directory [${DIRNAME}/]!"
        info_debug_message "$MSG" "$FUNC" "$UTIL_DIR_UTILS"
        MSG="Force exit!"
        info_debug_message_end "$MSG" "$FUNC" "$UTIL_DIR_UTILS"
        return $NOT_SUCCESS
    fi
    usage CLEANDIR_Usage
    return $NOT_SUCCESS
}

