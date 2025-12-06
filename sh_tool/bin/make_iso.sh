#!/bin/bash
#
# @brief   Make ISO file
# @version ver.1.0
# @date    Mon Jun 02 18:36:32 2015
# @company None, free software to use 2015
# @author  Vladimir Roncevic <elektron.ronca@gmail.com>
#
if [ -z "$__SH_UTIL_MAKE_ISO" ]; then
    readonly __SH_UTIL_MAKE_ISO=1

    UTIL_MAKE_ISO=make_iso
    UTIL_MAKE_ISO_VERSION=ver.1.0
    UTIL=/root/scripts/sh_util/${UTIL_MAKE_ISO_VERSION}
    UTIL_LOG=${UTIL}/log

    .    ${UTIL}/bin/usage.sh

    declare -A MAKE_ISO_USAGE=(
        [USAGE_TOOL]="${UTIL_MAKE_ISO}"
        [USAGE_ARG1]="[SRC] Target media for cloning or restoring"
        [Usage_ARG2]="[DST]  Final destination"
        [USAGE_EX_PRE]="# Creates an ISO disk image from a CD-ROM"
        [USAGE_EX]="${UTIL_MAKE_ISO} /dev/sr0 myCD.iso"
    )

    #
    # @brief  Check is media disk in disk reader
    # @param  None
    # @retval Success return 0, else return 1
    #
    # @usage
    # @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    #
    # check_rom
    # local STATUS=$?
    #
    # if [ $STATUS -eq $SUCCESS ]; then
    #    # true
    #    # notify admin | user
    # else
    #    # false
    #    # expected iso9660 format
    #    # return $NOT_SUCCESS
    #    # or
    #    # exit 128
    # fi
    #
    function check_rom {
        local STATUS=$(blkid /dev/sr0) MATCH_SUBSTRING="TYPE=\"iso9660\""
        local FUNC=${FUNCNAME[0]} MSG="None"
        MSG="Check is media disk in disk reader /dev/sr0 !"
        info_debug_message "$MSG" "$FUNC" "$UTIL_MAKE_ISO"
        if [ $STATUS == *"$MATCH_SUBSTRING"* ]; then
            info_debug_message_end "Done" "$FUNC" "$UTIL_MAKE_ISO"
            return $SUCCESS
        fi
        MSG="Please check type of disk, expected iso9660"
        info_debug_message "$MSG" "$FUNC" "$UTIL_MAKE_ISO"
        MSG="Force exit!"
        info_debug_message_end "$MSG" "$FUNC" "$UTIL_MAKE_ISO"
        return $NOT_SUCCESS
    }

    #
    # @brief  Create ISO disk from direcotry source 
    # @params Values required source and destination
    # @retval Success return 0, else return 1
    #
    # @usage
    # @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    #
    # make_iso "/dev/sr0" "myCD.iso"
    # local STATUS=$?
    #
    # if [ $STATUS -eq $SUCCESS ]; then
    #    # true
    #    # notify admin | user
    # else
    #    # false
    #    # missing argument(s) | media is empty
    #    # return $NOT_SUCCESS
    #    # or
    #    # exit 128
    # fi
    #
    function make_iso {
        local SRC=$1 DST=$2
        if [[ -z "${DST}" || -z "${SRC}" ]]; then
            usage MAKE_ISO_USAGE
            return $NOT_SUCCESS
        fi
        local FUNC=${FUNCNAME[0]} MSG="None" STATUS
        MSG="Checking media disk?"
        info_debug_message_que "$MSG" "$FUNC" "$UTIL_MAKE_ISO"
        check_rom
        STATUS=$?
        if [ $STATUS -eq $SUCCESS ]; then
            info_debug_message_ans "[ok]" "$FUNC" "$UTIL_MAKE_ISO"
            dd if="${SRC}" of="${DST}"
            info_debug_message_end "Done" "$FUNC" "$UTIL_MAKE_ISO"
            return $SUCCESS
        fi
        MSG="[not ok]"
        info_debug_message_ans "$MSG" "$FUNC" "$UTIL_MAKE_ISO"
        MSG="Insert media disk!"
        info_debug_message "$MSG" "$FUNC" "$UTIL_MAKE_ISO"
        MSG="Force exit!"
        info_debug_message_end "$MSG" "$FUNC" "$UTIL_MAKE_ISO"
        return $NOT_SUCCESS
    }
fi
