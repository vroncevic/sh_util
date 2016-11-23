#!/bin/bash
#
# @brief   Identifying spam domains
# @version ver.1.0
# @date    Mon Jul 15 21:44:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_ISSPAMMER=isspammer
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/devel.sh

declare -A ISSPAMMER_USAGE=(
    [TOOL_NAME]="__$UTIL_ISSPAMMER"
    [ARG1]="[DOMAIN_NAME] Domain name"
    [EX-PRE]="# Example checking domain"
    [EX]="__$UTIL_ISSPAMMER domain.cc"	
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
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# local TXT=$(__get_txt $ERROR_CODE $LIST_QUERY)
#
function __get_txt() {
    local ERROR_CODE=$1
    local LIST_QUERY=$2
    local -a dns
    IFS=$ADR_IFS
    local dns=($ERROR_CODE)
    IFS=$WSP_IFS
    if [ "${dns[0]}" == '127' ]; then
        echo $(dig +short $LIST_QUERY -t txt)
    fi
}

#
# @brief  Get the dns address resource record
# @params Values required rev_dns and list_server
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __checkaddress "$REV_DNS" "$LIST_SERVER"
# local STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
#   # notify admin | user
# else
#   # false
# fi
#
function __checkaddress() {
    local REV_DNS=$1
    local LIST_SERVER=$2
    local reply
    local server
    local reason
    if [ -n "$REV_DNS" ] && [ -n "$LIST_SERVER" ]; then
        server=${1}${2}
        reply=$(dig +short ${server})
        if [ ${#reply} -gt 6 ]; then
            reason=$(__get_txt ${reply} ${server})
            reason=${reason:-${reply}}
        fi
        echo ${reason:-' not blacklisted.'}
    fi
    echo "nothing"
}

#
# @brief  Identifying spam domains
# @param  Value required domain name
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __isspammer "$DOMAIN_NAME"
# local STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
#   # notify admin | user
# else
#   # false
#   # missing argument | wrong argument
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __isspammer(){
    local DOMAIN_NAME=$1
    local MSG=""
    if [ -n "$DOMAIN_NAME" ]; then
		local FUNC=${FUNCNAME[0]}
		if [ "$TOOL_DBG" == "true" ]; then
        	MSG="Get address of [$1]"
			printf "$DSTA" "$UTIL_ISSPAMMER" "$FUNC" "$MSG"
		fi
        local ip_adr=$(dig +short $1)
        local dns_reply=${ip_adr:-' no answer '}
		if [ "$TOOL_DBG" == "true" ]; then        
			MSG="Found address [${dns_reply}]"
			printf "$DSTA" "$UTIL_ISSPAMMER" "$FUNC" "$MSG"
		fi
        if [ ${#ip_adr} -gt 6 ]; then
			printf "%s\n" "Identifying spam domains"
            declare query
            declare -a dns
            IFS=$ADR_IFS
            local dns=(${ip_adr})
            IFS=$WSP_IFS
            local r_dns="${dns[3]}"'.'"${dns[2]}"'.'"${dns[1]}"'.'"${dns[0]}"'.'
            printf "%s" " spamhaus.org says "
            printf "%s" " $(__checkaddress ${r_dns} 'sbl-xbl.spamhaus.org')"
            printf "%s" " ordb.org  says "
            printf "%s" " $(__checkaddress ${r_dns} 'relays.ordb.org')"
            printf "%s" " spamcop.net says "
            printf "%s" " $(__checkaddress ${r_dns} 'bl.spamcop.net')"
            printf "%s" " abuseat.org says "
            printf "%s" " $(__checkaddress ${r_dns} 'cbl.abuseat.org')"
            printf "%s" " Distributed Server Listings"
            printf "%s" " list.dsbl.org says "
            printf "%s" " $(__checkaddress ${r_dns} 'list.dsbl.org')"
            printf "%s" " multihop.dsbl.org says "
            printf "%s" " $(__checkaddress ${r_dns} 'multihop.dsbl.org')"
            printf "%s" " unconfirmed.dsbl.org says "
            printf "%s" " $(__checkaddress ${r_dns} 'unconfirmed.dsbl.org')"
			if [ "$TOOL_DBG" == "true" ]; then
				printf "$DEND" "$UTIL_ISSPAMMER" "$FUNC" "Done"
			fi
            return $SUCCESS
        fi
		MSG="Could not use that address"
		printf "$SEND" "$UTIL_ISSPAMMER" "$MSG"
        return $NOT_SUCCESS
    fi
    __usage $ISSPAMMER_USAGE
    return $NOT_SUCCESS
}

