#!/bin/bash
#
# @brief   Add info for new tool, at tool location
# @version ver.1.0
# @date    Mon Jul 15 21:44:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_NAME=addnewtool
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/logging.sh
. $UTIL/bin/devel.sh

declare -A TOOL_USAGE=(
    [TOOL_NAME]="__$UTIL_NAME"
    [ARG1]="[TOOL_NAME] Name of App/Tool/Script"
    [EX-PRE]="# Example adding info for Thunderbird"
    [EX]="__$UTIL_NAME thunderbird"	
)

declare -A LOG=(
    [TOOL]="$UTIL_NAME"
    [FLAG]="error"
    [PATH]="$UTIL_LOG"
    [MSG]=""
)

IT_TOOLS=/opt
COMPANY=company

#
# @brief  Create file-structure-support for new App/Tool/Script
# @param  Value required name of App/Tool/Script
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __addnewtool "$TOOL_NAME"
# STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
# else
#   # false
# fi
#
function __addnewtool() {
    TOOL_NAME=$1
    if [ -n "$TOOL_NAME" ]; then
        TOOL_DIR=$IT_TOOLS/$TOOL_NAME
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n" "[Add $TOOL_NAME to [$IT_TOOLS/]]"
        	printf "%s" "Checking tool directory "
		fi
        if [ ! -d "$TOOL_DIR/" ]; then 
			if [ "$TOOL_DEBUG" == "true" ]; then
		        printf "%s" "[not exist]"
		        printf "%s\n" "Creating tool directory [$TOOL_DIR/]"
			fi
            mkdir  "$TOOL_DIR/"
            DATE=$(date +"%m-%d-%Y")
			if [ "$TOOL_DEBUG" == "true" ]; then
		    	printf "%s\n" "Creating file [$TOOL_DIR/$TOOL_NAME-info.txt]"
			fi
            cat <<EOF>>"$TOOL_DIR/$TOOL_NAME-info.txt"

################################################################
#
# $TOOL_NAME Info
# $COMPANY $DATE
#
################################################################

EOF
			if [ "$TOOL_DEBUG" == "true" ]; then
		    	printf "%s\n" "Creating file [$TOOL_DIR/$TOOL_NAME-install-manual.txt]"
			fi
            cat <<EOF>>"$TOOL_DIR/$TOOL_NAME-install-manual.txt"

################################################################
#
# $TOOL_NAME Install Manual
# $COMPANY $DATE
#
################################################################

EOF
			if [ "$TOOL_DEBUG" == "true" ]; then
		    	printf "%s\n" "Creating file [$TOOL_DIR/$TOOL_NAME-install-xtools.cfg]"
			fi
            cat <<EOF>>"$TOOL_DIR/$TOOL_NAME-install-xtools.cfg"

################################################################
#
# $TOOL_NAME Install xtools
# NS Frobas IT $DATE
#
################################################################

EOF
			if [ "$TOOL_DEBUG" == "true" ]; then
            	printf "%s\n" "Set owner"
			fi
            chown -R root.root "$TOOL_DIR/"
			if [ "$TOOL_DEBUG" == "true" ]; then            
				printf "%s\n" "Set permission"
			fi
            chmod -R 770 "$TOOL_DIR/"
			if [ "$TOOL_DEBUG" == "true" ]; then            
				printf "%s\n\n" "[Done]"
			fi
            return $SUCCESS
        else
			if [ "$TOOL_DEBUG" == "true" ]; then
            	printf "%s\n\n" "[already exist]"
			fi
            LOG[MSG]="App/Tool/Script already exist"
            __logging $LOG
            return $NOT_SUCCESS
        fi
    fi 
    __usage $TOOL_USAGE
    return $NOT_SUCCESS
}

