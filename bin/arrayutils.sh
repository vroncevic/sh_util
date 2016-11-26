#!/bin/bash
#
# @brief   Array Utilities
# @version ver.1.0
# @date    Sun Oct 11 02:08:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_ARRAYLIST=arraylist
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/devel.sh

#
# @brief  Get the value stored at a specific index eg. ${array[0]} 
# @param  Value required array
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __arr $ARRAY
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#   # true
#   # notify admin | user
# else
#	# false
#	# failed to get element
#	# return $NOT_SUCCESS
#	# or 
#	# exit 128
# fi
#
function __arr() {
	local FUNC=${FUNCNAME[0]}
    if [[ ! "$1" =~ ^[a-zA-Z_]+[a-zA-Z0-9_]*$ ]]; then
		local MSG=""
		if [ "$TOOL_DBG" == "true" ]; then
			MSG="Invalid bash variable"
			printf "$DSTA" "$UTIL_ARRAYLIST" "$FUNC" "$MSG"
		fi
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
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __insert $ARRAY $EL
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#   # true
#   # notify admin | user
# else
#	# false
#	# failed to insert element
#	# return $NOT_SUCCESS
#	# or 
#	# exit 128
# fi
#
function __insert() {
	local FUNC=${FUNCNAME[0]}
	local MSG=""
    if [[ ! "$1" =~ ^[a-zA-Z_]+[a-zA-Z0-9_]*$ ]]; then
		if [ "$TOOL_DBG" == "true" ]; then
			MSG="Invalid bash variable"
			printf "$DSTA" "$UTIL_ARRAYLIST" "$FUNC" "$MSG"
		fi
        return $NOT_SUCCESS
    fi
    declare -p "$1" > /dev/null 2>&1
    if [[ $? -eq 1 ]]; then
		if [ "$TOOL_DBG" == "true" ]; then
        	MSG="Bash variable [${1}] doesn't exist"
			printf "$DSTA" "$UTIL_ARRAYLIST" "$FUNC" "$MSG"
		fi
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
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __set $ARRAY $POS $EL
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#   # true
#   # notify admin | user
# else
#	# false
#	# failed to update element
#	# return $NOT_SUCCESS
#	# or 
#	# exit 128
# fi
#
function __set() {
	local FUNC=${FUNCNAME[0]}
	local MSG=""
    if [[ ! "$1" =~ ^[a-zA-Z_]+[a-zA-Z0-9_]*$ ]]; 
		if [ "$TOOL_DBG" == "true" ]; then
        	MSG="Invalid bash variable"
			printf "$DSTA" "$UTIL_ARRAYLIST" "$FUNC" "$MSG"
		fi
        return $NOT_SUCCESS
    fi
    declare -p "$1" > /dev/null 2>&1
    if [[ $? -eq 1 ]]; then
		if [ "$TOOL_DBG" == "true" ]; then
        	MSG="Bash variable [${1}] doesn't exist"
			printf "$DSTA" "$UTIL_ARRAYLIST" "$FUNC" "$MSG" 
		fi       
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
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __get $ARRAY
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#   # true
#   # notify admin | user
# else
#	# false
#	# failed to get content of array
#	# return $NOT_SUCCESS
#	# or 
#	# exit 128
# fi
#
function __get() {
	local FUNC=${FUNCNAME[0]}
	local MSG=""
    if [[ ! "$1" =~ ^[a-zA-Z_]+[a-zA-Z0-9_]*$ ]]; then 
		if [ "$TOOL_DBG" == "true" ]; then
			MSG="Invalid bash variable"
			printf "$DSTA" "$UTIL_ARRAYLIST" "$FUNC" "$MSG"
		fi        
        return $NOT_SUCCESS
    fi
    declare -p "$1" > /dev/null 2>&1
    if [[ $? -eq 1 ]]; then 
		if [ "$TOOL_DBG" == "true" ]; then
        	MSG="Bash variable [${1}] doesn't exist"
			printf "$DSTA" "$UTIL_ARRAYLIST" "$FUNC" "$MSG"
		fi        
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
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __at $ARRAY $INDEX
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#   # true
#   # notify admin | user
# else
#	# false
#	# failed to get element
#	# return $NOT_SUCCESS
#	# or 
#	# exit 128
# fi
#
function __at() {
	local FUNC=${FUNCNAME[0]}
	local MSG=""
    if [[ ! "$1" =~ ^[a-zA-Z_]+[a-zA-Z0-9_]*$ ]]; then
		if [ "$TOOL_DBG" == "true" ]; then
        	MSG="Invalid bash variable"
			printf "$DSTA" "$UTIL_ARRAYLIST" "$FUNC" "$MSG"
		fi
        return $NOT_SUCCESS
    fi
    declare -p "$1" > /dev/null 2>&1
    if [[ $? -eq 1 ]]; then
		if [ "$TOOL_DBG" == "true" ]; then
        	MSG="Bash variable [${1}] doesn't exist"
			printf "$DSTA" "$UTIL_ARRAYLIST" "$FUNC" "$MSG"
		fi        
        return $NOT_SUCCESS
    fi
    if [[ ! "$2" =~ ^(0|[-]?[1-9]+[0-9]*)$ ]]; then
		if [ "$TOOL_DBG" == "true" ]; then
        	MSG="Array index must be a number"
			printf "$DSTA" "$UTIL_ARRAYLIST" "$FUNC" "$MSG"
		fi
    fi
    local v=$1
    local i=$2
    local max=$(eval echo \${\#${1}[@]})
    if [[ $max -gt 0 && $i -ge 0 && $i -lt $max ]]; then 
        eval echo \${$v[$i]}
    fi
}

#
# @brief  Get length of array
# @param  Value required array
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __count $ARRAY
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#   # true
#   # notify admin | user
# else
#	# false
#	# failed to get length of array
#	# return $NOT_SUCCESS
#	# or 
#	# exit 128
# fi
#
function __count() {
	local FUNC=${FUNCNAME[0]}
	local MSG=""
    if [[ ! "$1" =~ ^[a-zA-Z_]+[a-zA-Z0-9_]*$ ]]; then 
		if [ "$TOOL_DBG" == "true" ]; then
			MSG="Invalid bash variable"
			printf "$DSTA" "$UTIL_ARRAYLIST" "$FUNC" "$MSG"
		fi  
        return $NOT_SUCCESS
    fi
    declare -p "$1" > /dev/null 2>&1
    if [[ $? -eq 1 ]]; then
		if [ "$TOOL_DBG" == "true" ]; then
			MSG="Bash variable [${1}] doesn't exist"
			printf "$DSTA" "$UTIL_ARRAYLIST" "$FUNC" "$MSG"
		fi  
        return $NOT_SUCCESS
    fi
    local v=${1}
    eval echo \${\#${1}[@]}
}

