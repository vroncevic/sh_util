#!/bin/bash
#
# @brief   Array Utilities
# @version ver.1.0
# @date    Sun Oct 11 02:08:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
#
TOOL_NAME=arraylist
TOOL_VERSION=ver.1.0
TOOL_EXECUTABLE="${BASH_SOURCE[0]}"
TOOL_BIN=`dirname $TOOL_EXECUTABLE`
TOOL_HOME=`dirname $TOOL_BIN`
TOOL_LOG=$TOOL_HOME/log

. $TOOL_BIN/logging.sh

SUCCESS=0
NOT_SUCCESS=1

declare -A LOG=(
    [TOOL]="$TOOL_NAME"
    [FLAG]="error"
    [PATH]="$TOOL_LOG"
    [MSG]=""
)

#
# @brief Get the value stored at a specific index eg. ${array[0]} 
# @param Value required array
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __arr $ARRAY
#
function __arr() {
    if [[ ! "$1" =~ ^[a-zA-Z_]+[a-zA-Z0-9_]*$ ]]; then
        printf "%s\n" "Invalid bash variable"
        LOG[MSG]="Invalid bash variable"
        __logging $LOG
        return $NOT_SUCCESS
    fi
    eval $1=\(\)
}

#
# @brief Insert incrementing by incrementing index eg. array+=(data)
# @param Value required array and element
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __insert $ARRAY $EL
#
function __insert() { 
    if [[ ! "$1" =~ ^[a-zA-Z_]+[a-zA-Z0-9_]*$ ]]; then
        printf "%s\n" "Invalid bash variable"
        LOG[MSG]="Invalid bash variable"
        __logging $LOG
        return $NOT_SUCCESS
    fi
    declare -p "$1" > /dev/null 2>&1
    if [[ $? -eq 1 ]]; then
        printf "%s\n" "Bash variable [${1}] doesn't exist"
        LOG[MSG]="Bash variable [${1}] doesn't exist"
        __logging $LOG
        return $NOT_SUCCESS
    fi
    eval $1[\$\(\(\${#${1}[@]}\)\)]=\$2
}

#
# @brief Update an index by position
# @param Value required array, position and element
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __set $ARRAY $POS $EL
#
function __set() {
    if [[ ! "$1" =~ ^[a-zA-Z_]+[a-zA-Z0-9_]*$ ]]; 
        printf "%s\n" "Invalid bash variable"
        LOG[MSG]="Invalid bash variable"
        __logging $LOG
        return $NOT_SUCCESS
    fi
    declare -p "$1" > /dev/null 2>&1
    if [[ $? -eq 1 ]]; then
        printf "%s\n" "Bash variable [${1}] doesn't exist"
        LOG[MSG]="Bash variable [${1}] doesn't exist"
        __logging $LOG
        return $NOT_SUCCESS
    fi
    eval ${1}[${2}]=\${3}
}

#
# @brief Get the array content ${array[@]}
# @param Value required array
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __get $ARRAY
#
function __get() {
    if [[ ! "$1" =~ ^[a-zA-Z_]+[a-zA-Z0-9_]*$ ]]; then 
        printf "%s\n" "Invalid bash variable"
        LOG[MSG]="Invalid bash variable"
        __logging $LOG
        return $NOT_SUCCESS
    fi
    declare -p "$1" > /dev/null 2>&1
    if [[ $? -eq 1 ]]; then 
        printf "%s\n" "Bash variable [${1}] doesn't exist"
        LOG[MSG]="Bash variable [${1}] doesn't exist"
        __logging $LOG
        return $NOT_SUCCESS
    fi
    eval echo \${${1}[@]}
}

#
# @brief Get the value stored at a specific index eg. ${array[0]} 
# @param Value required array and index
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __at $ARRAY $INDEX
# 
function __at() {
    if [[ ! "$1" =~ ^[a-zA-Z_]+[a-zA-Z0-9_]*$ ]]; then
        printf "%s\n" "Invalid bash variable"
        LOG[MSG]="Invalid bash variable"
        __logging $LOG
        return $NOT_SUCCESS
    fi
    declare -p "$1" > /dev/null 2>&1
    if [[ $? -eq 1 ]]; then
        printf "%s\n" "Bash variable [${1}] doesn't exist"
        LOG[MSG]="Bash variable [${1}] doesn't exist"
        __logging $LOG
        return $NOT_SUCCESS
    fi
    if [[ ! "$2" =~ ^(0|[-]?[1-9]+[0-9]*)$ ]]; then
        printf "%s\n" "Array index must be a number"
    fi
    local v=$1
    local i=$2
    local max=$(eval echo \${\#${1}[@]})
    if [[ $max -gt 0 && $i -ge 0 && $i -lt $max ]]; then 
        eval echo \${$v[$i]}
    fi
}

#
# @brief Get length of array
# @param Value required array
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __count $ARRAY
#
function __count() {
    if [[ ! "$1" =~ ^[a-zA-Z_]+[a-zA-Z0-9_]*$ ]]; then 
        printf "%s\n" "Invalid bash variable "
        LOG[MSG]="Invalid bash variable"
        __logging $LOG
        return $NOT_SUCCESS
    fi
    declare -p "$1" > /dev/null 2>&1
    if [[ $? -eq 1 ]]; then
        printf "%s\n" "Bash variable [${1}] doesn't exist"
        LOG[MSG]="Bash variable [${1}] doesn't exist"
        __logging $LOG
        return $NOT_SUCCESS
    fi
    local v=${1}
    eval echo \${\#${1}[@]}
} 
