#!/bin/bash
#
# @brief   Display an ASCII logo
# @version ver.1.0
# @date    Mon Dec  1 05:40:10 PM CET 2025
# @company None, free software to use 2025
# @author  Vladimir Roncevic <elektron.ronca@gmail.com>
#
UTIL_DISPLAY_LOGO=display_logo
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh_util/${UTIL_VERSION}
UTIL_LOG=${UTIL}/log

.    ${UTIL}/bin/devel.sh
.    ${UTIL}/bin/usage.sh
.    ${UTIL}/bin/center.sh

declare -A DISPLAY_LOGO_USAGE=(
    [USAGE_TOOL]="${UTIL_DISPLAY_LOGO}"
    [USAGE_ARG1]="[ORG] Organization or username"
    [USAGE_ARG2]="[REPO] Repository name"
    [USAGE_ARG3]="[VERSION] Version string"
    [USAGE_ARG4]="[LOGO] Logo file path"
    [USAGE_EX_PRE]="# Example of display logo in terminal"
    [USAGE_EX]="${UTIL_DISPLAY_LOGO} 'org' 'tool' '1.0' 'tool.logo'"
)

#
# @brief  Displays an ASCII logo from a file, followed by centered, clickable 
#         hyperlinks for information, issues, and author/organization.
# @param  ORG (string): The GitHub organization or username (e.g., 'vroncevic').
# @param  REPO (string): The GitHub repository name (e.g., 'apmodule').
# @param  VERSION (string): The project version string (e.g., '4.0').
# @param  LOGO (string): The path to the file containing the ASCII logo.
# @retval None
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# display_logo 'vroncevic' 'apmodule' '4.0' 'logo_apache_module.logo'
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#    # true
#    # notify admin | user
# else
#    # false
#    # missing organization | repository | version | logo file argument
#    # return $NOT_SUCCESS
#    # or
#    # exit 128
# fi
#
function display_logo {
    local ORG=$1
    local REPO=$2
    local VERSION=$3
    local LOGO=$4
    if [[ -n "${ORG}" && -n "${REPO}" && -n "${VERSION}" && -n "${LOGO}" ]]; then
        local INFO_URL="https://${ORG}.github.io/${REPO}"
        local INFO_TXT="github.io/${REPO}"
        local ISSUE_URL="https://github.com/${ORG}/${REPO}/issues/new/choose"
        local ISSUE_TXT='github.io/issue'
        local AUTHOR_URL="https://${ORG}.github.io/bio/"
        local AUTHOR_TXT="${ORG}.github.io"
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
    fi
    usage DISPLAY_LOGO_USAGE
    return $NOT_SUCCESS
}
