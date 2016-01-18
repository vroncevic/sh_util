#!/bin/bash
#
# @brief   Unpack zip, tar, tgz, tar.gz, tar.bz2, tar.z to a dir of the same name as archive prefix
# @version ver.1.0
# @date    Fri Oct 02 09:59:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
TOOL_NAME=unpack2dir
TOOL_VERSION=ver.1.0
TOOL_EXECUTABLE="${BASH_SOURCE[0]}"
TOOL_BIN=`dirname $TOOL_EXECUTABLE`
TOOL_HOME=`dirname $TOOL_BIN`
TOOL_LOG=$TOOL_HOME/log

. $TOOL_BIN/usage.sh
. $TOOL_BIN/logging.sh
. $TOOL_BIN/dirutils.sh

SUCCESS=0
NOT_SUCCESS=1

declare -A TOOL_USAGE=(
    [TOOL_NAME]="__$TOOL"
    [ARG1]="[FILE] Path to the target"
    [EX-PRE]="# Example running __$TOOL"
    [EX]="__$TOOL test.ar.gz"	
)

declare -A LOG=(
    [TOOL]="$TOOL_NAME"
    [FLAG]="error"
    [PATH]="$TOOL_LOG"
    [MSG]=""
)

#
# @brief Unpack to dir archive
# @argument Value required archive file
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __unpack2dir $FILES
# STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#	# true
# else
#	# false
# fi
#
function __unpack2dir() {
    shift $(($OPTIND - 1))
    start_dir=$(pwd)
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
                            printf "%s\n" "Extract archive [$a]..."
                            unzip -qq $a -d ${a/.[zZ][iI][pP]/}
                            clean $? ${a/.[zZ][iI][pP]/}
                            ;;
            # tar
            *.[tT][aA][rR])
                            mkdirf ${a/.[tT][aA][rR]/} $a
                            printf "%s\n" "Extract archive [$a]..."
                            tar -xf $a -C ${a/.[tT][aA][rR]/}/
                            clean $? ${a/.[tT][aA][rR]/}
                            ;;
            # tgz
            *.[tT][gG][zZ])
                            mkdirf ${a/.[tT][gG][zZ]/} $a
                            printf "%s\n" "Extract archive [$a]..."
                            tar -xzf $a -C ${a/.[tT][gG][zZ]/}
                            clean $? ${a/.[tT][gG][zZ]/}
                            ;;
            # tar.gz 
            *.[tT][aA][rR].[gG][zZ])
                            mkdirf ${a/.[tT][aA][rR].[gG][zZ]/} $a
                            printf "%s\n" "Extract archive [$a]..."
                            tar -xzf $a -C ${a/.[tT][aA][rR].[gG][zZ]/}/
                            clean $? ${a/.[tT][aA][rR].[gG][zZ]/}
                            ;;
            # tar.bz2
            *.[tT][aA][rR].[bB][zZ]2)
                            mkdirf ${a/.[tT][aA][rR].[bB][zZ]2/} $a
                            printf "%s\n" "Extract archive [$a]..."
                            tar -xjf $a -C ${a/.[tT][aA][rR].[bB][zZ]2/}/
                            clean $? ${a/.[tT][aA][rR].[bB][zZ]2/}
                            ;;
            # tar.z
            *.[tT][aA][rR].[zZ])
                            mkdirf ${a/.[tT][aA][rR].[zZ]/} $a
                            printf "%s\n" "Extract archive [$a]..."
                            tar -xZf $a -C ${a/.[tT][aA][rR].[zZ]/}/
                            clean $? ${a/.[tT][aA][rR].[zZ]/}
                            ;;
            *) 
                            printf "%s\n" "[$a] not a compressed file or lacks proper suffix" 
                            ;;
        esac
    done
    printf "%s\n" "Done..."
    return $SUCCESS
}
