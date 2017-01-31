#!/bin/bash
#
# @brief   Get CPU speed
# @version ver.1.0
# @date    Mon Jul 15 21:44:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_CPU=cpu
UTIL_CPU_VERSION=ver.1.0
UTIL=/root/scripts/sh_util/${UTIL_CPU_VERSION}
UTIL_LOG=${UTIL}/log

.	${UTIL}/bin/devel.sh
.	${UTIL}/bin/usage.sh

declare -A CPU_USAGE=(
	[USAGE_TOOL]="__${UTIL_CPU}"
	[USAGE_ARG1]="[PSPEED] Show in GHz | MHz CPU speed"
	[USAGE_EX_PRE]="# Example show in GHz CPU speed"
	[USAGE_EX]="__${UTIL_CPU} ghz"
)

#
# @brief  Get CPU speed
# @param  Value required show in GHz | MHz CPU speed
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# local PSPEED="ghz" STATUS
# __cpu $PSPEED
# STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#	# true
#	# notify admin | user
# else
#	# false
#	# missing argument | wrong argument
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __cpu() {
	local PSPEED=$1
	if [ -n "${PSPEED}" ]; then
		local FUNC=${FUNCNAME[0]} MSG="None" CPUS
		MSG="Checking CPU speed [${PSPEED}]!"
		__info_debug_message "$MSG" "$FUNC" "$UTIL_CPU"
		if [ "${PSPEED}" == "ghz" ]; then
			CPUS=($({ \
				echo scale=2; \
				awk '/cpu MHz/ {print $4 " / 1000"}' /proc/cpuinfo; \
			} | bc))
		elif [ "${PSPEED}" == "mhz" ]; then
			CPUS=($( \
				awk '/cpu MHz/ {print $4}' /proc/cpuinfo \
			))
		else
			MSG="Wrong argument!"
			__info_debug_message "$MSG" "$FUNC" "$UTIL_CPU"
			MSG="Force exit!"
			__info_debug_message_end "$MSG" "$FUNC" "$UTIL_CPU"
			return $NOT_SUCCESS
		fi
		__info_debug_message "${CPUS}" "$FUNC" "$UTIL_CPU"
		__info_debug_message_end "Done" "$FUNC" "$UTIL_CPU"
		return $SUCCESS
	fi
	__usage CPU_USAGE
	return $NOT_SUCCESS
}

