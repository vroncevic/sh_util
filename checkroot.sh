#!/bin/bash
#
# @brief   Check root permission
# @version ver.1.0
# @date    Mon Jun 01 18:36:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#

SUCCESS=0
NOT_SUCCESS=1

# 
# @brief Check root permission
# @retval success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __checkroot
# CHECK_ROOT=$?
#
# if [ $CHECK_ROOT -eq $SUCCESS ]; then
#	# true
# else
#	# false
# fi
#
function __checkroot() {
    printf "%s" "Check permissions "
    if [ "$(id -u)" != "0" ] || [ $EUID -ne $SUCCESS ]; then
        printf "%s\n" "[not ok]"
        printf "%s\n" "[$USER] this App/Tool/Script must run as ROOT !"
        return $NOT_SUCCESS
    fi
    printf "%s\n" "[ok]"
    return $SUCCESS
}
