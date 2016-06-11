#!/bin/bash
#
# @brief   Load App/Tool/Script Configuration
# @version ver.1.0
# @date    Mon Sep 20 21:00:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_HASH=hash
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/devel.sh

#
# @brief  Set key, value to hash structure
# @params Values required hash structure, key and value  
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __hset $HASH_STRUCT $KEY $VALUE
#
function __hset() {
    eval "$1""$2"='$3'
}

#
# @brief  Get element from hash structure by key
# @params Values required key and hash structure
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# local ELEMENT_BY_KEY=$(__hget "Serbia" capitals)
# printf "%s\n" "$ELEMENT_BY_KEY"
#
function __hget() {
    eval echo '${'"$1$2"'#hash}'
}

#
# @brief  Set key and value to hash structure
# @params Values required key, value and hash structure
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __set_item $key $value $HASH_STRUCT
# local STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
#   # notif admin | user
# else
#   # false
#   # notify admin | user
# fi
#
function __set_item() {
	local KEY=$1
	local VALUE=$2
	local HASH_STRUCT=$3
	if [ -n "$KEY" ]  && [ -n "$VALUE" ]; then
		__hset $HASH_STRUCT $KEY $VALUE
		return $SUCCESS
	fi
	return $NOT_SUCCESS
}

#
# @brief  Get item from hash structure
# @params Values required key and config hash structure
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# local ELEMENT_BY_KEY=$(__get_item "Netherlands" capitals)
# printf "%s\n" "$ELEMENT_BY_KEY"
#
function __get_item() {
	local KEY=$1
	local HASH_STRUCT=$2
	local VALUE="None"
	if [ -n "$KEY" ]; then
		VALUE=$(__hget $HASH_STRUCT "$KEY")
	fi
	eval "echo "$VALUE""
}

#
# @brief  Load additional App/Tool/Script configuration from file
# @params Values required path to file and config hash structure
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# declare -A capitals=() 
# local HASH_STRUCTURE_CFG="`pwd`/hash_values.conf"
# __get_configuration $HASH_STRUCTURE_CFG capitals
# local STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
# 	 local ELEMENT_BY_KEY=$(__get_item "Netherlands" capitals)
#	 printf "%s\n" "$ELEMENT_BY_KEY"
#	 local ELEMENT_BY_KEY=$(__get_item "Serbia" capitals)
#	 printf "%s\n" "$ELEMENT_BY_KEY"
# fi
#
function __get_configuration() {
	local CFG_FILE=$1
	local HASH_STRUCT=$2
	if [ -n "$CFG_FILE" ] && [ -n "$HASH_STRUCT" ]; then
		IFS="="
		while read -r key value
		do
			__set_item $key $value $HASH_STRUCT
		done < $CFG_FILE
		return $SUCCESS
	fi
	return $NOT_SUCCESS
}
