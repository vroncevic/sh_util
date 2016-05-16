#!/bin/bash
#
# @brief   Generating application shortcut
# @version ver.1.0
# @date    Thu Aug  11 09:58:41 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
# 
UTIL_NAME=appshortcut
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/logging.sh
. $UTIL/bin/devel.sh

declare -A TOOL_USAGE=(
    [TOOL_NAME]="__$UTIL_NAME"
    [ARG1]="[APP_STRUCTURE] App name and description"
    [EX-PRE]="# Example generating WoLAN shortcut"
    [EX]="__$UTIL_NAME wolan \"WOL Software System\""	
)

declare -A LOG=(
    [TOOL]="$UTIL_NAME"
    [FLAG]="error"
    [PATH]="$UTIL_LOG"
    [MSG]=""
)

APPLICATION_SHORTCUT=/opt

#
# @brief  Generate App shortcut
# @param  Value required App structure (name and description)
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# APP_STRUCTURE[AN]="WoLAN"
# APP_STRUCTURE[AD]="WOL Software System"
#
# __appchortcut $APP_STRUCTURE
# STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
# else
#   # false
# fi
#
function __appshortcut() {
	APP_STRUCTURE=$1
    APPNAME=${APP_STRUCTURE[AN]}
    APPDESCRIPTION=${APP_STRUCTURE[AD]}
    if [ -n "$APPNAME" ] && [ -n "$APPDESCRIPTION" ]; then
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n" "[Generating shortcut $APPNAME.desktop]"
        	printf "%s" "Checking App shortcut "
		fi
        if [ ! -e "$APPLICATION_SHORTCUT/$APPNAME.desktop" ]; then
			if [ "$TOOL_DEBUG" == "true" ]; then
		        printf "%s\n" "[not exist]"
		        printf "%s\n" "Creating file [$APPNAME.desktop]"
			fi
            cat <<EOF>>"$APPLICATION_SHORTCUT/$APPNAME.desktop"
#
# NS Frobas IT
# Shortcut for $APPNAME
#
[Desktop Entry]
Comment=$APPDESCRIPTION
Exec=/opt/apps/bin/$APPNAME
Icon=/opt/apps/icons/$APPNAME.png
Name=$APPNAME
NoDisplay=false
Path=
StartupNotify=true
Terminal=0
TerminalOptions=
Type=Application
X-KDE-SubstituteUID=false
X-KDE-Username=
EOF
			if [ "$TOOL_DEBUG" == "true" ]; then
            	printf "%s\n" "Set permission"
			fi
            chmod 755 "$APPLICATION_SHORTCUT/$APPNAME.desktop"
			if [ "$TOOL_DEBUG" == "true" ]; then
				printf "%s\n\n" "[Done]"
			fi
            return $SUCCESS
        else
			LOG[MSG]="Shortcut already exist"
			if [ "$TOOL_DEBUG" == "true" ]; then
				printf "%s\n\n" "[already exist]"
			fi
            __logging $LOG
            return $NOT_SUCCESS
        fi
    fi
    __usage $TOOL_USAGE
    return $NOT_SUCCESS
}

