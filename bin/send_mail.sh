#!/bin/bash
#
# @brief   Sending an email to admin
# @version ver.1.0
# @date    Mon Jul 15 20:57:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_SEND_MAIL=send_mail
UTIL_SEND_MAIL_VERSION=ver.1.0
UTIL=/root/scripts/sh_util/${UTIL_SEND_MAIL_VERSION}
UTIL_SEND_MAIL_CFG=${UTIL}/conf/${UTIL_SEND_MAIL}.cfg
UTIL_LOG=${UTIL}/log

.    ${UTIL}/bin/devel.sh
.    ${UTIL}/bin/usage.sh
.    ${UTIL}/bin/check_tool.sh
.    ${UTIL}/bin/load_util_conf.sh

declare -A SEND_MAIL_USAGE=(
    [USAGE_TOOL]="${UTIL_SEND_MAIL}"
    [USAGE_ARG1]="[MSG] Email text body"
    [USAGE_ARG2]="[EMAIL2ADMIN] Full email address"
    [USAGE_EX_PRE]="# Example sending simple message"
    [USAGE_EX]="${UTIL_SEND_MAIL} \"test\" \"vladimir.roncevic@frobas.com\""
)

#
# @brief  Send an email to admin
# @params Values required message and admin email address
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __sendemail "$MSG" "$EMAIL"
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#    # true
#    # notify admin | user
# else
#    # false
#    # missing argument | missing tool 
#    # return $NOT_SUCCESS
#    # or
#    # exit 128
# fi
#
function send_mail {
    local EMSG=$1 EMAIL=$2
    if [ "${TOOL_NOTIFY}" == "true" ]; then
        if [[ -n "${EMSG}" && -n "${EMAIL}" ]]; then
            local FUNC=${FUNCNAME[0]} MSG="None" STATUS HOST=$(hostname)
            declare -A config_send_mail=()
            load_util_conf "$UTIL_SEND_MAIL_CFG" config_send_mail
            STATUS=$?
            if [ $STATUS -eq $SUCCESS ]; then
                local SENDMAIL=${config_send_mail[SENDMAIL]}
                MSG="Send an email to Administrator!"
                info_debug_message "$MSG" "$FUNC" "$UTIL_SEND_MAIL"
                check_tool "${SENDMAIL}"
                STATUS=$?
                if [ $STATUS -eq $SUCCESS ]; then
                    local MLINE FMSG=${config_send_mail[SENDMAIL_MSG]}
                    local SMTEMPLATE=${config_send_mail[SENDMAIL_TEMPLATE]}
                    while read MLINE
                    do
                        eval echo -e "${MLINE}" >> ${FMSG}
                    done < ${SMTEMPLATE}
                    eval "${SENDMAIL} < ${FMSG}"
                    rm -f "${FMSG}"
                    MSG="Sent email to Administrator!"
                    info_debug_message "$MSG" "$FUNC" "$UTIL_SEND_MAIL"
                    info_debug_message_end "Done" "$FUNC" "$UTIL_SEND_MAIL"
                    return $SUCCESS
                fi
                MSG="Force exit!"
                info_debug_message_end "$MSG" "$FUNC" "$UTIL_SEND_MAIL"
                return $NOT_SUCCESS
            fi
            MSG="Force exit!"
            info_debug_message_end "$MSG" "$FUNC" "$UTIL_SEND_MAIL"
            return $NOT_SUCCESS
        fi
        usage SEND_MAIL_USAGE
        return $NOT_SUCCESS
    fi
    return $SUCCESS
}

