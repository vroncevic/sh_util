#!/bin/bash
#
# @brief   Display ms word doc file in ascii format
# @version ver.1.0
# @date    Fri Oct 02 09:59:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
TOOL_NAME=word2txt
TOOL_VERSION=ver.1.0
TOOL_EXECUTABLE="${BASH_SOURCE[0]}"
TOOL_BIN=`dirname $TOOL_EXECUTABLE`
TOOL_HOME=`dirname $TOOL_BIN`
TOOL_LOG=$TOOL_HOME/log

. $TOOL_BIN/usage.sh
. $TOOL_BIN/logging.sh
. $TOOL_BIN/checktool.sh

SUCCESS=0
NOT_SUCCESS=1

declare -A TOOL_USAGE=(
    [TOOL_NAME]="__$TOOL"
    [ARG1]="[DOC_FILE] Name of Document to be extracted"
    [EX-PRE]="# Display ms word doc file in ascii format"
    [EX]="__$TOOL test.doc"	
)

declare -A LOG=(
    [TOOL]="$TOOL_NAME"
    [FLAG]="error"
    [PATH]="$TOOL_LOG"
    [MSG]=""
)

#
# @brief Display ms word doc file in ascii format
# @argument Value required name of document file
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __word2txt $DOC_FILE
# STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#	# true
# else
#	# false
# fi
#
function __word2txt() {
    DOC_FILES=$@
    if [ -n "$DOC_FILES" ]; then
        __checktool "/usr/bin/catdoc"
        CHECK_TOOL=$?
        if [ $CHECK_TOOL -eq $SUCCESS ]; then
            printf "%s\n" "Extracting doc file $DOC_FILES..."
            for a in $DOC_FILES
            do
                catdoc -b -s cp1252 -d 8859-1 -a $DOC_FILES
            done 
            printf "%s\n" "Done..."
            return $SUCCESS
        fi
        return $NOT_SUCCESS
    fi
    __usage $TOOL_USAGE
    LOG[MSG]="Missing argument"
    __logging $LOG
    return $NOT_SUCCESS
}
