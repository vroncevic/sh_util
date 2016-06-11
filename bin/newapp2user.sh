#!/bin/bash
#
# @brief   Copy new APP shortcut to user configuration
# @version ver.1.0
# @date    Mon Jul 15 17:43:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_APP2USER=newapp2user
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
UTIL_CFG_NEWAPP2USER=$UTIL/conf/$UTIL_APP2USER.cfg
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/loadutilconf.sh
. $UTIL/bin/devel.sh

declare -A NEWAPP2USER_USAGE=(
    [TOOL_NAME]="__$UTIL_APP2USER"
    [ARG1]="[NEW_APP_STRUCTURE] username, group, app"
    [EX-PRE]="# Copy Application shortcut to user configuration"
    [EX]="__$UTIL_APP2USER \$NEW_APP_STRUCTURE"
)

#
# @brief  Generating App shortcut
# @param  Value required structure (username, group, app)
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# declare -A NEW_APP_STRUCTURE=()
# NEW_APP_STRUCTURE[UN]="vroncevic"
# NEW_APP_STRUCTURE[DN]="users"
# NEW_APP_STRUCTURE[AN]="wolan"
#
# __newapp2user $NEW_APP_STRUCTURE
# local STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
#   # notify admin | user
# else
#   # false
#   # missing argument | check dir | already exist
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __newapp2user() {
    local NEW_APP_STRUCTURE=$1
    local USERNAME=${NEW_APP_STRUCTURE[UN]}
    local DEPARTMENT=${NEW_APP_STRUCTURE[DN]}
    local APPNAME=${NEW_APP_STRUCTURE[AN]}
    if [ -n "$USERNAME" ] && [ -n "$DEPARTMENT" ] && [ -n "$APPNAME" ]; then
		local FUNC=${FUNCNAME[0]}
		local MSG=""
		declare -A cfgnewapp2user=()
		__loadutilconf "$UTIL_CFG_NEWAPP2USER" cfgnewapp2user
		local STATUS=$?
		if [ "$STATUS" -eq "$SUCCESS" ]; then
			if [ "$TOOL_DBG" == "true" ]; then
				MSG="Checking schortcut dir"
				printf "$DQUE" "$UTIL_APP2USER" "$FUNC" "$MSG"
			fi
			if [ -d "$cfgnewapp2user[APPLICATION_SHORTCUT]/" ]; then
				local HOME_APP_DIR="/home/$USERNAME/.local/share/applications"
				if [ "$TOOL_DBG" == "true" ]; then
					MSG="Checking App configuration dir"
					printf "$DQUE" "$UTIL_APP2USER" "$FUNC" "$MSG"
				fi
				if [ ! -d "$HOME_APP_DIR/" ]; then
					if [ "$TOOL_DBG" == "true" ]; then
						printf "%s\n" "[not exist]"
						MSG="Create local share application directory"
						printf "$DSTA" "$UTIL_APP2USER" "$FUNC" "$MSG"
					fi
					mkdir "$HOME_APP_DIR/"
					if [ "$TOOL_DBG" == "true" ]; then                
						printf "$DSTA" "$UTIL_APP2USER" "$FUNC" "Set owner"
					fi
					chown -R "$USERNAME.$DEPARTMENT" "$HOME_APP_DIR/"
					if [ "$TOOL_DBG" == "true" ]; then                
						printf "$DSTA" "$UTIL_APP2USER" "$FUNC" "Set permission"
					fi
					chmod -R 700 "/$HOME_APP_DIR/"
				fi
				local APP_SHORTCUT_DESK="$APPLICATION_SHORTCUT/$APPNAME.desktop"
				if [ ! -e "$APP_SHORTCUT_DESK" ]; then
					local APP_DESKTOP="$HOME_APP_DIR/$APPNAME.desktop"
					if [ "$TOOL_DBG" == "true" ]; then
						printf "%s\n" "[ok]"
						MSG="Generating App config file [$APP_DESKTOP]"
						printf "$DSTA" "$UTIL_APP2USER" "$FUNC" "$MSG"
					fi
					cp "$APP_SHORTCUT_DESK" "$HOME_APP_DIR/"
					if [ "$TOOL_DBG" == "true" ]; then                
						printf "$DSTA" "$UTIL_APP2USER" "$FUNC" "Set owner"
					fi
					chown "$USERNAME.$DEPARTMENT" "$APP_DESKTOP"
					if [ "$TOOL_DBG" == "true" ]; then                
						printf "$DSTA" "$UTIL_APP2USER" "$FUNC" "Set permission"
					fi
					chmod 700 "$APP_DESKTOP"
					if [ "$TOOL_DBG" == "true" ]; then                
						printf "$DEND" "$UTIL_APP2USER" "$FUNC" "Done"
					fi
					return $SUCCESS
				fi
				MSG="App shortcut [$APP_SHORTCUT_DESK] already exist"
				printf "$SEND" "$UTIL_APP2USER" "$MSG"
				return $NOT_SUCCESS
			fi
			MSG="Check directory [$APPLICATION_SHORTCUT]"
			printf "$SEND" "$UTIL_APP2USER" "$MSG"
			return $NOT_SUCCESS
        fi
        return $NOT_SUCCESS
    fi 
    __usage $NEWAPP2USER_USAGE
    return $NOT_SUCCESS
}
