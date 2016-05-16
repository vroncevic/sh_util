#!/bin/bash
#
# @brief   Cut select pages from a pdf file, and create a new file from those pages
# @version ver.1.0
# @date    Fri Okt 02 09:59:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_NAME=cutpdf
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/logging.sh
. $UTIL/bin/devel.sh

declare -A TOOL_USAGE=(
    [TOOL_NAME]="__$UTIL_NAME"
    [ARG1]="[TIME] Life time"
    [EX-PRE]="# Example running __$UTIL_NAME"
    [EX]="__$UTIL_NAME 5s"	
)

declare -A LOG=(
    [TOOL]="$UTIL_NAME"
    [FLAG]="error"
    [PATH]="$UTIL_LOG"
    [MSG]=""
)

#
# @brief  Cut select pages from a pdf file, and create a new file from those pages
# @param  Value required pdf structure
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# PDF_STRUCTURE[INPUT]=$in_file
# PDF_STRUCTURE[OUTPUT]=$out_file
# PDF_STRUCTURE[FP]=$first_page
# PDF_STRUCTURE[LP]=$last_page
#
# __cutpdf $PDF_STRUCTURE
# STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
# else
#   # false
# fi
#
function __cutpdf() {
    PDF_STRUCTURE=$1
    INPUT_PDF_FILE=${PDF_STRUCTURE[INPUT]}
    OUTPUT_PDF_FILE=${PDF_STRUCTURE[OUTPUT]}
    FIRST_PAGE_PDF=${PDF_STRUCTURE[FP]}
    LAST_PAGE_PDF=${PDF_STRUCTURE[LP]}
    if [ -n "$INPUT_PDF_FILE" ] && [ -n "$OUTPUT_PDF_FILE" ] && 
       [ -n "$FIRST_PAGE_PDF" ] && [ -n "$LAST_PAGE_PDF" ]; then
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n" "[Cut select pages from a pdf file, and create a new file]"
        	printf "%s" "Checking file [$INPUT_PDF_FILE] "
		fi  
        if [ -f "$INPUT_PDF_FILE" ];
			if [ "$TOOL_DEBUG" == "true" ]; then
		    	printf "%s\n" "[ok]"
				printf "%s\n" "Cut pdf file"
			fi  
            ps2pdf -dFirstPage=$FIRST_PAGE_PDF -dLastPage=$LAST_PAGE_PDF $INPUT_PDF_FILE output.pdf
			if [ "$TOOL_DEBUG" == "true" ]; then
		    	printf "%s\n\n" "[Done]"
			fi  
            return $SUCCESS
        fi
		LOG[MSG]="Check file [$INPUT_PDF_FILE]"
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n" "[not ok]"
        	printf "%s\n\n" "[Error] ${LOG[MSG]}"
		fi        
        __logging $LOG
        return $NOT_SUCCESS
    fi
    __usage $TOOL_USAGE
    return $NOT_SUCCESS
}

