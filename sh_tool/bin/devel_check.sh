#!/bin/bash
#
# @brief   Check functions for boolean, status, string and key validations
# @version ver.1.0
# @date    Fri Dec  5 07:56:57 PM CET 2025
# @company None, free software to use 2025
# @author  Vladimir Roncevic <elektron.ronca@gmail.com>
#
if [ -z "$__SH_UTIL_DEVEL_CHECK" ]; then
    readonly __SH_UTIL_DEVEL_CHECK=1

    UTIL_DEVEL_CHECK=devel_check
    UTIL_DEVEL_CHECK_VERSION=ver.1.0
    UTIL=/root/scripts/sh_util/${UTIL_DEVEL_CHECK_VERSION}

    .    ${UTIL}/bin/devel_const.sh

    #
    # @brief  Check bool variable
    # @param  Value required referenced variable
    # @retval Success 0, else 1
    #
    # @usage
    # @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    #
    # local STATUS VAR="true"
    # check_bool_var VAR
    # STATUS=$?
    #
    # if [ $STATUS -eq $SUCCESS ]; then
    #    # true
    #    # notify admin | user
    # else
    #    # false
    #    # return $NOT_SUCCESS
    #    # or
    #    # exit 128
    # fi
    #
    function check_bool_var {
        local FUNC=${FUNCNAME[0]} MSG="None"
        local -n VAR_REF
        if [ -z "$1" ]; then
            MSG="Missing required argument [VARIABLE NAME string]"
            printf "$SEND" "devel" "$FUNC" "$MSG" >&2
            return $NOT_SUCCESS
        fi
        VAR_REF=$1
        if [ -n "${VAR_REF}" ]; then            
            if [[ "${VAR_REF}" == "${TRUE}" || "${VAR_REF}" == "${FALSE}" ]]; then
                return $SUCCESS
            fi
            MSG="Referenced variable '${1}' value ('${VAR_REF}') is not a valid boolean"
            printf "$SEND" "devel" "$FUNC" "$MSG" >&2
            return $NOT_SUCCESS
        fi
        MSG="Referenced variable '${1}' is empty or unset"
        printf "$SEND" "devel" "$FUNC" "$MSG" >&2
        return $NOT_SUCCESS
    }

    #
    # @brief  Check status structure
    # @param  Value required referenced structure with statuses
    # @retval Success 0, else 1
    #
    # @usage
    # @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    #
    # declare -A STATUS_STRUCT=(
    #    [TEST1]=$SUCCESS
    #    ...
    #    [TESTN]=$SUCCESS
    # )
    #
    # check_status STATUS_STRUCT
    # local STATUS=$?
    #
    # if [ $STATUS -eq $SUCCESS ]; then
    #    # true
    #    # notify admin | user
    # else
    #    # false
    #    # return $NOT_SUCCESS
    #    # or
    #    # exit 128
    # fi
    #
    function check_status {
        local FUNC=${FUNCNAME[0]} MSG="None"
        local -n STATUS_STRUCT
        if [ -z "$1" ]; then
            MSG="Missing required argument [ARRAY NAME status]"
            printf "$SEND" "devel" "$FUNC" "$MSG" >&2
            return $NOT_SUCCESS
        fi
        STATUS_STRUCT=$1
        local NSTATUS=${#STATUS_STRUCT[@]} I
        if [ "$NSTATUS" -eq 0 ]; then
            MSG="Referenced array '${1}' is empty or not an associative array."
            printf "$SEND" "devel" "$FUNC" "$MSG" >&2
            return $NOT_SUCCESS
        fi
        for I in "${!STATUS_STRUCT[@]}"
        do
            if [[ ${STATUS_STRUCT[$I]} -eq $NOT_SUCCESS ]]; then
                MSG="Status check failed at key '${I}'."
                printf "$SEND" "devel" "$FUNC" "$MSG" >&2
                return $NOT_SUCCESS
            fi
        done
        return $SUCCESS
    }

    #
    # @brief  Check string structure
    # @param  Value required referenced structure with strings
    # @retval Success 0, else 1
    #
    # @usage
    # @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    #
    # declare -A STRING_STRUCT=(
    #    [TEST1]="None"
    #    ...
    #    [TESTN]="SomeKey"
    # )
    #
    # check_strings STRING_STRUCT
    # local STATUS=$?
    #
    # if [ $STATUS -eq $SUCCESS ]; then
    #    # true
    #    # notify admin | user
    # else
    #    # false
    #    # return $NOT_SUCCESS
    #    # or
    #    # exit 128
    # fi
    #
    function check_strings {
        local FUNC=${FUNCNAME[0]} MSG="None"
        local -n STRING_STRUCT
        if [ -z "$1" ]; then
            MSG="Missing required argument [ARRAY NAME string]"
            printf "$SEND" "devel" "$FUNC" "$MSG" >&2
            return $NOT_SUCCESS
        fi
        STRING_STRUCT=$1
        local NSTATUS=${#STRING_STRUCT[@]} I
        if [ "$NSTATUS" -eq 0 ]; then
            MSG="Referenced array '${1}' is empty or not an associative array."
            printf "$SEND" "devel" "$FUNC" "$MSG" >&2
            return $NOT_SUCCESS
        fi
        for I in "${!STRING_STRUCT[@]}"
        do
            if [[ -z "${STRING_STRUCT[$I]}" ]]; then
                MSG="String check failed at key '${I}'."
                printf "$SEND" "devel" "$FUNC" "$MSG" >&2
                return $NOT_SUCCESS
            fi
        done
        return $SUCCESS
    }

    #
    # @brief  Check key from key list in string representation
    # @params Values required key and key list
    # @retval Success 0, else 1
    #
    # @usage
    # @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    #
    # KEYS="debug test verification deploy"
    # KEY="test"
    #
    # check_key $KEY $KEYS
    # local STATUS=$?
    #
    # if [ $STATUS -eq $SUCCESS ]; then
    #    # true
    #    # notify admin | user
    # else
    #    # false
    #    # return $NOT_SUCCESS
    #    # or
    #    # exit 128
    # fi
    #
    function check_key {
        local KEY=$1 KEYS=$2
        local FUNC=${FUNCNAME[0]} MSG="None"
        if [[ -n "${KEY}" && -n "${KEYS}" ]]; then
            local EL
            IFS=' ' read -ra ARRAY_KEYS <<< "$KEYS"
            for EL in "${ARRAY_KEYS[@]}"
            do
                if [[ ${KEY} == ${EL} ]]; then
                    return $SUCCESS
                fi
            done
            MSG="Key ${KEY} is not in key list [${KEYS}]"
            printf "$SEND" "devel" "$FUNC" "$MSG" >&2
            return $NOT_SUCCESS
        fi
        MSG="Missing argument(s) [TARGET_KEY] or [LIST_OF_KEYS]"
        printf "$SEND" "devel" "$FUNC" "$MSG" >&2
        return $NOT_SUCCESS
    }
fi
