#!/bin/bash
#
# @brief   List symbolic links in a directory
# @version ver.1.0.0
# @date    Mon Oct 12 22:23:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_SYM_LINKS=sym_links
UTIL_SYM_LINKS_VERSION=ver.1.0
UTIL=/root/scripts/sh_util/${UTIL_SYM_LINKS_VERSION}
UTIL_LOG=${UTIL}/log

.    ${UTIL}/bin/devel.sh
.    ${UTIL}/bin/usage.sh

declare -A SYM_LINKS_USAGE=(
    [USAGE_TOOL]="${UTIL_SYM_LINKS}"
    [USAGE_ARG1]="[DIR] Directory path"
    [USAGE_EX_PRE]="# Example listing sym_links"
    [USAGE_EX]="${UTIL_SYM_LINKS} /etc"
)

#
# @brief  List symbolic links in a directory
# @param  Value required directory path
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# sym_links "$DIR"
# local local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#    # true
#    # notify admin | user
# else
#    # false
#    # missing argument
#    # return $NOT_SUCCESS
#    # or
#    # exit 128
# fi
#
function sym_links {
    local DIR=$1
    if [ -n "${DIR}" ]; then
        local FUNC=${FUNCNAME[0]} MSG="None" LISTEDFILE
        MSG="Checking directory [${DIR}/]?"
        info_debug_message_que "$MSG" "$FUNC" "$UTIL_SYM_LINKS"
        if [ -d "${DIR}/" ]; then
            MSG="[ok]"
            info_debug_message_ans "$MSG" "$FUNC" "$UTIL_SYM_LINKS"
            MSG="Symbolic links in directory [${DIR}/]"
            info_debug_message "$MSG" "$FUNC" "$UTIL_SYM_LINKS"
            for LISTEDFILE in "$(find ${DIR} -type l)"
            do
                printf "%s\n" " ${LISTEDFILE}"
            done | sort
            printf "%s\n" "Symbolic links in dir [${DIR}/]!"
            local OLDIFS=$IFS
            IFS=:
            for LISTEDFILE in $(find "$DIR" -type l -printf "%p$IFS")
            do
                printf "%s\n" "${LISTEDFILE}"
            done | sort
            info_debug_message_end "Done" "$FUNC" "$UTIL_SYM_LINKS"
            return $SUCCESS
        fi
        MSG="[not ok]"
        info_debug_message_ans "$MSG" "$FUNC" "$UTIL_SYM_LINKS"
        MSG="Please check directory [${DIR}/]!"
        info_debug_message "$MSG" "$FUNC" "$UTIL_SYM_LINKS"
        MSG="Force exit!"
        info_debug_message_end "$MSG" "$FUNC" "$UTIL_SYM_LINKS"
        return $NOT_SUCCESS
    fi
    usage SYM_LINKS_USAGE
    return $NOT_SUCCESS
}

