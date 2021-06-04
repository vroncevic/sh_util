#!/bin/bash
#
# @brief   Generating progress bar in parent module
# @version ver.1.0
# @date    Mon Nov 28 18:44:21 CET 2016
# @company None, free  software to use 2016
# @author  Vladimir Roncevic <elektron.ronca@gmail.com>
# 
UTIL_PROGRESS_BAR=progress_bar
UTIL_PROGRESS_BAR_VERSION=ver.1.0
UTIL=/root/scripts/sh_util/${UTIL_PROGRESS_BAR_VERSION}
UTIL_LOG=${UTIL}/log

.    ${UTIL}/bin/devel.sh
.    ${UTIL}/bin/usage.sh

declare -A PROGRESS_BAR_Usage=(
    [USAGE_TOOL]="${UTIL_PROGRESS_BAR}"
    [USAGE_ARG1]="[BW] Width of bar"
    [Usage_ARG2]="[MP] Maximal percent"
    [USAGE_EX_PRE]="# Example drawing progress_bar"
    [USAGE_EX]="${UTIL_PROGRESS_BAR} \$PB_STRUCT"
)

#
# @brief  Render progress bar line
# @param  Values required width bar and max percent
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# local BW=$1 BAR_COUNT=$2 STATUS
#
# draw_bar $BW $BAR_COUNT
# STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#    # true
#    # notify admin | user
# else
#    # false
#    # missing argument(s)
#    # return $NOT_SUCCESS
#    # or
#    # exit 128
# fi
#
function draw_bar {
    local BWIDTH=$1 BCOUNT=$2
    if [[ -n "${BWIDTH}" && -n "${BCOUNT}" ]]; then
        local BAR_CH_START="[" BAR_CH_END="]" BAR_CH_EMPTY="."
        local BAR_CH_FULL="=" BRACKET_CHARS=2 LIMIT=100 J
        let "FLIMIT=(((${BWIDTH}-${BRACKET_CHARS})*${BCOUNT})/${LIMIT})"
        let "ELIMIT=(${BWIDTH}-${BRACKET_CHARS})-${FLIMIT}"
        local BAR_LINE="${BAR_CH_START}"
        for ((J=0; J < FLIMIT; J++))
        do
            BAR_LINE="${BAR_LINE}${BAR_CH_FULL}"
        done
        for ((J=0; J<ELIMIT; J++))
        do
            BAR_LINE="${BAR_LINE}${BAR_CH_EMPTY}"
        done
        BAR_LINE="${BAR_LINE}${BAR_CH_END}"
        printf "%3d%% %s" ${BCOUNT} ${BAR_LINE}
        return $SUCCESS
    fi
    return $NOT_SUCCESS
}

#
# @brief  Draw progress bar
# @param  Value required progress bar structure (hash)
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# declare -A PB_STRUCTURE=(
#    [BW]=50
#    [MP]=100
#    [SLEEP]=0.1
# )
#
# progress_bar PB_STRUCTURE
#
# if [ $STATUS -eq $SUCCESS ]; then
#    # true
#    # notify admin | user
# else
#    # false
#    # missing argument(s)
#    # return $NOT_SUCCESS
#    # or
#    # exit 128
# fi
#
function progress_bar {
    local -n PB_STRUCT=$1
    local BW=${PB_STRUCT[BW]} MP=${PB_STRUCT[MP]} ST=${PB_STRUCT[SLEEP]} I
    if [[ -n "${BW}" && -n "${MP}" && "${ST}" ]]; then
        for ((I=0; I <= MP; I++))
        do
            sleep ${ST}
            draw_bar ${BW} ${I}
            echo -en "\r"
        done
        printf "%s\n\n" ""
        return $SUCCESS
    fi
    usage PROGRESS_BAR_Usage
    return $NOT_SUCCESS
}

