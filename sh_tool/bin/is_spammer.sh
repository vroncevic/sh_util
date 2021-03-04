#!/bin/bash
#
# @brief   Identifying spam domains
# @version ver.1.0.0
# @date    Mon Jul 15 21:44:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_IS_SPAMMER=is_spammer
UTIL_IS_SPAMMER_VERSION=ver.1.0.0
UTIL=/root/scripts/sh_util/${UTIL_IS_SPAMMER_VERSION}
UTIL_LOG=${UTIL}/log

.    ${UTIL}/bin/devel.sh
.    ${UTIL}/bin/usage.sh

declare -A IS_SPAMMER_Usage=(
    [USAGE_TOOL]="${UTIL_IS_SPAMMER}"
    [USAGE_ARG1]="[DOMAIN] Domain name"
    [USAGE_EX_PRE]="# Example checking domain"
    [USAGE_EX]="${UTIL_IS_SPAMMER} domain.cc"
)

# Whitespace == :Space:Tab:Line Feed:Carriage Return
WSP_IFS=$'\x20'$'\x09'$'\x0A'$'\x0D'

# No Whitespace == Line Feed:Carriage Return
No_WSP=$'\x0A'$'\x0D'

# Field separator for dotted decimal ip addresses
ADR_IFS=${No_WSP}'.'

#
# @brief  Get the dns text resource record
# @params Values required error_code and list_query
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# local TXT=$(get_txt $ERRCODE $LISTQUERY)
#
function get_txt {
    local ERRCODE=$1 LISTQUERY=$2
    declare -a dns
    IFS=${ADR_IFS}
    dns=(${ERRCODE})
    IFS=${WSP_IFS}
    if [ "${dns[0]}" == "127" ]; then
        echo $(dig +short ${LISTQUERY} -t txt)
    fi
}

#
# @brief  Get the dns address resource record
# @params Values required rev_dns and list_server
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# check_address "$REVDNS" "$LISTSERVER"
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#    # true
#    # notify admin | user
# else
#   # false
# fi
#
function check_address {
    local REVDNS=$1 LISTSERVER=$2 REPLY SERVER REASON
    if [[ -n "${REVDNS}" && -n "${LISTSERVER}" ]]; then
        SERVER=${REVDNS}${LISTSERVER}
        REPLY=$(dig +short ${SERVER})
        if [ ${#reply} -gt 6 ]; then
            REASON=$(get_txt ${REPLY} ${SERVER})
            REASON=${REASON:-${REPLY}}
        fi
        echo ${REASON:-' not blacklisted.'}
    fi
    echo "nothing"
}

#
# @brief  Identifying spam domains
# @param  Value required domain name
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# is_spammer "$DOMAIN"
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
function is_spammer(){
    local DOMAIN=$1
    if [ -n "${DOMAIN}" ]; then
        local FUNC=${FUNCNAME[0]} MSG="None"
        MSG="Get address of [${DOMAIN}]!"
        info_debug_message "$MSG" "$FUNC" "$UTIL_IS_SPAMMER"
        local IPADR=$(dig +short ${DOMAIN}) DNSREPLY=${IPADR:-' no answer '}
        MSG="Found address [${DNSREPLY}]!"
        info_debug_message "$MSG" "$FUNC" "$UTIL_IS_SPAMMER"
        if [ ${#IPADR} -gt 6 ]; then
            printf "%s\n" "Identifying spam domains"
            declare query
            declare -a DNS
            IFS=${ADR_IFS}
            dns=(${IPADR})
            IFS=${WSP_IFS}
            local R_DNS="${DNS[3]}"'.'"${DNS[2]}"'.'"${DNS[1]}"'.'"${DNS[0]}"'.'
            printf "%s" " spamhaus.org says "
            printf "%s" " $(check_address ${R_DNS} 'sbl-xbl.spamhaus.org')"
            printf "%s" " ordb.org  says "
            printf "%s" " $(check_address ${R_DNS} 'relays.ordb.org')"
            printf "%s" " spamcop.net says "
            printf "%s" " $(check_address ${R_DNS} 'bl.spamcop.net')"
            printf "%s" " abuseat.org says "
            printf "%s" " $(check_address ${R_DNS} 'cbl.abuseat.org')"
            printf "%s" " Distributed Server Listings"
            printf "%s" " list.dsbl.org says "
            printf "%s" " $(check_address ${R_DNS} 'list.dsbl.org')"
            printf "%s" " multihop.dsbl.org says "
            printf "%s" " $(check_address ${R_DNS} 'multihop.dsbl.org')"
            printf "%s" " unconfirmed.dsbl.org says "
            printf "%s" " $(check_address ${R_DNS} 'unconfirmed.dsbl.org')"
            info_debug_message_end "Done" "$FUNC" "$UTIL_IS_SPAMMER"
            return $SUCCESS
        fi
        MSG="Could not use that address!"
        info_debug_message "$MSG" "$FUNC" "$UTIL_IS_SPAMMER"
        MSG="Force exit!"
        info_debug_message_end "$MSG" "$FUNC" "$UTIL_IS_SPAMMER"
        return $NOT_SUCCESS
    fi
    usage IS_SPAMMER_Usage
    return $NOT_SUCCESS
}

