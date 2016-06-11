#!/bin/bash
#
# @brief   Display ms word doc file in ascii format
# @version ver.1.0
# @date    Fri Oct 02 09:59:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_WORD2TXT=word2txt
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/checktool.sh
. $UTIL/bin/devel.sh

declare -A WORD2TXT_USAGE=(
    [TOOL_NAME]="__$UTIL_WORD2TXT"
    [ARG1]="[DOC_FILE] Name of Document to be extracted"
    [EX-PRE]="# Display ms word doc file in ascii format"
    [EX]="__$UTIL_WORD2TXT test.doc"	
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
# local STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
#   # notify admin | user
# else
#   # false
#   # missing argument | missing tool
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __word2txt() {
    local DOC_FILES=$@
    if [ -n "$DOC_FILES" ]; then
		local FUNC=${FUNCNAME[0]}
		local MSG=""
		local CAT_DOC="/usr/bin/catdoc"
        __checktool "$CAT_DOC"
        local STATUS=$?
        if [ "$STATUS" -eq "$SUCCESS" ]; then
			if [ "$TOOL_DBG" == "true" ]; then
            	MSG="Extracting doc file [$DOC_FILES]"
				printf "$DSTA" "$UTIL_WORD2TXT" "$FUNC" "$MSG"
			fi
            for a in $DOC_FILES
            do
                if [ -f "$a" ]; then
                    eval "$CAT_DOC -b -s cp1252 -d 8859-1 -a $a"
                else
					MSG="Check file [$a]"
					printf "$SEND" "$UTIL_WORD2TXT" "$MSG"
                fi
            done
			if [ "$TOOL_DBG" == "true" ]; then 
            	printf "$DEND" "$UTIL_WORD2TXT" "$FUNC" "Done"
			fi
            return $SUCCESS
        fi
        return $NOT_SUCCESS
    fi
    __usage $WORD2TXT_USAGE
    return $NOT_SUCCESS
}
