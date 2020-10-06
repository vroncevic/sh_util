#!/bin/bash
#
# @brief   Creating employee directory structure
# @version ver.1.0.0
# @date    Mon Jun 04 12:38:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_EMPLOYEE=employee
UTIL_EMPLOYEE_VERSION=ver.1.0
UTIL=/root/scripts/sh_util/${UTIL_EMPLOYEE_VERSION}
UTIL_EMPLOYEE_CFG=${UTIL}/conf/${UTIL_EMPLOYEE}.cfg
UTIL_LOG=${UTIL}/log

.    ${UTIL}/bin/devel.sh
.    ${UTIL}/bin/usage.sh
.    ${UTIL}/bin/load_util_conf.sh

declare -A IT_PROFILE_Usage=(
    [Usage_TOOL]="create_it_user_profile"
    [Usage_ARG1]="[USR] Employee username"
    [Usage_EX_PRE]="# Example generating IT profile"
    [Usage_EX]="create_it_user_profile vroncevic"
)

declare -A USR_PROFILE_Usage=(
    [Usage_TOOL]="create_share_user_profile"
    [Usage_ARG1]="[SHARE_STRUCT] System username and groip"
    [Usage_EX_PRE]="# Example generating user profile"
    [Usage_EX]="create_share_user_profile \$SHARE_STRUCT"
)

declare -A SHARE_PROFILE_Usage=(
    [Usage_TOOL]="create_home_user_profile"
    [Usage_ARG1]="[HOME_STRUCT] System username and group"
    [Usage_EX_PRE]="# Example generatingshare profile"
    [Usage_EX]="create_home_user_profile \$HOME_STRUCT"
)

#
# @brief  Create employee profile directory at IT disk
# @param  Value required username (system username)
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# local UNAME="vroncevic" STATUS
# create_it_user_profile "$UNAME"
# STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#    # true
#    # notify admin | user
# else
#    # false
#    # missing argument | failed to load config file | user profile already exist
#    # return $NOT_SUCCESS
#    # or
#    # exit 128
# fi
#
function create_it_user_profile {
    local USR=$1
    if [ -n "${USR}" ]; then
        local FUNC=${FUNCNAME[0]} MSG="None" STATUS CURRYEAR=$(date +'%Y')
        declare -A config_it_user_profile=()
        load_util_conf "$UTIL_EMPLOYEE_CFG" config_it_user_profile
        STATUS=$?
        if [ $STATUS -eq $SUCCESS ]; then
            local ITDIR=${config_it_user_profile[ITEDIR]}
            local RDIR="${ITDIR}/${CURRYEAR}/${USR}"
            MSG="Checking directory [${RDIR}/]?"
            info_debug_message_que "$MSG" "$FUNC" "$UTIL_EMPLOYEE"
            if [ ! -d "${RDIR}/" ]; then
                MSG="[not exist]"
                info_debug_message_ans "$MSG" "$FUNC" "$UTIL_EMPLOYEE"
                MSG="Creating IT profile structure for [${USR}]!"
                info_debug_message "$MSG" "$FUNC" "$UTIL_EMPLOYEE"
                fi
                mkdir "${RDIR}/"
                mkdir "${RDIR}/dig_certificate/"
                mkdir "${RDIR}/image_profile/"
                mkdir "${RDIR}/ip_phone/"
                mkdir "${RDIR}/mail_backup/"
                mkdir "${RDIR}/mail_signature/"
                mkdir "${RDIR}/openvpn/"
                mkdir "${RDIR}/pgp_key/"
                mkdir "${RDIR}/ssh_config/"
                mkdir "${RDIR}/vnc/"
                MSG="Set owner!"
                info_debug_message "$MSG" "$FUNC" "$UTIL_EMPLOYEE"
                local USRID=${config_it_user_profile[USRID]}
                local GRPID=${config_it_user_profile[GRPID]}
                eval "chown -R ${USRID}.${GRPID} ${RDIR}/"
                MSG="Set permission!"
                info_debug_message "$MSG" "$FUNC" "$UTIL_EMPLOYEE"
                eval "chmod -R 770 ${RDIR}/"
                info_debug_message_end "Done" "$FUNC" "$UTIL_EMPLOYEE"
                return $SUCCESS
            fi
            MSG="[exist]"
            info_debug_message_ans "$MSG" "$FUNC" "$UTIL_EMPLOYEE"
            MSG="IT user profile [${USR}] already exist!"
            info_debug_message "$MSG" "$FUNC" "$UTIL_EMPLOYEE"
            MSG="Force exit!"
            info_debug_message_end "$MSG" "$FUNC" "$UTIL_EMPLOYEE"
            return $NOT_SUCCESS
        fi
        MSG="Force exit!"
        info_debug_message_end "$MSG" "$FUNC" "$UTIL_EMPLOYEE"
        return $NOT_SUCCESS
    fi
    usage IT_PROFILE_Usage
    return $NOT_SUCCESS
}

