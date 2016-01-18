#!/bin/bash
#
# @brief   Identifying spam domains
# @version ver.1.0
# @date    Mon Jul 15 21:44:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
TOOL_NAME=isspammer
TOOL_VERSION=ver.1.0
TOOL_EXECUTABLE="${BASH_SOURCE[0]}"
TOOL_BIN=`dirname $TOOL_EXECUTABLE`
TOOL_HOME=`dirname $TOOL_BIN`
TOOL_LOG=$TOOL_HOME/log

. $TOOL_BIN/usage.sh
. $TOOL_BIN/logging.sh

SUCCESS=0
NOT_SUCCESS=1

declare -A TOOL_USAGE=(
    [TOOL_NAME]="__$TOOL_NAME"
    [ARG1]="[DOMAIN_NAME] Domain name"
    [EX-PRE]="# Example checking domain"
    [EX]="__$TOOL_NAME domain.cc"	
)

declare -A LOG=(
    [TOOL]="$TOOL_NAME"
    [FLAG]="error"
    [PATH]="$TOOL_LOG"
    [MSG]=""
)

# Whitespace == :Space:Tab:Line Feed:Carriage Return
WSP_IFS=$'\x20'$'\x09'$'\x0A'$'\x0D'

# No Whitespace == Line Feed:Carriage Return
No_WSP=$'\x0A'$'\x0D'

# Field separator for dotted decimal ip addresses
ADR_IFS=${No_WSP}'.'

#
# @brief Get the dns text resource record
# @params Values required error_code and list_query
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# TXT=$(__get_txt $ERROR_CODE $LIST_QUERY)
#
function __get_txt() {
    ERROR_CODE=$1
    LIST_QUERY=$2
    local -a dns
    IFS=$ADR_IFS
    dns=($ERROR_CODE)
    IFS=$WSP_IFS
    if [ "${dns[0]}" == '127' ]; then
        echo $(dig +short $LIST_QUERY -t txt)
    fi
}

#
# @brief Get the dns address resource record
# @params Values required rev_dns and list_server
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __addnewtool $TOOL_NAME
# ADDED=$?
#
# if [ $ADDED -eq $SUCCESS ]; then
#	# true
# else
#	# false
# fi
#
function __checkaddress() {
    REV_DNS=$1
    LIST_SERVER=$2
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
# @brief Identifying spam domains
# @argument Value required domain name
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __isspammer $DOMAIN_NAME
# STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#	# true
# else
#	# false
# fi
#
function __isspammer(){
    DOMAIN_NAME=$1
    if [ -n "$DOMAIN_NAME" ]; then
        printf "%s\n" "Get address of [$1]"
        ip_adr=$(dig +short $1)
        dns_reply=${ip_adr:-' no answer '}
        printf "%s\n" "Found address [${dns_reply}]"
        if [ ${#ip_adr} -gt 6 ]; then
            declare query
            declare -a dns
            IFS=$ADR_IFS
            dns=(${ip_adr})
            IFS=$WSP_IFS
            rev_dns="${dns[3]}"'.'"${dns[2]}"'.'"${dns[1]}"'.'"${dns[0]}"'.'
            printf "%s" " spamhaus.org says "
            printf "%s" " $(__checkaddress ${rev_dns} 'sbl-xbl.spamhaus.org')"
            printf "%s" " ordb.org  says "
            printf "%s" " $(__checkaddress ${rev_dns} 'relays.ordb.org')"
            printf "%s" " spamcop.net says "
            printf "%s" " $(__checkaddress ${rev_dns} 'bl.spamcop.net')"
            printf "%s" " abuseat.org says "
            printf "%s" " $(__checkaddress ${rev_dns} 'cbl.abuseat.org')"
            printf "%s" " Distributed Server Listings"
            printf "%s" " list.dsbl.org says "
            printf "%s" " $(__checkaddress ${rev_dns} 'list.dsbl.org')"
            printf "%s" " multihop.dsbl.org says "
            printf "%s" " $(__checkaddress ${rev_dns} 'multihop.dsbl.org')"
            printf "%s" " unconfirmed.dsbl.org says "
            printf "%s" " $(__checkaddress ${rev_dns} 'unconfirmed.dsbl.org')"
            return $SUCCESS
        fi
        printf "%s\n" "Could not use that address"
        return $NOT_SUCCESS
    fi
    __usage $TOOL_USAGE
    LOG[MSG]="Missing argument"
    __logging $LOG
    return $NOT_SUCCESS
}
