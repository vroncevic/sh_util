#!/bin/bash
#
# @brief   Create info/manual/xtools files for new App/Tool/Script
# @version ver.1.0.0
# @date    Mon Jul 15 21:44:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_ADD_NEW_TOOL=add_new_tool
UTIL_ADD_NEW_TOOL_VERSION=ver.1.0
UTIL=/root/scripts/sh_util/${UTIL_ADD_NEW_TOOL_VERSION}
UTIL_ADD_NEW_TOOL_CFG=${UTIL}/conf/${UTIL_ADD_NEW_TOOL}.cfg
UTIL_LOG=${UTIL}/log

.    ${UTIL}/bin/devel.sh
.    ${UTIL}/bin/usage.sh
.    ${UTIL}/bin/load_util_conf.sh

declare -A ADD_NEW_TOOL_USAGE=(
    [USAGE_TOOL]="${UTIL_ADD_NEW_TOOL}"
    [USAGE_ARG1]="[TOOL_NAME] Name of App/Tool/Script"
    [USAGE_EX_PRE]="# Example adding files for Thunderbird"
    [USAGE_EX]="${UTIL_ADD_NEW_TOOL} thunderbird"
)

#
# @brief  Create info/manual/xtools files for new App/Tool/Script
# @param  Value required name of App/Tool/Script
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# local TNAME="thunderbird" STATUS
# add_new_tool "$TNAME"
# STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#    # true
#    # notify admin | user
# else
#    # false
#    # missing argument | missing config file | tool already exist
#    # return $NOT_SUCCESS
#    # or
#    # exit 128
# fi
#
function add_new_tool {
    local TNAME=$1
    if [ -n "${TNAME}" ]; then
        local FUNC=${FUNCNAME[0]} MSG="None" STATUS
        declare -A config_add_new_tool=()
        load_util_conf "$UTIL_ADD_NEW_TOOL_CFG" config_add_new_tool
        STATUS=$?
        if [ $STATUS -eq $SUCCESS ]; then
            local RTOOLDIR=${config_add_new_tool[TOOLS]}
            MSG="Checking directory [${RTOOLDIR}/]?"
            info_debug_message_que "$MSG" "$FUNC" "$UTIL_ADD_NEW_TOOL"
            if [ ! -d "${RTOOLDIR}/" ]; then
                MSG="[not ok]"
                info_debug_message_ans "$MSG" "$FUNC" "$UTIL_ADD_NEW_TOOL"
                MSG="Create directory structure [${RTOOLDIR}/]!"
                info_debug_message "$MSG" "$FUNC" "$UTIL_ADD_NEW_TOOL"
                MSG="Force exit!"
                info_debug_message_end "$MSG" "$FUNC" "$UTIL_ADD_NEW_TOOL"
                return $NOT_SUCCESS
            fi
            MSG="[ok]"
            info_debug_message_ans "$MSG" "$FUNC" "$UTIL_ADD_NEW_TOOL"
            local TOOLDIR="${RTOOLDIR}/${TNAME}"
            MSG="Checking directory [${TOOLDIR}/]?"
            info_debug_message_que "$MSG" "$FUNC" "$UTIL_ADD_NEW_TOOL"
            if [ ! -d "${TOOLDIR}/" ]; then
                MSG="[not exist]"
                info_debug_message_ans "$MSG" "$FUNC" "$UTIL_ADD_NEW_TOOL"
                MSG="Creating directory [${TOOLDIR}/]!"
                info_debug_message "$MSG" "$FUNC" "$UTIL_ADD_NEW_TOOL"
                mkdir "${TOOLDIR}/"
                local DATE=$(date) TINFO TMAN TXTOOLS ILINE MLINE XLINE H="#"
                TINFO="${TOOLDIR}/${TNAME}-info.txt"
                TMAN="${TOOLDIR}/${TNAME}-install-manual.txt"
                TXTOOLS="${TOOLDIR}/${TNAME}-install-xtools.cfg"
                MSG="Creating file [${TINFO}]!"
                info_debug_message "$MSG" "$FUNC" "$UTIL_ADD_NEW_TOOL"
                while read ILINE
                do
                    eval echo "$ILINE" >> $TINFO
                done < ${config_add_new_tool[INFO_FILE_TEMPLATE]}
                MSG="Creating file [${TMAN}]!"
                info_debug_message "$MSG" "$FUNC" "$UTIL_ADD_NEW_TOOL"
                while read MLINE
                do
                    eval echo "$MLINE" >> $TMAN
                done < ${config_add_new_tool[MANUAL_FILE_TEMPLATE]}
                MSG="Creating file [${TXTOOLS}]!"
                info_debug_message "$MSG" "$FUNC" "$UTIL_ADD_NEW_TOOL"
                while read XLINE
                do
                    eval echo "$XLINE" >> $TXTOOLS
                done < ${config_add_new_tool[XTOOLS_FILE_TEMPLATE]}
                MSG="Set owner!"
                info_debug_message "$MSG" "$FUNC" "$UTIL_ADD_NEW_TOOL"
                local USRID=${config_add_new_tool[UID]}
                local GRPID=${config_add_new_tool[GID]}
                eval "chown -R ${USRID}.${GRPID} ${TOOLDIR}/"
                MSG="Set permission!"
                info_debug_message "$MSG" "$FUNC" "$UTIL_ADD_NEW_TOOL"
                eval "chmod -R 770 ${TOOLDIR}/"
                info_debug_message_end "Done" "$FUNC" "$UTIL_ADD_NEW_TOOL"
                return $SUCCESS
            fi
            MSG="[exist]"
            info_debug_message_ans "$MSG" "$FUNC" "$UTIL_ADD_NEW_TOOL"
            MSG="Directory structure for [${TNAME}] already exist!"
            info_debug_message "$MSG" "$FUNC" "$UTIL_ADD_NEW_TOOL"
            MSG="Force exit!"
            info_debug_message_end "$MSG" "$FUNC" "$UTIL_ADD_NEW_TOOL"
        fi
        MSG="Force exit!"
        info_debug_message_end "$MSG" "$FUNC" "$UTIL_ADD_NEW_TOOL"
        return $NOT_SUCCESS
    fi
    usage ADD_NEW_TOOL_USAGE
    return $NOT_SUCCESS
}

