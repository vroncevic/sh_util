#!/bin/bash
#
# @brief   Look up abuse contact to report a spammer
# @version ver.1.0
# @date    Mon Oct 12 22:11:32 2015
# @company None, free software to use 2015
# @author  Vladimir Roncevic <elektron.ronca@gmail.com>
#
if [ -z "$__SH_UTIL_SPAM_LOOKUP" ]; then
    readonly __SH_UTIL_SPAM_LOOKUP=1

    UTIL_SPAM_LOOKUP=spam_lookup
    UTIL_SPAM_LOOKUP_VERSION=ver.1.0
    UTIL=/root/scripts/sh_util/${UTIL_SPAM_LOOKUP_VERSION}
    UTIL_SPAM_LOOKUP_CFG=${UTIL}/conf/${UTIL_SPAM_LOOKUP}.cfg
    UTIL_LOG=${UTIL}/log

    .    ${UTIL}/bin/check_tool.sh
    .    ${UTIL}/bin/load_util_conf.sh

    declare -A SPAM_LOOKUP_USAGE=(
        [USAGE_TOOL]="${UTIL_SPAM_LOOKUP}"
        [USAGE_ARG1]="[DOMAIN] Domain name"
        [USAGE_EX_PRE]="# Example check www.domain.cc"
        [USAGE_EX]="${UTIL_SPAM_LOOKUP} www.domain.cc"
    )

    #
    # @brief  Look up abuse contact to report a spammer
    # @param  Value required domain name
    # @retval Success return 0, else return 1
    #
    # @usage
    # @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    #
    # spam_lookup "$DOMAIN"
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
    function spam_lookup {
        local DOMAIN=$1
        if [ -z "${DOMAIN}" ]; then
            usage SPAM_LOOKUP_USAGE
            return $NOT_SUCCESS
        fi
        local FUNC=${FUNCNAME[0]} MSG="None" STATUS
        declare -A config_spam_lookup=()
        load_util_conf "$UTIL_SPAM_LOOKUP_CFG" config_spam_lookup
        STATUS=$?
        if [ $STATUS -eq $SUCCESS ]; then
            local DIG=${config_spam_lookup[DIG]}
            MSG="Look up abuse contact to report a spammer!"
            info_debug_message "$MSG" "$FUNC" "$UTIL_SPAM_LOOKUP"
            check_tool "${DIG}"
            STATUS=$?
            if [ $STATUS -eq $NOT_SUCCESS ]; then
                MSG="Force exit!"
                info_debug_message_end "$MSG" "$FUNC" "$UTIL_SPAM_LOOKUP"
                return $NOT_SUCCESS
            fi
            eval "${DIG} +short ${DOMAIN}.contacts.abuse.net -c in -t txt"
            info_debug_message_end "Done" "$FUNC" "$UTIL_SPAM_LOOKUP"
            return $SUCCESS
        fi
        MSG="Force exit!"
        info_debug_message_end "$MSG" "$FUNC" "$UTIL_SPAM_LOOKUP"
        return $NOT_SUCCESS
    }
fi
