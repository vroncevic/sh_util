#!/bin/bash
#
# @brief   Print variants of number
# @version ver.1.0
# @date    Mon Jul 15 21:44:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
TOOL_NAME=numbase
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
    [ARG1]="[] "
    [EX-PRE]="# "
    [EX]="__$TOOL_NAME "
)

declare -A LOG=(
    [TOOL]="$TOOL_NAME"
    [FLAG]="error"
    [PATH]="$TOOL_LOG"
    [MSG]=""
)

#
# @brief print number in format
# @argument Value required
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __printbases $NUMBER
#
function __printbases() {
	
    for i
    do
        case "$i" in
            0b*)		
                                ibase=2
                                ;;
            0x*|[a-f]*|[A-F]*)	
                                ibase=16
                                ;;
            0*)			
                                ibase=8
                                ;;
            [1-9]*)		
                                ibase=10
                                ;;
            *)
                                Msg "illegal number $i - ignored"
                                continue
                                ;;
        esac
        number=`echo "$i" | sed -e 's:^0[bBxX]::' | tr '[a-f]' '[A-F]'`
        dec=`echo "ibase=$ibase; $number" | bc`
        case "$dec" in
                [0-9]*)
                        ;;
                *)
                        continue
                        ;;
        esac
        echo `bc <<!
                obase=16; "hex="; $dec
                obase=10; "dec="; $dec
                obase=8;  "oct="; $dec
                obase=2;  "bin="; $dec
!
        ` | sed -e 's: :	:g'
    done
}

#
# @brief 
# @argument Value required 
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __numbase $TOOL_NAME
# STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#	# true
# else
#	# false
# fi
#
function __numbase() {
	
    if [ $# -gt 0 ]; then
        __printbases "$@"
    else
        while read line
        do
            __printbases $line
        done
        return $SUCCESS
    fi
    return $NOT_SUCCESS
}
