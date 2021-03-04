#!/bin/bash
#
# @brief   Unpack zip, tar, tgz, tar.gz, tar.bz2, tar.z to 
#          a DIR of the same name as archive prefix
# @version ver.1.0.0
# @date    Fri Oct 02 09:59:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_UNPACK_TO_DIR=unpack_to_dir
UTIL_UNPACK_TO_DIR_VERSION=ver.1.0.0
UTIL=/root/scripts/sh_util/${UTIL_UNPACK_TO_DIR_VERSION}
UTIL_LOG=${UTIL}/log

.    ${UTIL}/bin/devel.sh
.    ${UTIL}/bin/usage.sh
.    ${UTIL}/bin/dir_utils.sh

#
# @brief  Unpack to DIR archive
# @param  Value required archive file
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# unpack_to_dir $FILES
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#    # true
#    # notify admin | user
# else
#    # false
#    # missing argument(s)
#    # return $NOT_SUCCESS
#    # or
#    # exit 128
# fi
#
function unpack_to_dir {
    shift $((${OPTIND} - 1))
    local STARTDIR=$(pwd) FUNC=${FUNCNAME[0]} MSG="None" A DIR
    MSG="Unpack archive to DIR archive!"
    info_debug_message "$MSG" "$FUNC" "$UTIL_UNPACK_TO_DIR"
    for A in "$@"
    do
        cd ${STARTDIR}
        local FNAME=$(getbasename ${A}) DIR=$(getdirname ${A})
        cd ${DIR}
        A=${FNAME}
        case ${A} in
            # zip
            *.[zZ][iI][pP])
                mkdirf ${A/.[zZ][iI][pP]/} ${A}
                MSG="Extract archive [${A}]!"
                info_debug_message "$MSG" "$FUNC" "$UTIL_UNPACK_TO_DIR"
                unzip -qq ${A} -d ${A/.[zZ][iI][pP]/}
                clean $? ${A/.[zZ][iI][pP]/}
                ;;
            # tar
            *.[tT][aA][rR])
                mkdirf ${A/.[tT][aA][rR]/} ${A}
                MSG="Extract archive [${A}]!"
                info_debug_message "$MSG" "$FUNC" "$UTIL_UNPACK_TO_DIR"
                tar -xf ${A} -C ${A/.[tT][aA][rR]/}/
                clean $? ${A/.[tT][aA][rR]/}
                ;;
            # tgz
            *.[tT][gG][zZ])
                mkdirf ${A/.[tT][gG][zZ]/} ${A}
                MSG="Extract archive [${A}]!"
                info_debug_message "$MSG" "$FUNC" "$UTIL_UNPACK_TO_DIR"
                tar -xzf ${A} -C ${A/.[tT][gG][zZ]/}
                clean $? ${A/.[tT][gG][zZ]/}
                ;;
            # tar.gz
            *.[tT][aA][rR].[gG][zZ])
                mkdirf ${A/.[tT][aA][rR].[gG][zZ]/} ${A}
                MSG="Extract archive [${A}]!"
                info_debug_message "$MSG" "$FUNC" "$UTIL_UNPACK_TO_DIR"
                tar -xzf ${A} -C ${A/.[tT][aA][rR].[gG][zZ]/}/
                clean $? ${A/.[tT][aA][rR].[gG][zZ]/}
                ;;
            # tar.bz2
            *.[tT][aA][rR].[bB][zZ]2)
                mkdirf ${A/.[tT][aA][rR].[bB][zZ]2/} ${A}
                MSG="Extract archive [${A}]!"
                info_debug_message "$MSG" "$FUNC" "$UTIL_UNPACK_TO_DIR"
                tar -xjf ${A} -C ${A/.[tT][aA][rR].[bB][zZ]2/}/
                clean $? ${A/.[tT][aA][rR].[bB][zZ]2/}
                ;;
            # tar.z
            *.[tT][aA][rR].[zZ])
                mkdirf ${A/.[tT][aA][rR].[zZ]/} ${A}
                MSG="Extract archive [${A}]!"
                info_debug_message "$MSG" "$FUNC" "$UTIL_UNPACK_TO_DIR"
                tar -xZf ${A} -C ${A/.[tT][aA][rR].[zZ]/}/
                clean $? ${A/.[tT][aA][rR].[zZ]/}
                ;;
            *)
                MSG="[${A}] not a compressed file|lacks proper suffix!"
                info_debug_message "$MSG" "$FUNC" "$UTIL_UNPACK_TO_DIR"
                MSG="Force exit!"
                info_debug_message_end "$MSG" "$FUNC" "$UTIL_UNPACK_TO_DIR"
                return $NOT_SUCCESS
                ;;
        esac
    done
    info_debug_message_end "Done" "$FUNC" "$UTIL_UNPACK_TO_DIR"
    return $SUCCESS
}

