#!/bin/bash
#
# @brief   Cut select pages from a pdf file, and create a new file
# @version ver.1.0
# @date    Fri Okt 02 09:59:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_CUTPDF=cutpdf
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/checktool.sh
. $UTIL/bin/usage.sh
. $UTIL/bin/devel.sh

declare -A CUTPDF_USAGE=(
    [TOOL_NAME]="__$UTIL_CUTPDF"
    [ARG1]="[TIME] Life time"
    [EX-PRE]="# Example running __$UTIL_CUTPDF"
    [EX]="__$UTIL_CUTPDF 5s"	
)

#
# @brief  Cut select pages from a pdf file, and create a new file
# @param  Value required pdf structure
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# declare -A PDF_STRUCTURE=()
# PDF_STRUCTURE[INPUT]="/opt/green.pdf"
# PDF_STRUCTURE[OUTPUT]="/opt/green_stripped.pdf"
# PDF_STRUCTURE[FP]="12"
# PDF_STRUCTURE[LP]="23"
#
# __cutpdf $PDF_STRUCTURE
# local STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
#	# notify admin | user
# else
#   # false
#	# missing argument | missing tool
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __cutpdf() {
    local PDF_STRUCTURE=$1
    local INPUT_PDF_FILE=${PDF_STRUCTURE[INPUT]}
    local OUTPUT_PDF_FILE=${PDF_STRUCTURE[OUTPUT]}
    local FIRST_PAGE_PDF=${PDF_STRUCTURE[FP]}
    local LAST_PAGE_PDF=${PDF_STRUCTURE[LP]}
    if [ -n "$INPUT_PDF_FILE" ] && [ -n "$OUTPUT_PDF_FILE" ] && 
       [ -n "$FIRST_PAGE_PDF" ] && [ -n "$LAST_PAGE_PDF" ]; then
		local FUNC=${FUNCNAME[0]}
		local MSG=""
		local PS2PDF="/usr/bin/ps2pdf"
		__checktool "$PS2PDF"
		local STATUS=$?
		if [ "$STATUS" -eq "$SUCCESS" ]; then
			if [ "$TOOL_DBG" == "true" ]; then
				MSG="Checking file [$INPUT_PDF_FILE]"
				printf "$DQUE" "$UTIL_CUTPDF" "$FUNC" "$MSG"
			fi  
			if [ -f "$INPUT_PDF_FILE" ];
				if [ "$TOOL_DBG" == "true" ]; then
					printf "%s\n" "[ok]"
					MSG="Cut pdf file [$INPUT_PDF_FILE]"
					printf "$DSTA" "$UTIL_CUTPDF" "$FUNC" "$MSG"
				fi  
				local FPAGE="-dFirstPage=$FIRST_PAGE_PDF"
				local LPAGE="-dLastPage=$LAST_PAGE_PDF"
				eval "$PS2PDF $FPAGE $LPAGE $INPUT_PDF_FILE $OUTPUT_PDF_FILE"
				if [ "$TOOL_DBG" == "true" ]; then
					printf "$DEND" "$UTIL_CUTPDF" "$FUNC" "Done"
				fi  
				return $SUCCESS
			fi
			if [ "$TOOL_DBG" == "true" ]; then
				printf "%s\n" "[not ok]"
			fi
			MSG="Please check file [$INPUT_PDF_FILE]"
			printf "$SEND" "$UTIL_CUTPDF" "$MSG"
		fi
        return $NOT_SUCCESS
    fi
    __usage $CUTPDF_USAGE
    return $NOT_SUCCESS
}

