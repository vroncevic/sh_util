#!/bin/bash
#
# @brief   Debug/Info/Question options, print function formats
# @version ver.1.0
# @date    Fri Dec  5 07:56:24 PM CET 2025
# @company None, free software to use 2025
# @author  Vladimir Roncevic <elektron.ronca@gmail.com>
#
if [ -z "$__SH_UTIL_DEVEL_CONST" ]; then
    readonly __SH_UTIL_DEVEL_CONST=1

    # Set company name
    readonly UTIL_FROM_COMPANY="None"

    # Debug print formats
    readonly DSTA="[@Module %s.sh @Func %s] %s\n"
    readonly DEND="[@Module %s.sh @Func %s] %s\n\n"
    readonly DQUE="[@Module %s.sh @Func %s] %s "
    readonly DANS="[@Module %s.sh @Func %s] %s\n"

    # Info print formats
    readonly SSTA="[%s] %s\n"
    readonly SEND="[%s] %s\n\n"
    readonly SQUE="[%s] %s "
    readonly SANS="%s\n"

    # Return, check states
    readonly SUCCESS=0
    readonly NOT_SUCCESS=1

    # Boolean values
    readonly TRUE="true"
    readonly FALSE="false"
fi
