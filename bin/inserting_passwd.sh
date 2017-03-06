#!/bin/bash
#
# @brief   Inserting password
# @version ver.1.0
# @date    Mon Jul 15 21:44:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_INSERTING_PASSWD=inserting_passwd
UTIL_INSERTING_PASSWD_VERSION=ver.1.0
UTIL=/root/scripts/sh_util/${UTIL_INSERTING_PASSWD_VERSION}
UTIL_LOG=${UTIL}/log

.	${UTIL}/bin/devel.sh

#
# @brief  Inserting password
# @param  Value required password variable
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __inserting_passwd "$PASSWD"
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#	# true
#	# notify admin | user
# else
#	# false
#	# missing argument
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __inserting_passwd() {
	local PASSWD=$1 TMP_PASSWD="None" MSG="None" FUNC=${FUNCNAME[0]}
	stty -echo
	printf "%s" "Enter password: "
	read TMP_PASSWD
	eval "PASSWD=$(printf "'%s' " "${TMP_PASSWD}")"
	stty echo
	if [ -n "${PASSWD}" ]; then
		__info_debug_message_end "Done" "$FUNC" "$UTIL_INSERTING_PASSWD"
		return $SUCCESS
	fi
	MSG="Empty password not allowed!"
	__info_debug_message "$MSG" "$FUNC" "$UTIL_INSERTING_PASSWD"
	MSG="Force exit!"
	__info_debug_message_end "$MSG" "$FUNC" "$UTIL_INSERTING_PASSWD"
	return $NOT_SUCCESS
}

