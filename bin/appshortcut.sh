#!/bin/bash
#
# @brief   Generating application shortcut
# @version ver.1.0
# @date    Thu Aug  11 09:58:41 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
# 
UTIL_APPSHORTCUT=appshortcut
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
UTIL_CFG_APPSHORTCUT=$UTIL/conf/$UTIL_APPSHORTCUT.cfg
UTIL_LOG=$UTIL/log

. $UTIL/bin/loadutilconf.sh
. $UTIL/bin/usage.sh
. $UTIL/bin/devel.sh

declare -A APPSHORTCUT_USAGE=(
    [TOOL_NAME]="__$UTIL_APPSHORTCUT"
    [ARG1]="[APP_STRUCTURE] App name and description"
    [EX-PRE]="# Example generating WoLAN shortcut"
    [EX]="__$UTIL_APPSHORTCUT wolan \"WOL Software System\""	
)

#
# @brief  Generating application shortcut
# @param  Value required app structure (name and description)
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# declare -A APP_STRUCTURE=()
# APP_STRUCTURE[AN]="WoLAN"
# APP_STRUCTURE[AD]="WOL Software System"
#
# __appchortcut $APP_STRUCTURE
# local STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
#	# notify admin | user 
# else
#   # false
#	# missing argument(s) | missing config file | failed to create shortcut
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __appshortcut() {
	local APP_STRUCTURE=$1
    local APPNAME=${APP_STRUCTURE[AN]}
    local APPDESCRIPTION=${APP_STRUCTURE[AD]}
    if [ -n "$APPNAME" ] && [ -n "$APPDESCRIPTION" ]; then
		local FUNC=${FUNCNAME[0]}
		local MSG=""
		declare -A cfgappshortcut=()
		__loadutilconf "$UTIL_CFG_APPSHORTCUT" cfgappshortcut
		local STATUS=$?
		if [ "$STATUS" -eq "$SUCCESS" ]; then
			local SHCUT="${cfgappshortcut[APP_SHORTCUT]}/${APPNAME}.desktop"
			if [ "$TOOL_DBG" == "true" ]; then
				MSG="Checking shortcut [$SHCUT]"
				printf "$DQUE" "$UTIL_APPSHORTCUT" "$FUNC" "$MSG"
			fi
			if [ ! -e "$SHCUT" ]; then
				if [ "$TOOL_DBG" == "true" ]; then
					printf "%s\n" "[not exist]"
					MSG="Creating [$SHCUT]"
					printf "$DSTA" "$UTIL_APPSHORTCUT" "$FUNC" "$MSG"
				fi
				local SHORTCUT_FILE="
#
# @tool    $APPNAME
# @company $UTIL_FROM_COMPANY
# @date    $DATE
# @brief   App shortcut
#
[Desktop Entry]
Comment=$APPDESCRIPTION
Exec=/data/apps/bin/$APPNAME
Icon=/data/apps/icons/$APPNAME.png
Name=$APPNAME
NoDisplay=false
Path=
StartupNotify=true
Terminal=0
TerminalOptions=
Type=Application
X-KDE-SubstituteUID=false
X-KDE-Username=
"
				echo -e "$SHORTCUT_FILE" >"$SHCUT"
				if [ "$TOOL_DBG" == "true" ]; then
					printf "$DSTA" "$UTIL_APPSHORTCUT" "$FUNC" "Set permission"
				fi
				chmod 755 "$SHCUT"
				if [ "$TOOL_DBG" == "true" ]; then
					printf "$DEND" "$UTIL_APPSHORTCUT" "$FUNC" "Done"
				fi
				return $SUCCESS
			fi
			if [ "$TOOL_DBG" == "true" ]; then
				printf "%s\n" "[already exist]"
			fi
			MSG="[$SHCUT] already exist"
			printf "$SEND" "$UTIL_APPSHORTCUT" "$MSG"
		fi
		return $NOT_SUCCESS
    fi
    __usage $APPSHORTCUT_USAGE
    return $NOT_SUCCESS
}

