#!/bin/bash
#
# @brief   Create a heap dump of a Java process
# @version ver.1.0.0
# @date    Mon Jul 15 21:44:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_JAVA_HEAP_DUMP=java_heap_dump
UTIL_JAVA_HEAP_DUMP_VERSION=ver.1.0
UTIL=/root/scripts/sh_util/${UTIL_JAVA_HEAP_DUMP_VERSION}
UTIL_JAVA_HEAP_DUMP_CFG=${UTIL}/conf/${UTIL_JAVA_HEAP_DUMP}.cfg
UTIL_LOG=${UTIL}/log

.    ${UTIL}/bin/devel.sh
.    ${UTIL}/bin/usage.sh
.    ${UTIL}/bin/check_tool.sh
.    ${UTIL}/bin/load_util_conf.sh

declare -A JAVA_HEAP_DUMP_USAGE=(
    [USAGE_TOOL]="${UTIL_JAVA_HEAP_DUMP}"
    [USAGE_ARG1]="[PIDJVM] PID of JVM"
    [USAGE_EX_PRE]="# Create a heap dump of a Java process"
    [USAGE_EX]="${UTIL_JAVA_HEAP_DUMP} 2334"
)

#
# @brief  Create a heap dump of a Java process
# @param  Value required pid of java app
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# java_heap_dump "$PIDJVM"
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
function java_heap_dump {
    local PIDJVM=$1
    if [ -n "${PIDJVM}" ]; then
        local FUNC=${FUNCNAME[0]} MSG="None" STATUS
        declare -A config_java_heap_dump=()
        load_util_conf "$UTIL_JAVA_HEAP_DUMP_CFG" config_java_heap_dump
        STATUS=$?
        if [ $STATUS -eq $SUCCESS ]; then
            local JMAP=${config_java_heap_dump[JMAP]}
            check_tool "${JMAP}"
            STATUS=$?
            if [ $STATUS -eq $SUCCESS ]; then
                MSG="Create a heap dump of a java process [${PIDJVM}]!"
                info_debug_message "$MSG" "$FUNC" "$UTIL_JAVA_HEAP_DUMP"
                local I=0 DUMP_CMD="-dump:file=/tmp/java-"
                while [ ${I} -lt 10 ]
                do
                    eval "${JMAP} ${DUMP_CMD}`date +%s`.hprof ${PIDJVM}"
                    sleep 30
                    I=$[${I}+1]
                done
                info_debug_message_end "Done" "$FUNC" "$UTIL_JAVA_HEAP_DUMP"
                return $SUCCESS
            fi
        MSG="Force exit!"
        info_debug_message_end "$MSG" "$FUNC" "$UTIL_JAVA_HEAP_DUMP"
        return $NOT_SUCCESS
    fi
    usage JAVA_HEAP_DUMP_USAGE
    return $NOT_SUCCESS
}

