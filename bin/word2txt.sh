#!/bin/bash
#
# @brief   Display ms word doc file in ascii format
# @version ver.1.0
# @date    Fri Oct 02 09:59:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_WORD2TXT=word2txt
UTIL_WORD2TXT_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_WORD2TXT_VERSION
UTIL_WORD2TXT_CFG=$UTIL/conf/$UTIL_WORD2TXT.cfg
UTIL_LOG=$UTIL/log

. $UTIL/bin/loadutilconf.sh
. $UTIL/bin/usage.sh
. $UTIL/bin/checktool.sh
. $UTIL/bin/devel.sh

declare -A WORD2TXT_USAGE=(
    [TOOL]="__$UTIL_WORD2TXT"
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
# if [ $STATUS -eq $SUCCESS ]; then
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
		declare -A configword2txtutil=()
		__loadutilconf "$UTIL_APPSHORTCUT_CFG" configword2txtutil
		local STATUS=$?
		if [ $STATUS -eq $SUCCESS ]; then
			local catdoc=${configword2txtutil[CAT_DOC]}
		    __checktool "$catdoc"
		    STATUS=$?
		    if [ $STATUS -eq $SUCCESS ]; then
				if [ "$TOOL_DBG" == "true" ]; then
		        	MSG="Extracting doc file [$DOC_FILES]"
					printf "$DSTA" "$UTIL_WORD2TXT" "$FUNC" "$MSG"
				fi
		        for a in $DOC_FILES
		        do
		            if [ -f "$a" ]; then
		                eval "$catdoc -b -s cp1252 -d 8859-1 -a $a"
		            else
						MSG="Please check file [$a]"
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
		return $NOT_SUCCESS
    fi
    __usage $WORD2TXT_USAGE
    return $NOT_SUCCESS
}

