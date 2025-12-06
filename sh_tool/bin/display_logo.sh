#!/bin/bash
#
# @brief   Display an ASCII logo
# @version ver.1.0
# @date    Mon Dec  1 05:40:10 PM CET 2025
# @company None, free software to use 2025
# @author  Vladimir Roncevic <elektron.ronca@gmail.com>
#
if [ -z "$__SH_UTIL_DISPLAY_LOGO" ]; then
    readonly __SH_UTIL_DISPLAY_LOGO=1

    UTIL_DISPLAY_LOGO=display_logo
    UTIL_VERSION=ver.1.0
    UTIL=/root/scripts/sh_util/${UTIL_VERSION}
    UTIL_LOG=${UTIL}/log

    .    ${UTIL}/bin/center.sh

    declare -A DISPLAY_LOGO_USAGE=(
        [USAGE_TOOL]="${UTIL_DISPLAY_LOGO}"
        [USAGE_ARG1]="[OWNER] Organization or username"
        [USAGE_ARG2]="[REPO] Repository name"
        [USAGE_ARG3]="[VERSION] Version string"
        [USAGE_ARG4]="[LOGO] Logo file path"
        [USAGE_EX_PRE]="# Example of display logo in terminal"
        [USAGE_EX]="${UTIL_DISPLAY_LOGO} 'org' 'tool' '1.0' 'tool.logo'"
    )

    #
    # @brief  Displays an ASCII logo from a file, followed by centered, clickable 
    #         hyperlinks for information, issues, and author/organization.
    # @param  Value required referenced associative array with:
    #         organization, repository, version and logo file path
    # @retval Success 0, else 1 (in case of missing arguments or logo file not found)
    #
    # @usage
    # @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    #
    # declare -A TOOL_LOGO=(
    #     [OWNER]='vroncevic'
    #     [REPO]='apmodule'
    #     [VERSION]='4.0'
    #     [LOGO]='logo_apache_module.logo'
    # )
    #
    # display_logo TOOL_LOGO
    # local STATUS=$?
    #
    # if [ $STATUS -eq $SUCCESS ]; then
    #    # true
    #    # notify admin | user
    # else
    #    # false
    #    # missing owner | repository | version | logo file argument
    #    # return $NOT_SUCCESS
    #    # or
    #    # exit 128
    # fi
    #
    function display_logo {
        local -n ARGS=$1
        local OWNER=${ARGS[OWNER]}
        local REPO=${ARGS[REPO]}
        local VERSION=${ARGS[VERSION]}
        local LOGO=${ARGS[LOGO]}
        if [[ -z "${OWNER}" || -z "${REPO}" || -z "${VERSION}" || -z "${LOGO}" ]]; then
            usage DISPLAY_LOGO_USAGE
            return $NOT_SUCCESS
        fi
        if [[ ! -f "${LOGO}" ]]; then
            local FUNC=${FUNCNAME[0]}
            local USAGE_MSG="Logo file not found at '%s'\n" "${LOGO}"
            printf "$SEND" "$UTIL_DISPLAY_LOGO" "$FUNC" "$USAGE_MSG" >&2
            return $NOT_SUCCESS
        fi
        local INFO_URL="https://${OWNER}.github.io/${REPO}"
        local INFO_TXT="github.io/${REPO}"
        local ISSUE_URL="https://github.com/${OWNER}/${REPO}/issues/new/choose"
        local ISSUE_TXT='github.io/issue'
        local AUTHOR_URL="https://${OWNER}.github.io/bio/"
        local AUTHOR_TXT="${OWNER}.github.io"
        while IFS= read -r LINE
        do
            center 0
            printf "%s\n" "$LINE"
        done < ${LOGO}
        center 2
        printf "Info   "
        printf "\e]8;;${INFO_URL}\a${INFO_TXT}\e]8;;\a"
        printf " ${VERSION} \n"
        center 2
        printf "Issue  "
        printf "\e]8;;${ISSUE_URL}\a${ISSUE_TXT}\e]8;;\a"
        printf "\n"
        center 2
        printf "Author "
        printf "\e]8;;${AUTHOR_URL}\a${AUTHOR_TXT}\e]8;;\a"
        printf "\n\n"
        return $SUCCESS
    }
fi
