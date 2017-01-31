#!/bin/bash
#
# @brief   Copy new App shortcut to user configuration spot
# @version ver.1.0
# @date    Mon Jul 15 17:43:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_APP_TO_USER=app_to_user
UTIL_APP_TO_USER_VERSION=ver.1.0
UTIL=/root/scripts/sh_util/${UTIL_APP_TO_USER_VERSION}
UTIL_APP_TO_USER_CFG=${UTIL}/conf/${UTIL_APP_TO_USER}.cfg
UTIL_LOG=${UTIL}/log

.	${UTIL}/bin/usage.sh
.	${UTIL}/bin/load_util_conf.sh
.	${UTIL}/bin/devel.sh

declare -A APP_TO_USER_USAGE=(
	[USAGE_TOOL]="__${UTIL_APP_TO_USER}"
	[USAGE_ARG1]="[APP_STRUCT] username, group, app"
	[USAGE_EX_PRE]="# Copy Application shortcut to user configuration"
	[USAGE_EX]="__${UTIL_APP_TO_USER} \$APP_STRUCT"
)

#
# @brief  Copy new App shortcut to user configuration spot
# @param  Value required structure (username, group, app)
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# declare -A APP_STRUCT=(
#	[UN]="vroncevic"
#	[DN]="vroncevic"
#	[AN]="wolan"
# )
#
# __app_to_user APP_STRUCT
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#	# true
#	# notify admin | user
# else
#	# false
#	# missing argument | check dir | already exist
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __app_to_user() {
	local -n APP_STRUCT=$1
	local USER=${APP_STRUCT[UN]} DEP=${APP_STRUCT[DN]} ANAME=${APP_STRUCT[AN]}
	if [[ -n "${USER}" && -n "${DEP}" && -n "${ANAME}" ]]; then
		local FUNC=${FUNCNAME[0]} MSG="None" STATUS
		declare -A config_app_to_user=()
		__load_util_conf "$UTIL_APP_TO_USER_CFG" config_app_to_user
		STATUS=$?
		if [ $STATUS -eq $SUCCESS ]; then
			local APPSHORTCUTDIR=${config_app_to_user[APPLICATION_SHORTCUT]}
			MSG="Checking schortcut directory [${APPSHORTCUTDIR}/]?"
			__info_debug_message_que "$MSG" "$FUNC" "$UTIL_APP_TO_USER"
			if [ -d "${APPSHORTCUTDIR}/" ]; then
				MSG="[ok]"
				__info_debug_message_ans "$MSG" "$FUNC" "$UTIL_APP_TO_USER"
				local HOMEAPPDIR="/home/${USER}/.local/share/applications"
				MSG="Checking App configuration directory [${HOMEAPPDIR}/]?"
				__info_debug_message_que "$MSG" "$FUNC" "$UTIL_APP_TO_USER"
				if [ ! -d "${HOMEAPPDIR}/" ]; then
					MSG="[not exist]"
					__info_debug_message_ans "$MSG" "$FUNC" "$UTIL_APP_TO_USER"
					MSG="Creating local share application directory!"
					__info_debug_message "$MSG" "$FUNC" "$UTIL_APP_TO_USER"
					mkdir "${HOMEAPPDIR}/"
					MSG="Set owner!"
					__info_debug_message "$MSG" "$FUNC" "$UTIL_APP_TO_USER"
					eval "chown -R ${USER}.${DEP} ${HOMEAPPDIR}/"
					MSG="Set permission!"
					__info_debug_message "$MSG" "$FUNC" "$UTIL_APP_TO_USER"
					chmod -R 700 "${HOMEAPPDIR}/"
				else
					MSG="[exist]"
					__info_debug_message_ans "$MSG" "$FUNC" "$UTIL_APP_TO_USER"
				fi
				local APPSHORTCUT="${HOMEAPPDIR}/${ANAME}.desktop"
				MSG="Checking App shortcut [${APPSHORTCUT}]?"
				__info_debug_message_que "$MSG" "$FUNC" "$UTIL_APP_TO_USER"
				if [ ! -e "${APPSHORTCUT}" ]; then
					MSG="[ok]"
					__info_debug_message_ans "$MSG" "$FUNC" "$UTIL_APP_TO_USER"
					MSG="Generating App shortcut [${APPSHORTCUT}]!"
					__info_debug_message "$MSG" "$FUNC" "$UTIL_APP_TO_USER"
					eval "cp ${APPSHORTCUTDIR}/${ANAME}.desktop ${APPSHORTCUT}"
					MSG="Set owner!"
					__info_debug_message "$MSG" "$FUNC" "$UTIL_APP_TO_USER"
					eval "chown ${USER}.${DEP} ${APPSHORTCUT}"
					MSG="Set permission!"
					__info_debug_message "$MSG" "$FUNC" "$UTIL_APP_TO_USER"
					eval "chmod 700 ${APPSHORTCUT}"
					__info_debug_message_end "Done" "$FUNC" "$UTIL_APP_TO_USER"
					return $SUCCESS
				fi
				MSG="[already exist]"
				__info_debug_message_ans "$MSG" "$FUNC" "$UTIL_APP_TO_USER"
				MSG="Force exit!"
				__info_debug_message_end "$MSG" "$FUNC" "$UTIL_APP_TO_USER"
				return $NOT_SUCCESS
			fi
			MSG="[not ok]"
			__info_debug_message_ans "$MSG" "$FUNC" "$UTIL_APP_TO_USER"
			MSG="Please check directory [${APPSHORTCUTDIR}/]!"
			__info_debug_message "$MSG" "$FUNC" "$UTIL_APP_TO_USER"
			MSG="Force exit!"
			__info_debug_message_end "$MSG" "$FUNC" "$UTIL_APP_TO_USER"
			return $NOT_SUCCESS
		fi
		MSG="Force exit!"
		__info_debug_message_end "$MSG" "$FUNC" "$UTIL_APP_TO_USER"
		return $NOT_SUCCESS
	fi
	__usage APP_TO_USER_USAGE
	return $NOT_SUCCESS
}