#
# @brief  Create Employee Profile Directory SHARE
# @params Values required username (system username) and department
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# declare -A SHARE_STRUCT=(
#    [USR]="vroncevic"
#    [DEP]="users"
# )
#
# create_share_user_profile SHARE_STRUCT
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#    # true
#    # notify admin | user
# else
#    # false
#    # missing argument | missing config file | user profile already exist
#    # return $NOT_SUCCESS
#    # or
#    # exit 128
# fi
#
function create_share_user_profile {
    local -n SHARE_STRUCT=$1
    local USR=${SHARE_STRUCT[USR]} DEP=${SHARE_STRUCT[DEP]}
    if [[ -n "${USR}" && -n "${DEP}" ]]; then
        local FUNC=${FUNCNAME[0]} MSG="None" STATUS
        declare -A config_it_user_profile=()
        load_util_conf "$UTIL_EMPLOYEE_CFG" config_it_user_profile
        STATUS=$?
        if [ $STATUS -eq $SUCCESS ]; then
            local EDIR=${config_it_user_profile[EDIR]} RDIR
            RDIR="${EDIR}/${USR}"
            MSG="Checking directory [${RDIR}/]?"
            info_debug_message_que "$MSG" "$FUNC" "$UTIL_EMPLOYEE"
            if [ ! -d "${RDIR}/" ]; then
                MSG="[not exist]"
                info_debug_message_ans "$MSG" "$FUNC" "$UTIL_EMPLOYEE"
                MSG="Creating profile structure for [${USR}]!"
                info_debug_message "$MSG" "$FUNC" "$UTIL_EMPLOYEE"
                mkdir "${RDIR}/"
                mkdir "${RDIR}/backup/"
                mkdir "${RDIR}/baazar/"
                mkdir "${RDIR}/CV/"
                mkdir "${RDIR}/img/"
                mkdir "${RDIR}/PGP-Key/"
                mkdir "${RDIR}/SMIME-cert/"
                eval "chmod -R 777 ${RDIR}/"
                MSG="Set owner!"
                info_debug_message "$MSG" "$FUNC" "$UTIL_EMPLOYEE"
                local BACKUP="${RDIR}/backup/" USRID GRPID
                USRID=${config_it_user_profile[UNAME]}
                GRPID=${config_it_user_profile[GRP]}
                eval "chown -R ${USRID}.${GRPID} ${BACKUP}/"
                MSG="Set permission!"
                info_debug_message "$MSG" "$FUNC" "$UTIL_EMPLOYEE"
                eval "chmod -R 700 ${BACKUP}/"
                info_debug_message_end "Done" "$FUNC" "$UTIL_EMPLOYEE"
                return $SUCCESS
            fi
            MSG="[exist]"
            info_debug_message_ans "$MSG" "$FUNC" "$UTIL_EMPLOYEE"
            MSG="Share user profile [$USR] already exist"
            info_debug_message "$MSG" "$FUNC" "$UTIL_EMPLOYEE"
            MSG="Force exit!"
            info_debug_message_end "$MSG" "$FUNC" "$UTIL_EMPLOYEE"
            return $NOT_SUCCESS
        fi
        MSG="Force exit!"
        info_debug_message_end "$MSG" "$FUNC" "$UTIL_EMPLOYEE"
        return $NOT_SUCCESS
    fi
    usage USR_PROFILE_Usage
    return $NOT_SUCCESS
}

#
# @brief  Create frobas support directory at user HOME directory
# @params Values required structure username and department
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# declare -A HOME_STRUCT=(
#    [USR]="vroncevic"
#    [DEP]="users"
# )
#
# create_home_user_profile HOME_STRUCT
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#    # true
#    # notify admin | user
# else
#    # false
#    # missing argument | user profile already exist
#    # return $NOT_SUCCESS
#    # or
#    # exit 128
# fi
#
function create_home_user_profile {
    local -n HOME_STRUCT=$1
    local USR=${HOME_STRUCT[USR]} DEP=${HOME_STRUCT[DEP]}
    if [[ -n "${USR}" && -n "${DEP}" ]]; then
        local FUNC=${FUNCNAME[0]} MSG="None" 
        local RDIR="/home/${USR}/${UTIL_FROM_COMPANY}"
        MSG="Checking directory [${RDIR}/]?"
        info_debug_message_que "$MSG" "$FUNC" "$UTIL_EMPLOYEE"
        if [ ! -d "${RDIR}/" ]; then
            MSG="[not exist]"
            info_debug_message_ans "$MSG" "$FUNC" "$UTIL_EMPLOYEE"
            MSG="Creating directory structure [${RDIR}/]!"
            info_debug_message "$MSG" "$FUNC" "$UTIL_EMPLOYEE"
            mkdir "${RDIR}/"
            mkdir "${RDIR}/openvpn/"
            mkdir "${RDIR}/mail_signature"
            mkdir "${RDIR}/smime/"
            mkdir "${RDIR}/pgp/"
            mkdir "${RDIR}/pgp/private_key/"
            mkdir "${RDIR}/pgp/public_key"
            MSG="Set owner!"
            info_debug_message "$MSG" "$FUNC" "$UTIL_EMPLOYEE"
            eval "chown -R ${USR}.${DEP} ${RDIR}/"
            MSG="Set permission!"
            info_debug_message "$MSG" "$FUNC" "$UTIL_EMPLOYEE"
            eval "chmod -R 700 ${RDIR}/"
            info_debug_message_end "Done" "$FUNC" "$UTIL_EMPLOYEE"
            return $SUCCESS
        fi
        MSG="[exist]"
        info_debug_message_ans "$MSG" "$FUNC" "$UTIL_EMPLOYEE"
        MSG="Home structure for [${USR}] already exist"
        info_debug_message "$MSG" "$FUNC" "$UTIL_EMPLOYEE"
        MSG="Force exit!"
        info_debug_message_end "$MSG" "$FUNC" "$UTIL_EMPLOYEE"
        return $NOT_SUCCESS
    fi
    usage SHARE_PROFILE_Usage
    return $NOT_SUCCESS
}

