#!/bin/bash
#
# @brief   Unpack zip, tar, tgz, tar.gz, tar.bz2, tar.z to 
#          a dir of the same name as archive prefix
# @version ver.1.0
# @date    Fri Oct 02 09:59:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_NAME=unpack2dir
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/logging.sh
. $UTIL/bin/dirutils.sh
. $UTIL/bin/devel.sh

declare -A TOOL_USAGE=(
    [TOOL_NAME]="__$UTIL_NAME"
    [ARG1]="[FILE] Path to the target"
    [EX-PRE]="# Example running __$UTIL_NAME"
    [EX]="__$UTIL_NAME test.ar.gz"	
)

declare -A LOG=(
    [TOOL]="$UTIL_NAME"
    [FLAG]="error"
    [PATH]="$UTIL_LOG"
    [MSG]=""
)

#
# @brief  Unpack to dir archive
# @param  Value required archive file
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __unpack2dir $FILES
# STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
# else
#   # false
# fi
#
function __unpack2dir() {
    shift $(($OPTIND - 1))
    start_dir=$(pwd)
	if [ "$TOOL_DEBUG" == "true" ]; then
		printf "%s\n" "[Unpack archive to dir archive]"
	fi
    for a in "$@"
    do
        cd $start_dir
        fname=$(__getbasename $a)
        dir=$(__getdirname $a)
        cd $dir
        a=$fname
        case $a in
            # zip 
            *.[zZ][iI][pP])
                            mkdirf ${a/.[zZ][iI][pP]/} $a
							if [ "$TOOL_DEBUG" == "true" ]; then
                            	printf "%s\n" "Extract archive [$a]"
							fi
                            unzip -qq $a -d ${a/.[zZ][iI][pP]/}
                            clean $? ${a/.[zZ][iI][pP]/}
                            ;;
            # tar
            *.[tT][aA][rR])
                            mkdirf ${a/.[tT][aA][rR]/} $a
							if [ "$TOOL_DEBUG" == "true" ]; then
                            	printf "%s\n" "Extract archive [$a]"
							fi
                            tar -xf $a -C ${a/.[tT][aA][rR]/}/
                            clean $? ${a/.[tT][aA][rR]/}
                            ;;
            # tgz
            *.[tT][gG][zZ])
                            mkdirf ${a/.[tT][gG][zZ]/} $a
							if [ "$TOOL_DEBUG" == "true" ]; then                            
								printf "%s\n" "Extract archive [$a]"
							fi
                            tar -xzf $a -C ${a/.[tT][gG][zZ]/}
                            clean $? ${a/.[tT][gG][zZ]/}
                            ;;
            # tar.gz 
            *.[tT][aA][rR].[gG][zZ])
                            mkdirf ${a/.[tT][aA][rR].[gG][zZ]/} $a
							if [ "$TOOL_DEBUG" == "true" ]; then                            
								printf "%s\n" "Extract archive [$a]"
							fi
                            tar -xzf $a -C ${a/.[tT][aA][rR].[gG][zZ]/}/
                            clean $? ${a/.[tT][aA][rR].[gG][zZ]/}
                            ;;
            # tar.bz2
            *.[tT][aA][rR].[bB][zZ]2)
                            mkdirf ${a/.[tT][aA][rR].[bB][zZ]2/} $a
							if [ "$TOOL_DEBUG" == "true" ]; then
                            	printf "%s\n" "Extract archive [$a]"
							fi
                            tar -xjf $a -C ${a/.[tT][aA][rR].[bB][zZ]2/}/
                            clean $? ${a/.[tT][aA][rR].[bB][zZ]2/}
                            ;;
            # tar.z
            *.[tT][aA][rR].[zZ])
                            mkdirf ${a/.[tT][aA][rR].[zZ]/} $a
							if [ "$TOOL_DEBUG" == "true" ]; then                            
								printf "%s\n" "Extract archive [$a]"
							fi
                            tar -xZf $a -C ${a/.[tT][aA][rR].[zZ]/}/
                            clean $? ${a/.[tT][aA][rR].[zZ]/}
                            ;;
            *) 
							if [ "$TOOL_DEBUG" == "true" ]; then                            
								printf "%s\n" "[$a] not a compressed file or lacks proper suffix"
							fi
							: 
                            ;;
        esac
    done
	if [ "$TOOL_DEBUG" == "true" ]; then
    	printf "%s\n\n" "[Done]"
	fi
    return $SUCCESS
}

