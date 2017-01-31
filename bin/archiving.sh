#!/bin/bash
#
# @brief   Archiving target files
# @version ver.1.0
# @date    Mon Jul 15 21:48:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_ARCHIVING=archiving
UTIL_ARCHIVING_VERSION=ver.1.0
UTIL=/root/scripts/sh_util/${UTIL_ARCHIVING_VERSION}
UTIL_LOG=${UTIL}/log

.	${UTIL}/bin/devel.sh
.	${UTIL}/bin/usage.sh

declare -A TAR_ARCHIVING_USAGE=(
	[USAGE_TOOL]="__make_archive_tar"
	[USAGE_ARG1]="[ARCHIVE_STRUCTURE]  Path and file extension"
	[USAGE_EX_PRE]="# Example create tar archive with png files"
	[USAGE_EX]="__make_archive_tar \$ARCH_STRUCT"
)

declare -A GZ_ARCHIVING_USAGE=(
	[USAGE_TOOL]="__make_archive_tar_gz"
	[USAGE_ARG1]="[ARCHIVE_STRUCTURE]  Path, file extension and archive name"
	[USAGE_EX_PRE]="# Example create tar gz archive with gif images"
	[USAGE_EX]="__make_archive_tar_gz \$ARCH_STRUCT"
)

#
# @brief  Find files by name and archive in *.tar format
# @param  Value required structure (location and file name)
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# declare -A AR_STRUCT=(
#	[PATH]="/some-path/"
#	[FILE]="*.png"
# )
#
# __make_archive_tar AR_STRUCT
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#	# true
#	# notify admin | user
# else
#	# false
#	# missing agrument(s) | failed to generate archive
#	# return $NOT_SUCCESS
#	# or 
#	# exit 128
# fi
#
function __make_archive_tar() {
	local -n AR_STRUCT=$1
	local LOC=${AR_STRUCT[PATH]} FILE=${AR_STRUCT[FILE]}
	if [[ -n "${LOC}" && -n "${FILE}" ]]; then
		local FUNC=${FUNCNAME[0]} MSG="None" XARGS="xargs tar -cvf"
		local FIND="find ${LOC} -type f -name ${FILE}"
		local ARCHIVE="${LOC}/`date '+%d%m%Y'_archive.tar`"
		MSG="Generating archive [${ARCHIVE}]!"
		__info_debug_message "$MSG" "$FUNC" "$UTIL_ARCHIVING"
		eval "${FIND} | ${XARGS} ${ARCHIVE}"
		__info_debug_message_end "Done" "$FUNC" "$UTIL_ARCHIVING"
		return $SUCCESS
	fi
	__usage TAR_ARCHIVING_USAGE
	return $NOT_SUCCESS
}

#
# @brief  Find files by name and archive in *.tar 
# @param  Value required structure path, file name and archive
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# declare -A AR_STRUCT=(
#	[PATH]="/some-path/"
#	[FILE]="*.png"
#	[ARCH]="pngimages"
# )
#
# __make_archive_tar_gz AR_STRUCT
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#	# true
#	# notify admin | user
# else
#	# false
#	# missing agrument(s) | failed to generate archive
#	# return $NOT_SUCCESS
#	# or 
#	# exit 128
# fi
#
function __make_archive_tar_gz() {
	local -n AR_STRUCT=$1
	local LOC=${AR_STRUCT[PATH]} FILE=${AR_STRUCT[FILE]} ARC=${AR_STRUCT[ARCH]}
	if [[ -n "${LOC}" && -n "${FILE}" && -n "${ARC}" ]]; then
		local FUNC=${FUNCNAME[0]} MSG="None" XARGS="xargs tar -cvzf"
		local FIND="find ${LOC} -name ${FILE} -type f -print"
		local ARCHIVE="${LOC}/${ARC}.tar.gz"
		MSG="Generating archive [${ARCHIVE}]!"
		__info_debug_message "$MSG" "$FUNC" "$UTIL_ARCHIVING"
		eval "${FIND} | ${XARGS} ${ARCHIVE}"
		__info_debug_message_end "Done" "$FUNC" "$UTIL_ARCHIVING"
		return $SUCCESS
	fi
	__usage GZ_ARCHIVING_USAGE
	return $NOT_SUCCESS
}

