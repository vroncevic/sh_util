#!/bin/bash
#
# @brief   Array Utilities
# @version ver.1.0
# @date    Sun Oct 11 02:08:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_ARRAY_UTILS=array_utils
UTIL_VERSION_ARRAY_UTILS=ver.1.0
UTIL=/root/scripts/sh_util/${UTIL_VERSION_ARRAY_UTILS}
UTIL_LOG=${UTIL}/log

.    ${UTIL}/bin/devel.sh

#
# @brief  Get the value stored at a specific index eg. ${array[0]}
# @param  Value required array
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# arr $ARRAY
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#    # true
#    # notify admin | user
# else
#    # false
#    # failed to get element
#    # return $NOT_SUCCESS
#    # or 
#    # exit 128
# fi
#
function arr {
    if [[ ! "${1}" =~ ^[a-zA-Z_]+[a-zA-Z0-9_]*$ ]]; then
        local MSG="None" FUNC=${FUNCNAME[0]}
        MSG="Invalid bash variable!"
        info_debug_message "$MSG" "$FUNC" "$UTIL_ARRAY_UTILS"
        MSG="Force exit!"
        info_debug_message_end "$MSG" "$FUNC" "$UTIL_ARRAY_UTILS"
        return $NOT_SUCCESS
    fi
    eval $1=\(\)
    return $SUCCESS
}

