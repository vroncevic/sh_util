#!/bin/bash
#
# @brief   Generating App shortcut for KDE
# @version ver.1.0
# @date    Thu Aug  11 09:58:41 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
# 
UTIL_APP_SHORTCUT=app_shortcut
UTIL_APP_SHORTCUT_VERSION=ver.1.0
UTIL=/root/scripts/sh_util/${UTIL_APP_SHORTCUT_VERSION}
UTIL_APP_SHORTCUT_CFG=${UTIL}/conf/${UTIL_APP_SHORTCUT}.cfg
UTIL_LOG=${UTIL}/log

.	${UTIL}/bin/devel.sh
.	${UTIL}/bin/usage.sh
.	${UTIL}/bin/load_util_conf.sh

declare -A APP_SHORTCUT_USAGE=(
	[USAGE_TOOL]="__${UTIL_APP_SHORTCUT}"
	[USAGE_ARG1]="[APP_STRUCT] App name and description"
	[USAGE_EX_PRE]="# Example generating WoLAN shortcut"
	[USAGE_EX]="__${UTIL_APP_SHORTCUT} wolan \"WOL Software System\""
)

#
# @brief  Generating App shortcut for KDE
# @param  Value required app structure (name and description)
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# declare -A APP_STRUCT=(
#	[AN]="WoLAN"
#	[AD]="WOL Software System"
# )
#
# __app_shortcut APP_STRUCT
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#	# true
#	# notify admin | user 
# else
#	# false
#	# missing argument(s) | missing config file | failed to create shortcut
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __app_shortcut() {
	local -n APP_STRUCT=$1
	local APPNAME=${APP_STRUCT[AN]} APPDESCRIPT=${APP_STRUCT[AD]}
	if [[ -n "${APPNAME}" && -n "${APPDESCRIPT}" ]]; then
		local FUNC=${FUNCNAME[0]} MSG="None" STATUS
		declare -A config_app_shortcut=()
		__load_util_conf "$UTIL_APP_SHORTCUT_CFG" config_app_shortcut
		STATUS=$?
		if [ $STATUS -eq $SUCCESS ]; then
			local APPSHORTCUTDIR=${config_app_shortcut[APP_SHORTCUT]}
			MSG="Checking directory [${APPSHORTCUTDIR}/]?"
			__info_debug_message_que "$MSG" "$FUNC" "$UTIL_APP_SHORTCUT"
			if [ ! -d "${APPSHORTCUTDIR}/" ]; then
				MSG="[not ok]"
				__info_debug_message_ans "$MSG" "$FUNC" "$UTIL_APP_SHORTCUT"
				MSG="Create directory structure [${APPSHORTCUTDIR}/]!"
				__info_debug_message "$MSG" "$FUNC" "$UTIL_APP_SHORTCUT"
				MSG="Force exit!"
				__info_debug_message_end "$MSG" "$FUNC" "$UTIL_APP_SHORTCUT"
				return $NOT_SUCCESS
			fi
			MSG="[ok]"
			__info_debug_message_ans "$MSG" "$FUNC" "$UTIL_APP_SHORTCUT"
			local SHCUT="${APPSHORTCUTDIR}/${APPNAME}.desktop" SLINE HASH="#"
			MSG="Checking shortcut [${SHCUT}]?"
			__info_debug_message_que "$MSG" "$FUNC" "$UTIL_APP_SHORTCUT"
			if [ ! -e "${SHCUT}" ]; then
				MSG="[not exist]"
				__info_debug_message_ans "$MSG" "$FUNC" "$UTIL_APP_SHORTCUT"
				MSG="Creating shortcut [${SHCUT}]!"
				__info_debug_message "$MSG" "$FUNC" "$UTIL_APP_SHORTCUT"
				while read SLINE
				do
					eval echo "$SLINE" >> $SHCUT
				done < ${config_app_shortcut[APP_SHORTCUT_TEMPLATE]}
				MSG="Set permission!"
				__info_debug_message "$MSG" "$FUNC" "$UTIL_APP_SHORTCUT"
				eval "chmod 755 ${SHCUT}"
				__info_debug_message_end "Done" "$FUNC" "$UTIL_APP_SHORTCUT"
				return $SUCCESS
			fi
			MSG="[already exist]"
			__info_debug_message_ans "$MSG" "$FUNC" "$UTIL_APP_SHORTCUT"
			MSG="Force exit!"
			__info_debug_message_end "$MSG" "$FUNC" "$UTIL_APP_SHORTCUT"
			return $NOT_SUCCESS
		fi
		MSG="Force exit!"
		__info_debug_message_end "$MSG" "$FUNC" "$UTIL_APP_SHORTCUT"
		return $NOT_SUCCESS
	fi
	__usage APP_SHORTCUT_USAGE
	return $NOT_SUCCESS
}

