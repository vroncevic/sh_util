#!/bin/bash
#
# @brief   Creating employee directory structure
# @version ver.1.0
# @date    Mon Jun 04 12:38:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_EMPLOYEE=employee
UTIL_EMPLOYEE_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_EMPLOYEE_VERSION
UTIL_EMPLOYEE_CFG=$UTIL/conf/$UTIL_EMPLOYEE.cfg
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/loadutilconf.sh
. $UTIL/bin/devel.sh

declare -A IT_PROFILE_USAGE=(
    [TOOL]="__ituserprofile"
    [ARG1]="[USERNAME]  employee username"
    [EX-PRE]="# Example generating IT profile"
    [EX]="__ituserprofile vroncevic"	
)

declare -A USER_PROFILE_USAGE=(
    [TOOL]="__shareuserprofile"
    [ARG1]="[SHARE_STRUCTURE]   System username and groip"
    [EX-PRE]="# Example generating user profile"
    [EX]="__shareuserprofile \$SHARE_STRUCTURE"	
)

declare -A SHARE_PROFILE_USAGE=(
    [TOOL]="__homefrobas"
    [ARG1]="[HOME_STRUCTURE]   System username and group"
    [EX-PRE]="# Example generatingshare profile"
    [EX]="__homefrobas \$HOME_STRUCTURE"	
)

#
# @brief  Create employee profile directory at IT disk
# @param  Value required username (system username)
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# local UNAME="vroncevic"
# __ituserprofile "$UNAME"
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#   # true
#	# notify admin | user
# else
#   # false
#	# missing argument | failed to load config file | user profile already exist
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __ituserprofile() {
    local USERNAME=$1
    if [ -n "$USERNAME" ]; then
		local FUNC=${FUNCNAME[0]}
		local MSG=""
		declare -A configituserprofileutil=()
		local CURRENT_YEAR=$(date +'%Y')
		__loadutilconf "$UTIL_EMPLOYEE_CFG" configituserprofileutil
		local STATUS=$?
		if [ $STATUS -eq $SUCCESS ]; then
			local ITDIR=${configituserprofileutil[ITEDIR]}
			local R_DIR="$ITDIR/$CURRENT_YEAR/$USERNAME"
			if [ "$TOOL_DBG" == "true" ]; then
				MSG="Checking dir [$R_DIR/]"
				printf "$DQUE" "$UTIL_EMPLOYEE" "$FUNC" "$MSG"
			fi
			if [ ! -d "$R_DIR/" ]; then
				if [ "$TOOL_DBG" == "true" ]; then
					printf "%s\n" "[not exist]"
					MSG="Creating IT profile structure for [$USERNAME]"
					printf "$DSTA" "$UTIL_EMPLOYEE" "$FUNC" "$MSG"
				fi
				mkdir "$R_DIR/"
				mkdir "$R_DIR/dig_certificate/"
				mkdir "$R_DIR/image_profile/"
				mkdir "$R_DIR/ip_phone/"
				mkdir "$R_DIR/mail_backup/"
				mkdir "$R_DIR/mail_signature/"
				mkdir "$R_DIR/openvpn/"
				mkdir "$R_DIR/pgp_key/"
				mkdir "$R_DIR/ssh_config/"
				mkdir "$R_DIR/vnc/"
				if [ "$TOOL_DBG" == "true" ]; then
					printf "$DSTA" "$UTIL_EMPLOYEE" "$FUNC" "Set owner"
				fi
				local PRFX_CMD="chown -R"
				local OWNER="${configituserprofileutil[UID]}.${configituserprofileutil[GID]}"
				eval "$PRFX_CMD $OWNER $R_DIR/"
				if [ "$TOOL_DBG" == "true" ]; then            
					printf "$DSTA" "$UTIL_EMPLOYEE" "$FUNC" "Set permission"
				fi
				chmod -R 770 "$R_DIR/"
				if [ "$TOOL_DBG" == "true" ]; then            
					printf "$DEND" "$UTIL_EMPLOYEE" "$FUNC" "Done"
				fi
				return $SUCCESS
			fi
			if [ "$TOOL_DBG" == "true" ]; then
				printf "%s\n" "[already exist]"
			fi
			MSG="IT user profile [$USERNAME] already exist"
			printf "$SEND" "$UTIL_EMPLOYEE" "$MSG"
		fi
		return $NOT_SUCCESS
    fi 
    __usage $IT_PROFILE_USAGE
    return $NOT_SUCCESS
}

