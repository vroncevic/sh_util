#!/bin/bash
#
# @brief   Decode a binary representation
# @version ver.1.0
# @date    Fri Oct 02 09:59:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#

SUCCESS=0
NOT_SUCCESS=1

#
# @brief Decode a binary representation
# @argument Value optional path to file 
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __uudecodes $FILE_PATH (optional)
# STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#	# true
# else
#	# false
# fi
#
function __uudecodes() {
    FILE_PATH=$1
    if [ -z "$FILE_PATH" ]; then
        for filedecode in *
        do
            search1=`head -$lines $filedecode | grep begin | wc -w`
            search2=`tail -$lines $filedecode | grep end | wc -w`
            if [ "$search1" -gt 0 ]; then
                if [ "$search2" -gt 0 ]; then
                    printf "%s\n" "Decoding [$filedecode]..."
                    uudecode $filedecode
                fi
            fi
        done
        printf "%s\n" "Done..."
        return $SUCCESS
    fi
    printf "%s" "Checking file [$FILE_PATH] "
    if [ -f "$FILE_PATH" ]; then
        printf "%s\n" "[ok]"
        printf "%s\n" "Decoding [$FILE_PATH]..."
        uudecode $FILE_PATH
        printf "%s\n" "Done..."
        return $SUCCESS
    fi
    printf "%s\n" "[not ok]"
    printf "%s\n" "File [$FILE_PATH] doesn't exist..."
    return $NOT_SUCCESS
}
