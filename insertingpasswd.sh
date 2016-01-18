#!/bin/bash
#
# @brief   Inserting password
# @version ver.1.0
# @date    Mon Jul 15 21:44:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#

SUCCESS=0
NOT_SUCCESS=1

#
# @brief Inserting password
# @argument Value required password variable
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __insertingpasswd PASSWD
# STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#	# true
# else
#	# false
# fi
#
function __insertingpasswd() {
	PASSWD="$1"
	TMP_PASSWD=""
	stty -echo
	printf "%s" "Enter password: "
	read TMP_PASSWD
	eval "$PASSWD=$TMP_PASSWD"
	stty echo
	if [ -n "$PASSWD" ]; then
		return $SUCCESS
	fi
	return $NOT_SUCCESS
}
