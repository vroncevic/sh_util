#!/bin/bash
#
# @brief   Copy file structure of TOOL to server
# @version ver.1.0
# @date    Mon Jun 01 18:36:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
TOOL_NAME=xcopy
TOOL_VERSION=ver.1.0
TOOL_EXECUTABLE="${BASH_SOURCE[0]}"
TOOL_BIN=`dirname $TOOL_EXECUTABLE`
TOOL_HOME=`dirname $TOOL_BIN`
TOOL_LOG=$TOOL_HOME/log

. $TOOL_BIN/usage.sh
. $TOOL_BIN/logging.sh

SUCCESS=0
NOT_SUCCESS=1

declare -A TOOL_USAGE=(
    [TOOL_NAME]="__$TOOL_NAME"
    [ARG1]="[TOOL_NAME]  Name of TOOL project"
    [ARG2]="[VERSION]    Version number: 1, 2, 3..."
    [ARG3]="[APP_PATH]   Absolute path of final destination"
    [ARG4]="[DEV_PATH]   Absolute project-path of development directory"
    [EX-PRE]="# Example copy App/Tool/Script file structure"
    [EX]="__$TOOL_NAME wolan 1 /app-path/ /dev-path/"	
)

declare -A LOG=(
    [TOOL]="$TOOL_NAME"
    [FLAG]="error"
    [PATH]="$TOOL_LOG"
    [MSG]=""
)

#
# @brief Copy file structure of TOOL to /data/apps
# @params Values required tool name, versnio, app path and dev path
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __xcopy wolan 1 /app-path/ /dev-path/
# STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#	# true
# else
#	# false
# fi
#
function __xcopy() {
    TOOL_NAME=$1
    VERSION=ver.$2.0
    APP_PATH=$3
    DEV_PATH=$4
    if [ -n "$TOOL_NAME" ] && [ -n "$VERSION" ] && [ -n "$APP_PATH" ] && [ -n "$DEV_PATH" ]; then
        printf "%s\n" "Tool [$TOOL_NAME] version [$VERSION] check file structure [$APP_PATH]"
        if [ -d "$APP_PATH" ]; then
            printf "%s\n" "Tool HOME directory [$APP_PATH] exist..."
        else 
            mkdir "$APP_PATH/"
            printf "%s\n" "Created tool HOME directory [$APP_PATH]"
        fi
        if [ -d "$DEV_PATH" ]; then   
            if [ -d "$APP_PATH/$VERSION/" ]; then
                    printf "%s\n" "Clean directory [$APP_PATH/$VERSION/]"
                    rm -rf "$APP_PATH/$VERSION/"
            else 
                    printf "%s\n" "Nothing to clean..."
            fi
            printf "%s\n" "Copy TOOL to destination: [$APP_PATH/]"
            cp -R "$DEV_PATH/dist/$VERSION" "$APP_PATH/"
            return $SUCCESS
        else
            printf "%s\n" "Check directory [$DEV_PATH/dist/$VERSION/] exist ?"	
            return $NOT_SUCCESS
        fi
    fi
    __usage $TOOL_USAGE
    LOG[MSG]="Missing argument"
    __logging $LOG
    return $NOT_SUCCESS
}
