#!/bin/bash
#
# @brief   Display ms word doc file in ascii format
# @version ver.1.0
# @date    Fri Oct 02 09:59:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_NAME=word2txt
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/logging.sh
. $UTIL/bin/checktool.sh
. $UTIL/bin/devel.sh

CAT_DOC="/usr/bin/catdoc"

declare -A TOOL_USAGE=(
    [TOOL_NAME]="__$UTIL_NAME"
    [ARG1]="[DOC_FILE] Name of Document to be extracted"
    [EX-PRE]="# Display ms word doc file in ascii format"
    [EX]="__$UTIL_NAME test.doc"	
)

declare -A LOG=(
    [TOOL]="$UTIL_NAME"
    [FLAG]="error"
    [PATH]="$UTIL_LOG"
    [MSG]=""
)

#
# @brief  Display ms word doc file in ascii format
# @param  Value required name of document file
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __word2txt "$DOC_FILE"
# STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
# else
#   # false
# fi
#
function __word2txt() {
    DOC_FILES=$@
    if [ -n "$DOC_FILES" ]; then
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n" "[Display ms word doc file in ascii format]"
		fi
        __checktool "$CAT_DOC"
        STATUS=$?
        if [ "$STATUS" -eq "$SUCCESS" ]; then
			if [ "$TOOL_DEBUG" == "true" ]; then
            	printf "%s\n" "Extracting doc file [$DOC_FILES]"
			fi
            for a in $DOC_FILES
            do
                if [ -f "$a" ]; then
                    catdoc -b -s cp1252 -d 8859-1 -a $a
                else
                    LOG[MSG]="Check file [$a]"
					if [ "$TOOL_DEBUG" == "true" ]; then
						printf "%s\n\n" "[Error] ${LOG[MSG]}"					
					fi
                    __logging $LOG
                fi
            done
			if [ "$TOOL_DEBUG" == "true" ]; then 
            	printf "%s\n\n" "[Done]"
			fi
            return $SUCCESS
        fi
        LOG[MSG]="Missing catdoc tool"
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n\n" "[Error] ${LOG[MSG]}"
		fi
        __logging $LOG
        return $NOT_SUCCESS
    fi
    __usage $TOOL_USAGE
    return $NOT_SUCCESS
}

