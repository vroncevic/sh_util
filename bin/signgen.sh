#!/bin/bash
#
# @brief   Generating email signature
# @version ver.1.0
# @date    Thu Jun  06 01:25:41 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
# 
UTIL_SIGNGEN=signgen
UTIL_SIGNGEN_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_SIGNGEN_VERSION
UTIL_CFG_SIGNGEN=$UTIL/conf/$UTIL_SIGNGEN.cfg
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/loadutilconf.sh
. $UTIL/bin/devel.sh

declare -A SIGNGEN_USAGE=(
    ["TOOL"]="__$UTIL_SIGNGEN"
    ["ARG1"]="[SIGNATURE_STRUCTURE] Full name, work position"
    ["EX-PRE"]="# Example generating email signature"
    ["EX"]="__$UTIL_SIGNGEN \$SIGNATURE_STRUCTURE"	
)

#
# @brief  Generate email signature for employee
# @param  Value required structure
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# declare -A SIGNATURE_STRUCTURE=()
# SIGNATURE_STRUCTURE["NAME"]=$name      # Full name
# SIGNATURE_STRUCTURE["WP"]=$wp          # Work position as eenginer, developer
# SIGNATURE_STRUCTURE["DN"]=$dn          # Electronic, Design Service
# SIGNATURE_STRUCTURE["IP"]=$ip          # IP phone number
# SIGNATURE_STRUCTURE["MOBILE"]=$mobile  # Mobile phone number
# SIGNATURE_STRUCTURE["EMAIL"]=$email    # Email address
# 
# __signgen "$(declare -p SIGNATURE_STRUCTURE)"
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#   # true
#   # notify admin | user
# else
#   # false
#   # missing argument(s) | missing config file | failed to load config
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __signgen() {
	eval "declare -A SIGNATURE_STRUCTURE="${1#*=}
    local NAME=${SIGNATURE_STRUCTURE["NAME"]}
    local WORKPOSITION=${SIGNATURE_STRUCTURE["WP"]}
    local DEPARTMENT=${SIGNATURE_STRUCTURE["DN"]}
    local IP=${SIGNATURE_STRUCTURE["IP"]}
    local MOBILE=${SIGNATURE_STRUCTURE["MOBILE"]}
    local EMAIL=${SIGNATURE_STRUCTURE["EMAIl"]}
    if [ -n "$NAME" ] && [ -n "$WORKPOSITION" ] && [ -n "$DEPARTMENT" ] &&
       [ -n "$IP" ] && [ -n "$MOBILE" ] && [ -n "$EMAIL" ] ; then
		local FUNC=${FUNCNAME[0]}
		local MSG=""
		declare -A configsigngen=()
		__loadutilconf $UTIL_CFG_SIGNGEN configsigngen
		local STATUS=$?
		if [ $STATUS -eq $SUCCESS ]; then
			if [ "$TOOL_DBG" == "true" ]; then
				MSG="Checking dir [$configsigngen[COMPANY_EMPLOYEE]/]"
				printf "$DQUE" "$UTIL_SIGNGEN" "$FUNC" "$MSG"
			fi
			if [ -d "$configsigngen[COMPANY_EMPLOYEE]" ]; then
				local SIGNATURE_FILE="
<html>

    <head>
        <title>$configsigngen[COMPANY_NAME]</title>
        <style>
            table-params {
                border: 0;
                border-spacing:2px;
            }

            tr {
                font-family: 'Calibri','sans-serif';
                color: #5B5B5B;
                font-size: 10pt;
            }

            td-com {
                padding-top:15px; 
                padding-bottom:1px; 
                padding-left: 10px;
                color: #5B5B5B; 
                font-family: 'Calibri','sans-serif'; 
                color: #5B5B5B; 
                font-size: 10pt;
            }

            td-com-address-label {
                padding-top:1px; 
                padding-bottom:1px; 
                color: #5B5B5B; 
                font-family: 'Calibri','sans-serif'; 
                color: #5B5B5B; 
                font-size: 10pt;
            }

            td-com-address {
                padding-top:1px; 
                padding-bottom:1px; 
                padding-left: 10px;
                color: #5B5B5B; 
                font-family: 'Calibri','sans-serif'; 
                color:  #5B5B5B; 
                font-size: 10pt;
            }

            td-com-phone-label {
                padding-top:1px; 
                padding-bottom:1px; 
                color: #5B5B5B; 
                font-family: 'Calibri','sans-serif'; 
                color: #5B5B5B; 
                font-size: 10pt;
            }

            td-com-phone {
                padding-top:1px; 
                padding-bottom:1px; 
                padding-left: 10px;
                color: #5B5B5B; 
                font-family:  'Calibri','sans-serif'; 
                color:  #5B5B5B; 
                font-size: 10pt;
            } 

            td-padding-left {
                padding-left: 10px;
            }
        </style>
    </head>
    
    <body bgcolor=\"#FFFFFF\" text=\"#000000\" >
        <table class=\"table-params\">
            <tr class=\"tr\">
                <td colspan=\"2\"><strong>$NAME</strong></td>
            </tr>
            <tr class=\"tr\">
                <td colspan=\"2\">$WORKPOSITION</td>
            </tr>
            <tr class=\"tr\">
                <td colspan=\"2\">$DEPARTMENT</td>
            </tr>
            <tr class=\"tr\">
                <td colspan=\"2\"><br/></td>
            </tr>
            <tr class=\"tr\">
                <td width=\"18%\">Phone: </td>
                <td class=\"td-padding-left\">$IP</td>
            </tr>
            <tr class=\"tr\">
                <td >Mobile: </td>
                <td class=\"td-padding-left\">$MOBILE</td>
            </tr>
            <tr class=\"tr\">
                <td >E-mail:</td>
                <td class=\"td-padding-left\">$EMAIL</td>
            </tr>
            <tr class=\"tr\">
                <td colspan=\"2\"><br/></td>
            </tr>
			<tr>
				<td colspan=\"2\" class=\"td-com\">$configsigngen[COMPANY_NAME]</td>
			</tr>
			<tr class=\"tr\">
				<td>Web </td>
				<td class=\"td-padding-left\">$configsigngen[COMPANY_SITE]</td>
			</tr>
			<tr>
				<td class=\"td-com-address-label\">Address</td>
				<td class=\"td-com-address\">$configsigngen[COMPANY_ADDRESS]</td>
			</tr>
			<tr>
				<td class=\"td-com-address-label\">State</td>
				<td class=\"td-com-address\">$configsigngen[COMPANY_STATE]</td>
			</tr>
			<tr>
				<td class=\"td-com-phone-label\">Tel</td>
				<td class=\"td-com-phone\">$configsigngen[COMPANY_PHONE]</td>
			</tr>
			<tr>
				<td class=\"td-com-phone-label\">Fax</td>
				<td class=\"td-com-phone\">$configsigngen[COMPANY_FAX]</td>
			</tr>
        </table>
    </body>
    
</html>
"
				echo -e "$SIGNATURE_FILE" > "$configsigngen[COMPANY_EMPLOYEE]/$NAME"
				if [ "$TOOL_DBG" == "true" ]; then
					printf "$DEND" "$UTIL_SIGNGEN" "$FUNC" "Done"
				fi
				return $SUCCESS
			fi
			MSG="Please check dir [$FROBAS_EMPLOYEE]"
			printf "$SEND" "$UTIL_SIGNGEN" "$MSG"
			return $NOT_SUCCESS
		fi
		return $NOT_SUCCESS
    fi
    __usage "$(declare -p SIGNGEN_USAGE)"
    return $NOT_SUCCESS
} 

