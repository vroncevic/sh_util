#!/bin/bash
#
# @brief   Create a file n bytes size
# @version ver.1.0.0
# @date    Fri Okt 02 09:59:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_CREATE_FILE_NSIZE=create_file_nsize
UTIL_CREATE_FILE_NSIZE_VERSION=ver.1.0
UTIL=/root/scripts/sh_util/${UTIL_CREATE_FILE_NSIZE_VERSION}
UTIL_LOG=${UTIL}/log

.    ${UTIL}/bin/devel.sh
.    ${UTIL}/bin/usage.sh

declare -A CREATE_FILE_NSIZE_Usage=(
    [Usage_TOOL]="${UTIL_CREATE_FILE_NSIZE}"
    [Usage_ARG1]="[F_STRUCT] Number of bytes, file name and Character"
    [Usage_EX_PRE]="# Example creating a file n bytes large"
    [Usage_EX]="${UTIL_CREATE_FILE_NSIZE} \$F_STRUCT"
)

#
# @brief  Create a file of n bytes size
# @param  Value required structure
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# declare -A F_STRUCT=(
#    [NB]=8
#    [FN]="test.ini"
#    [CH]="D"
# )
#
# create_file_nsize F_STRUCT
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#    # true
#    # notify admin | user
# else
#    # false
#    # missing argument | wrong argument
#    # return $NOT_SUCCESS
#    # or
#    # exit 128
# fi
#
function create_file_nsize {
    local -n F_STRUCT=$1
    local NBYTES=${F_STRUCT[NB]} NAME=${F_STRUCT[FN]} CHAR=${F_STRUCT[CH]}
    if [[ -n "${NAME}" && -n "${NBYTES}" && -n "${CHAR}" ]]; then
        local FUNC=${FUNCNAME[0]} MSG="None"
        MSG="Create a file n bytes size [${NAME}]!"
        info_debug_message "$MSG" "$FUNC" "$UTIL_CREATE_FILE_NSIZE"
        case ${NBYTES} in
            *[!0-9]*)
                usage CREATE_FILE_NSIZE_Usage
                return $NOT_SUCCESS
                ;;
                *)
                MSG="Generating file [${NAME}]!"
                info_debug_message "$MSG" "$FUNC" "$UTIL_CREATE_FILE_NSIZE"
                :
                ;;
        esac
        MSG="Write to file [${NAME}]!"
        info_debug_message "$MSG" "$FUNC" "$UTIL_CREATE_FILE_NSIZE"
        local COUNTER=0
        while(($COUNTER != $NBYTES))
        do
            echo -n "${CHAR}" >> "${NAME}"
            ((COUNTER++))
        done
        info_debug_message_end "Done" "$FUNC" "$UTIL_CREATE_FILE_NSIZE"
        return $SUCCESS
    fi
    usage CREATE_FILE_NSIZE_Usage
    return $NOT_SUCCESS
}

