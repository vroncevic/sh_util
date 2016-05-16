#!/bin/bash
#
# @brief   Copy new APP shortcut to user configuration
# @version ver.1.0
# @date    Mon Jul 15 17:43:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_NAME=newapp2user
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/logging.sh
. $UTIL/bin/devel.sh

declare -A TOOL_USAGE=(
    [TOOL_NAME]="__$UTIL_NAME"
    [ARG1]="[NEW_APP_STRUCTURE] username, group, app"
    [EX-PRE]="# Copy Application shortcut to user configuration"
    [EX]="__$UTIL_NAME \$NEW_APP_STRUCTURE"	
)

declare -A LOG=(
    [TOOL]="$UTIL_NAME"
    [FLAG]="error"
    [PATH]="$UTIL_LOG"
    [MSG]=""
)

APPLICATION_SHORTCUT=/opt/shortcut

#
# @brief  Generating App shortcut
# @param  Value required structure (username, group, app)
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# NEW_APP_STRUCTURE[UN]="rmuller"
# NEW_APP_STRUCTURE[DN]="ds"
# NEW_APP_STRUCTURE[AN]="wolan"
#
# __newapp2user $NEW_APP_STRUCTURE
# STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
# else
#   # false
# fi
#
function __newapp2user() {
    NEW_APP_STRUCTURE=$1
    USERNAME=${NEW_APP_STRUCTURE[UN]}
    DEPARTMENT=${NEW_APP_STRUCTURE[DN]}
    APPNAME=${NEW_APP_STRUCTURE[AN]}
    if [ -n "$USERNAME" ] && [ -n "$DEPARTMENT" ] && [ -n "$APPNAME" ]; then
		if [ "$TOOL_DEBUG" == "true" ]; then
        	printf "%s\n" "[Generating App shortcut]"
		fi
        if [ -d "$APPLICATION_SHORTCUT" ]; then
			if [ "$TOOL_DEBUG" == "true" ]; then
            	printf "%s" "Checking App configuration dir "
			fi
            if [ ! -d "/home/$USERNAME/.local/share/applications/" ]; then
				if [ "$TOOL_DEBUG" == "true" ]; then
                	printf "%s\n" "[not exist]"
                	printf "%s\n" "Create local share application directory"
				fi
                mkdir "/home/$USERNAME/.local/share/applications/"
				if [ "$TOOL_DEBUG" == "true" ]; then                
					printf "%s\n" "Set owner"
				fi
                chown -R "$USERNAME.$DEPARTMENT" "/home/$USERNAME/.local/share/applications/"
				if [ "$TOOL_DEBUG" == "true" ]; then                
					printf "%s\n" "Set permission"
				fi
                chmod -R 700 "/home/$USERNAME/.local/share/applications/"
            fi
            if [ ! -e "$APPLICATION_SHORTCUT/$APPNAME.desktop" ]; then
				if [ "$TOOL_DEBUG" == "true" ]; then
                	printf "%s\n" "[ok]"
                	printf "%s\n" "Generating App config file [/home/$USERNAME/.local/share/applications/$APPNAME.desktop]"
				fi
                cp "$APPLICATION_SHORTCUT/$APPNAME.desktop"  "/home/$USERNAME/.local/share/applications/"
				if [ "$TOOL_DEBUG" == "true" ]; then                
					printf "%s\n" "Set owner"
				fi
                chown "$USERNAME.$DEPARTMENT" "/home/$USERNAME/.local/share/applications/$APPNAME.desktop"
				if [ "$TOOL_DEBUG" == "true" ]; then                
					printf "%s\n" "Set permission"
				fi
                chmod 700 "/home/$USERNAME/.local/share/applications/$APPNAME.desktop"
				if [ "$TOOL_DEBUG" == "true" ]; then                
					printf "%s\n\n" "[Done]"
				fi
                return $SUCCESS
            fi
			LOG[MSG]="Application shortcut [$APPLICATION_SHORTCUT/$APPNAME.desktop] already exist"
			if [ "$TOOL_DEBUG" == "true" ]; then
            	printf "%s\n\n" "[Error] ${LOG[MSG]}"
			fi            
            __logging $LOG
            return $NOT_SUCCESS
        fi
        LOG[MSG]="Check directory [$APPLICATION_SHORTCUT]"
		if [ "$TOOL_DEBUG" == "true" ]; then
        	printf "%s\n\n" "[Error] ${LOG[MSG]}"
		fi 
        __logging $LOG
        return $NOT_SUCCESS
    fi 
    __usage $TOOL_USAGE
    return $NOT_SUCCESS
}