#
# @brief  Insert incrementing by incrementing index eg. array+=(data)
# @param  Value required array and element
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# insert $ARRAY $EL
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#    # true
#    # notify admin | user
# else
#    # false
#    # failed to insert element
#    # return $NOT_SUCCESS
#    # or 
#    # exit 128
# fi
#
function insert {
    local FUNC=${FUNCNAME[0]} MSG="None"
    if [[ ! "${1}" =~ ^[a-zA-Z_]+[a-zA-Z0-9_]*$ ]]; then
        MSG="Invalid bash variable!"
        info_debug_message "$MSG" "$FUNC" "$UTIL_ARRAY_UTILS"
        MSG="Force exit!"
        info_debug_message_end "$MSG" "$FUNC" "$UTIL_ARRAY_UTILS"
        return $NOT_SUCCESS
    fi
    declare -p "${1}" > /dev/null 2>&1
    if [[ $? -eq 1 ]]; then
        MSG="Bash variable [${1}] doesn't exist!"
        info_debug_message "$MSG" "$FUNC" "$UTIL_ARRAY_UTILS"
        MSG="Force exit!"
        info_debug_message_end "$MSG" "$FUNC" "$UTIL_ARRAY_UTILS"
        return $NOT_SUCCESS
    fi
    eval $1[\$\(\(\${#${1}[@]}\)\)]=\$2
    return $SUCCESS
}

#
# @brief  Update an index by position
# @params Values required array, position and element
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# set $ARRAY $POS $EL
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#    # true
#    # notify admin | user
# else
#    # false
#    # failed to update element
#    # return $NOT_SUCCESS
#    # or 
#    # exit 128
# fi
#
function set {
    local FUNC=${FUNCNAME[0]} MSG="None"
    if [[ ! "${1}" =~ ^[a-zA-Z_]+[a-zA-Z0-9_]*$ ]]; then
        MSG="Invalid bash variable!"
        info_debug_message "$MSG" "$FUNC" "$UTIL_ARRAY_UTILS"
        MSG="Force exit!"
        info_debug_message_end "$MSG" "$FUNC" "$UTIL_ARRAY_UTILS"
        return $NOT_SUCCESS
    fi
    declare -p "${1}" > /dev/null 2>&1
    if [[ $? -eq 1 ]]; then
        MSG="Bash variable [${1}] doesn't exist!"
        info_debug_message "$MSG" "$FUNC" "$UTIL_ARRAY_UTILS"
        MSG="Force exit!"
        info_debug_message_end "$MSG" "$FUNC" "$UTIL_ARRAY_UTILS"
        return $NOT_SUCCESS
    fi
    eval ${1}[${2}]=\${3}
    return $SUCCESS
}

#
# @brief  Get the array content ${array[@]}
# @param  Value required array
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# get $ARRAY
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#    # true
#    # notify admin | user
# else
#    # false
#    # failed to get content of array
#    # return $NOT_SUCCESS
#    # or 
#    # exit 128
# fi
#
function get {
    local FUNC=${FUNCNAME[0]} MSG="None"
    if [[ ! "${1}" =~ ^[a-zA-Z_]+[a-zA-Z0-9_]*$ ]]; then
        MSG="Invalid bash variable!"
        info_debug_message "$MSG" "$FUNC" "$UTIL_ARRAY_UTILS"
        MSG="Force exit!"
        info_debug_message_end "$MSG" "$FUNC" "$UTIL_ARRAY_UTILS"
        return $NOT_SUCCESS
    fi
    declare -p "${1}" > /dev/null 2>&1
    if [[ $? -eq 1 ]]; then
        MSG="Bash variable [${1}] doesn't exist!"
        info_debug_message "$MSG" "$FUNC" "$UTIL_ARRAY_UTILS"
        MSG="Force exit!"
        info_debug_message_end "$MSG" "$FUNC" "$UTIL_ARRAY_UTILS"
        return $NOT_SUCCESS
    fi
    eval echo \${${1}[@]}
}

#
# @brief  Get the value stored at a specific index eg. ${array[0]} 
# @params Values required array and index
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# at $ARRAY $INDEX
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#    # true
#    # notify admin | user
# else
#    # false
#    # failed to get element
#    # return $NOT_SUCCESS
#    # or 
#    # exit 128
# fi
#
function at {
    local FUNC=${FUNCNAME[0]} MSG="None"
    if [[ ! "${1}" =~ ^[a-zA-Z_]+[a-zA-Z0-9_]*$ ]]; then
        MSG="Invalid bash variable!"
        info_debug_message "$MSG" "$FUNC" "$UTIL_ARRAY_UTILS"
        MSG="Force exit!"
        info_debug_message_end "$MSG" "$FUNC" "$UTIL_ARRAY_UTILS"
        return $NOT_SUCCESS
    fi
    declare -p "${1}" > /dev/null 2>&1
    if [[ $? -eq 1 ]]; then
        MSG="Bash variable [${1}] doesn't exist!"
        info_debug_message "$MSG" "$FUNC" "$UTIL_ARRAY_UTILS"
        MSG="Force exit!"
        info_debug_message_end "$MSG" "$FUNC" "$UTIL_ARRAY_UTILS"
        return $NOT_SUCCESS
    fi
    if [[ ! "${2}" =~ ^(0|[-]?[1-9]+[0-9]*)$ ]]; then
        MSG="Array index must be a number!"
        info_debug_message "$MSG" "$FUNC" "$UTIL_ARRAY_UTILS"
    fi
    local V=${1} I=${2} MAX=$(eval echo \${\#${1}[@]})
    if [[ $MAX -gt 0 && $I -ge 0 && $I -lt $MAX ]]; then
        eval echo \${$V[$I]}
    fi
}

#
# @brief  Get length of array
# @param  Value required array
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# count $ARRAY
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#    # true
#    # notify admin | user
# else
#    # false
#    # failed to get length of array
#    # return $NOT_SUCCESS
#    # or 
#    # exit 128
# fi
#
function count {
    local FUNC=${FUNCNAME[0]} MSG="None"
    if [[ ! "${1}" =~ ^[a-zA-Z_]+[a-zA-Z0-9_]*$ ]]; then
        MSG="Invalid bash variable!"
        info_debug_message "$MSG" "$FUNC" "$UTIL_ARRAY_UTILS"
        MSG="Force exit!"
        info_debug_message_end "$MSG" "$FUNC" "$UTIL_ARRAY_UTILS"
        return $NOT_SUCCESS
    fi
    declare -p "${1}" > /dev/null 2>&1
    if [[ $? -eq 1 ]]; then
        MSG="Bash variable [${1}] doesn't exist!"
        info_debug_message "$MSG" "$FUNC" "$UTIL_ARRAY_UTILS"
        MSG="Force exit!"
        info_debug_message_end "$MSG" "$FUNC" "$UTIL_ARRAY_UTILS"
        return $NOT_SUCCESS
    fi
    local V=${1}
    eval echo \${\#${1}[@]}
}