#
# @brief  Create Employee Profile Directory SHARE
# @params Values required username (system username) and department
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# declare -A SHARE_STRUCTURE=()
# SHARE_STRUCTURE[USERNAME]="vroncevic"
# SHARE_STRUCTURE[DEPARTMENT]="users"
#
# __shareuserprofile $SHARE_STRUCTURE
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#   # true
#	# notify admin | user
# else
#   # false
#	# missing argument | missing config file | user profile already exist
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __shareuserprofile() {
	local SHARE_STRUCTURE=$1
    local USERNAME=${SHARE_STRUCTURE[USERNAME]}
    local DEPARTMENT=${SHARE_STRUCTURE[DEPARTMENT]}
    if [ -n "$USERNAME" ] && [ -n "$DEPARTMENT" ]; then
		local FUNC=${FUNCNAME[0]}
		local MSG=""
		declare -A configituserprofileutil=()
		__loadutilconf $UTIL_EMPLOYEE_CFG configituserprofileutil
		local STATUS=$?
		if [ $STATUS -eq $SUCCESS ]; then
			local R_DIR="$EMPLOYEE_DIR/$USERNAME"
			if [ "$TOOL_DBG" == "true" ]; then
				MSG="Checking dir [$R_DIR/]"
				printf "$DQUE" "$UTIL_EMPLOYEE" "$FUNC" "$MSG"
			fi
			if [ ! -d "$R_DIR/" ]; then
				if [ "$TOOL_DBG" == "true" ]; then
					printf "%s\n" "[not exist]"
					MSG="Creating profile structure for [$USERNAME]"
					printf "$DSTA" "$UTIL_EMPLOYEE" "$FUNC" "$MSG"
				fi
				mkdir "$R_DIR/"
				mkdir "$R_DIR/backup/"
				mkdir "$R_DIR/baazar/"
				mkdir "$R_DIR/CV/"
				mkdir "$R_DIR/img/"
				mkdir "$R_DIR/PGP-Key/"
				mkdir "$R_DIR/SMIME-cert/"
				chmod -R 777 "$R_DIR/"
				if [ "$TOOL_DBG" == "true" ]; then
					printf "$DSTA" "$UTIL_EMPLOYEE" "$FUNC" "Set owner"
				fi
				local BACKUP="$R_DIR/backup/"
				local PRFX_CMD="chown -R"
				local OWNER="${configituserprofileutil[UNAME]}.${configituserprofileutil[GRP]}" 
				eval "$PRFX_CMD $OWNER $BACKUP"
				if [ "$TOOL_DBG" == "true" ]; then            
					printf "$DSTA" "$UTIL_EMPLOYEE" "$FUNC" "Set permission"
				fi
				chmod -R 700 "$BACKUP"
				if [ "$TOOL_DBG" == "true" ]; then            
					printf "$DEND" "$UTIL_EMPLOYEE" "$FUNC" "Done"
				fi
				return $SUCCESS
			fi
			if [ "$TOOL_DBG" == "true" ]; then
				printf "%s\n\n" "[already exist]"
			fi
			MSG="Share user profile [$USERNAME] already exist"
			printf "$SEND" "$UTIL_EMPLOYEE" "$MSG"
		fi
		return $NOT_SUCCESS
    fi 
    __usage $USER_PROFILE_USAGE
    return $NOT_SUCCESS
}

#
# @brief  Create frobas support directory at user HOME directory
# @params Values required structure username and department
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# declare -A HOME_STRUCTURE=()
# HOME_STRUCTURE[USERNAME]="vroncevic"
# HOME_STRUCTURE[DEPARTMENT]="users"
#
# __homefrobas $HOME_STRUCTURE
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#   # true
#	# notify admin | user
# else
#   # false
#	# missing argument | user profile already exist
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __homefrobas() {
	local HOME_STRUCTURE=$1
    local USERNAME=${HOME_STRUCTURE[USERNAME]}
    local DEPARTMENT=${HOME_STRUCTURE[DEPARTMENT]}
    if [ -n "$USERNAME" ] && [ -n "$DEPARTMENT" ]; then
		local FUNC=${FUNCNAME[0]}
		local MSG=""
		local R_DIR="/home/$USERNAME/frobas"
		if [ "$TOOL_DBG" == "true" ]; then
			MSG="Checking dir [$R_DIR/]"
			printf "$DQUE" "$UTIL_EMPLOYEE" "$FUNC" "$MSG"
		fi
		if [ ! -d "$R_DIR/" ]; then
			if [ "$TOOL_DBG" == "true" ]; then            
				printf "%s\n" "[not exist]"
				MSG="Creating structure [$R_DIR/]"
				printf "$DSTA" "$UTIL_EMPLOYEE" "$FUNC" "$MSG"
			fi
			mkdir "$R_DIR/"
			mkdir "$R_DIR/openvpn/"
			mkdir "$R_DIR/mail_signature"
			mkdir "$R_DIR/smime/"
			mkdir "$R_DIR/pgp/"
			mkdir "$R_DIR/pgp/private_key/"
			mkdir "$R_DIR/pgp/public_key"
			if [ "$TOOL_DBG" == "true" ]; then            
				printf "$DSTA" "$UTIL_EMPLOYEE" "$FUNC" "Set owner"
			fi
			local PRFX_CMD="chown -R" 
			local OWNER="$USERNAME.$DEPARTMENT"
			eval "$PRFX_CMD $OWNER $R_DIR/"			
			if [ "$TOOL_DBG" == "true" ]; then
				printf "$DSTA" "$UTIL_EMPLOYEE" "$FUNC" "Set permission"
			fi
			chmod -R 700 "$R_DIR/"
			if [ "$TOOL_DBG" == "true" ]; then            
				printf "$DEND" "$UTIL_EMPLOYEE" "$FUNC" "Done"
			fi
			return $SUCCESS
		fi
		if [ "$TOOL_DBG" == "true" ]; then
			printf "%s\n" "[already exist]"
		fi
		MSG="home structure for [$USERNAME] already exist"
		printf "$SEND" "$UTIL_EMPLOYEE" "$MSG"
        return $NOT_SUCCESS
    fi 
    __usage $SHARE_PROFILE_USAGE
    return $NOT_SUCCESS
}

