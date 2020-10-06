#!/bin/bash
#
# @brief   Generating email signature
# @version ver.1.0.0
# @date    Thu Jun  06 01:25:41 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
# 
UTIL_EMAIl_SIGN=email_sign
UTIL_EMAIl_SIGN_VERSION=ver.1.0
UTIL=/root/scripts/sh_util/${UTIL_EMAIl_SIGN_VERSION}
UTIL_CFG_ESIGNATURE=${UTIL}/conf/${UTIL_EMAIl_SIGN}.cfg
UTIL_LOG=${UTIL}/log

.    ${UTIL}/bin/devel.sh
.    ${UTIL}/bin/usage.sh
.    ${UTIL}/bin/load_util_conf.sh

declare -A EMAIL_SIGN_Usage=(
    [Usage_TOOL]="${UTIL_EMAIl_SIGN}"
    [Usage_ARG1]="[NAME] Full name"
    [Usage_ARG2]="[WP] Work position"
    [Usage_ARG3]="[DN] Department"
    [Usage_ARG4]="[IP] IP phone number"
    [Usage_ARG5]="[MOB] Mobile number"
    [Usage_ARG6]="[EMAIL] Email address"
    [Usage_EX_PRE]="# Example generating email signature"
    [Usage_EX]="${UTIL_EMAIl_SIGN} SIGN_STRUCT"
)

#
# @brief  Generate email signature for employee
# @param  Value required structure
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# declare -A SIGN_STRUCT=(
#    [NAME]=$name # Full name
#    [WP]=$wp # Work position as engineer, developer
#    [DN]=$dn # Electronic, Design Service
#    [IP]=$ip # IP phone number
#    [MOB]=$mobile # Mobile phone number
#    [EMAIL]=$email # Email address
# )
#
# email_sign SIGN_STRUCT
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#    # true
#    # notify admin | user
# else
#    # false
#    # missing argument(s) | missing config file | failed to load config
#    # return $NOT_SUCCESS
#    # or
#    # exit 128
# fi
#
function email_sign {
    local -n SIGN_STRUCT=$1
    if [ ${#SIGN_STRUCT[@]} -eq 6 ] ; then
        local FUNC=${FUNCNAME[0]} MSG="None" STATUS
        local NAME=${SIGN_STRUCT[NAME]} WP=${SIGN_STRUCT[WP]}
        local DN=${SIGN_STRUCT[DN]} IP=${SIGN_STRUCT[IP]}
        local MOB=${SIGN_STRUCT[MOB]} EMAIL=${SIGN_STRUCT[EMAIL]}
        declare -A STATUS_STRUCT=()
        if [[ -n "$NAME" && -n "$WP" ]]; then
            STATUS_STRUCT[NAME]=$SUCCESS
            STATUS_STRUCT[WP]=$SUCCESS
            if [[ -n "$DN" && -n "$IP" ]]; then
                STATUS_STRUCT[DN]=$SUCCESS
                STATUS_STRUCT[IP]=$SUCCESS
                if [[ -n "$MOB" && -n "$EMAIL" ]]; then
                    STATUS_STRUCT[MOB]=$SUCCESS
                    STATUS_STRUCT[EMAIL]=$SUCCESS
                else
                    STATUS_STRUCT[MOB]=$NOT_SUCCESS
                    STATUS_STRUCT[EMAIL]=$NOT_SUCCESS
                fi
            else
                STATUS_STRUCT[DN]=$NOT_SUCCESS
                STATUS_STRUCT[IP]=$NOT_SUCCESS
            fi
        else
            STATUS_STRUCT[NAME]=$NOT_SUCCESS
            STATUS_STRUCT[WP]=$NOT_SUCCESS
        fi
        check_status STATUS_STRUCT
        STATUS=$?
        if [ $STATUS -eq $NOT_SUCCESS ]; then
            usage EMAIL_SIGN_Usage
            return $NOT_SUCCESS
        fi
        declare -A config_email_sign=()
        load_util_conf $UTIL_CFG_ESIGNATURE config_email_sign
        STATUS=$?
        if [ $STATUS -eq $SUCCESS ]; then
            local CDIR=${config_email_sign[COMPANY_EMPLOYEES]} SLINE
            MSG="Checking directory [${CDIR}/]?"
            info_debug_message_que "$MSG" "$FUNC" "$UTIL_EMAIl_SIGN"
            if [ -d "${CDIR}/" ]; then
                MSG="[ok]"
                info_debug_message_ans "$MSG" "$FUNC" "$UTIL_EMAIl_SIGN"
                local COMPANY COMPANY_SITE COMPANY_ADDRESS COMPANY_STATE
                local COMPANY_PHONE COMPANY_FAX
                COMPANY=${config_email_sign[COMPANY_NAME]}
                COMPANY_SITE=${config_email_sign[COMPANY_SITE]}
                COMPANY_ADDRESS=${config_email_sign[COMPANY_ADDRESS]}
                COMPANY_STATE=${config_email_sign[COMPANY_STATE]}
                COMPANY_PHONE=${config_email_sign[COMPANY_PHONE]}
                COMPANY_FAX=${config_email_sign[COMPANY_FAX]}
                echo -e "$SIGNATURE_CONTENT" > "$CDIR/$NAME"
                MSG="Set permission!"
                info_debug_message "$MSG" "$FUNC" "$UTIL_EMAIl_SIGN"
                eval "chmod 644 ${CDIR}/${NAME}"
                info_debug_message_end "Done" "$FUNC" "$UTIL_EMAIl_SIGN"
                return $SUCCESS
            fi
            MSG="[not ok]"
            info_debug_message_ans "$MSG" "$FUNC" "$UTIL_EMAIl_SIGN"
            MSG="Please check directory [${CDIR}/]!"
            info_debug_message "$MSG" "$FUNC" "$UTIL_EMAIl_SIGN"
            MSG="Force exit!"
            info_debug_message_end "$MSG" "$FUNC" "$UTIL_EMAIl_SIGN"
            return $NOT_SUCCESS
        fi
        MSG="Force exit!"
        info_debug_message_end "$MSG" "$FUNC" "$UTIL_EMAIl_SIGN"
        return $NOT_SUCCESS
    fi
    usage EMAIL_SIGN_Usage
    return $NOT_SUCCESS
}

