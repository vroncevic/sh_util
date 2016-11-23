#!/bin/bash
#
# @brief   Unpack zip, tar, tgz, tar.gz, tar.bz2, tar.z to 
#          a dir of the same name as archive prefix
# @version ver.1.0
# @date    Fri Oct 02 09:59:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_UNPACK2DIR=unpack2dir
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/dirutils.sh
. $UTIL/bin/devel.sh

declare -A UNPACK2DIR_USAGE=(
    [TOOL_NAME]="__$UTIL_UNPACK2DIR"
    [ARG1]="[FILE] Path to the target"
    [EX-PRE]="# Example running __$UTIL_UNPACK2DIR"
    [EX]="__$UTIL_UNPACK2DIR test.ar.gz"	
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
# local STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
#   # notify admin | user
# else
#   # false
#   # missing argument(s)
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __unpack2dir() {
    shift $(($OPTIND - 1))
    local start_dir=$(pwd)
    local FUNC=${FUNCNAME[0]}
    local MSG=""
	if [ "$TOOL_DBG" == "true" ]; then
		MSG="Unpack archive to dir archive"
		printf "$DSTA" "$UTIL_UNPACK2DIR" "$FUNC" "$MSG"
	fi
    for a in "$@"
    do
        cd $start_dir
        local fname=$(__getbasename $a)
        local dir=$(__getdirname $a)
        cd $dir
        a=$fname
        case $a in
            # zip 
            *.[zZ][iI][pP])
                            mkdirf ${a/.[zZ][iI][pP]/} $a
							if [ "$TOOL_DBG" == "true" ]; then
                            	MSG="Extract archive [$a]"
								printf "$DSTA" "$UTIL_UNPACK2DIR" "$FUNC" "$MSG"
							fi
                            unzip -qq $a -d ${a/.[zZ][iI][pP]/}
                            clean $? ${a/.[zZ][iI][pP]/}
                            ;;
            # tar
            *.[tT][aA][rR])
                            mkdirf ${a/.[tT][aA][rR]/} $a
							if [ "$TOOL_DBG" == "true" ]; then
                            	MSG="Extract archive [$a]"
								printf "$DSTA" "$UTIL_UNPACK2DIR" "$FUNC" "$MSG"
							fi
                            tar -xf $a -C ${a/.[tT][aA][rR]/}/
                            clean $? ${a/.[tT][aA][rR]/}
                            ;;
            # tgz
            *.[tT][gG][zZ])
                            mkdirf ${a/.[tT][gG][zZ]/} $a
							if [ "$TOOL_DBG" == "true" ]; then                            
								MSG="Extract archive [$a]"
								printf "$DSTA" "$UTIL_UNPACK2DIR" "$FUNC" "$MSG"
							fi
                            tar -xzf $a -C ${a/.[tT][gG][zZ]/}
                            clean $? ${a/.[tT][gG][zZ]/}
                            ;;
            # tar.gz 
            *.[tT][aA][rR].[gG][zZ])
                            mkdirf ${a/.[tT][aA][rR].[gG][zZ]/} $a
							if [ "$TOOL_DBG" == "true" ]; then                            
								MSG="Extract archive [$a]"
								printf "$DSTA" "$UTIL_UNPACK2DIR" "$FUNC" "$MSG"
							fi
                            tar -xzf $a -C ${a/.[tT][aA][rR].[gG][zZ]/}/
                            clean $? ${a/.[tT][aA][rR].[gG][zZ]/}
                            ;;
            # tar.bz2
            *.[tT][aA][rR].[bB][zZ]2)
                            mkdirf ${a/.[tT][aA][rR].[bB][zZ]2/} $a
							if [ "$TOOL_DBG" == "true" ]; then
                            	MSG="Extract archive [$a]"
								printf "$DSTA" "$UTIL_UNPACK2DIR" "$FUNC" "$MSG"
							fi
                            tar -xjf $a -C ${a/.[tT][aA][rR].[bB][zZ]2/}/
                            clean $? ${a/.[tT][aA][rR].[bB][zZ]2/}
                            ;;
            # tar.z
            *.[tT][aA][rR].[zZ])
                            mkdirf ${a/.[tT][aA][rR].[zZ]/} $a
							if [ "$TOOL_DBG" == "true" ]; then                            
								MSG="Extract archive [$a]"
								printf "$DSTA" "$UTIL_UNPACK2DIR" "$FUNC" "$MSG"
							fi
                            tar -xZf $a -C ${a/.[tT][aA][rR].[zZ]/}/
                            clean $? ${a/.[tT][aA][rR].[zZ]/}
                            ;;
            *)
							MSG="[$a] not a compressed file|lacks proper suffix"
							printf "$SEND" "$UTIL_UNPACK2DIR" "$MSG"
							return $NOT_SUCCESS
                            ;;
        esac
    done
	if [ "$TOOL_DBG" == "true" ]; then
    	printf "$DEND" "$UTIL_UNPACK2DIR" "$FUNC" "Done"
	fi
    return $SUCCESS
}

