#!/bin/bash
#
# @brief   Generate Client VNC config file at
#          /home/<username>/.vnc/
# @version ver.1.0
# @date    Sun Jun 14 16:08:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_VNCCLIENTCONFIG=vncclientconfig
UTIL_VNCCLIENTCONFIG_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VNCCLIENTCONFIG_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/devel.sh

declare -A VNCCLIENTCONFIG_USAGE=(
    ["TOOL"]="__$UTIL_VNCCLIENTCONFIG"
    ["ARG1"]="[VNC_STRUCTURE]   System username and group"
    ["EX-PRE"]="# Example generating VNC config file"
    ["EX"]="__$UTIL_VNCCLIENTCONFIG rmuller ds"	
)

#
# @brief  Generating VNC client config file at home dir
# @param  Value required structure (username and department)
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# declare -A VNC_STRUCTURE=()
# VNC_STRUCTURE["UN"]="vroncevic"
# VNC_STRUCTURE["DN"]="vroncevic"
#
# __vncclientconfig "$(declare -p VNC_STRUCTURE)" 
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#   # true
#   # notify admin | user
# else
#   # false
#   # missing argument(s) | missing user home dir
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# fi
#
function __vncclientconfig() {
	eval "declare -A VNC_STRUCTURE="${1#*=}
    local USERNAME=${VNC_STRUCTURE["UN"]}
    local DEPARTMENT=${VNC_STRUCTURE["DN"]}
    if [ -n "$USERNAME" ] && [ -n "$DEPARTMENT" ]; then
		local FUNC=${FUNCNAME[0]}
		local MSG=""
		local UHOME="/home/$USERNAME"
		if [ "$TOOL_DBG" == "true" ]; then
            MSG="Checking dir [$UHOME/]"
			printf "$DQUE" "$UTIL_VNCCLIENTCONFIG" "$FUNC" "$MSG"
		fi
        if [ -d "$UHOME/" ]; then
			local VHOME="$UHOME/.vnc"
			if [ "$TOOL_DBG" == "true" ]; then
				printf "%s\n" "[ok]"
            	MSG="Checking vnc config dir [$VHOME/]"
				printf "$DQUE" "$UTIL_VNCCLIENTCONFIG" "$FUNC" "$MSG"
			fi
            if [ ! -d "$VHOME/" ]; then
				if [ "$TOOL_DBG" == "true" ]; then                
					printf "%s\n" "[not ok]"
                	MSG="Create VNC config dir [$VHOME/]"
					printf "$DSTA" "$UTIL_VNCCLIENTCONFIG" "$FUNC" "$MSG"
				fi
                mkdir "$VHOME/"
            else
				if [ "$TOOL_DBG" == "true" ]; then
					printf "%s\n" "[ok]"
				fi
				:
            fi
			if [ "$TOOL_DBG" == "true" ]; then
            	MSG="Generating VNC config file [$VHOME/xstartup]"
				printf "$DSTA" "$UTIL_VNCCLIENTCONFIG" "$FUNC" "$MSG"
			fi
			local XSTARTUP_SCRIPT="
#!/bin/sh
#
# $UTIL_FROM_COMPANY IT
#
[ -r /etc/sysconfig/i18n ] && . /etc/sysconfig/i18n
export LANG
export SYSFONT
vncconfig -iconic &
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
OS=\`uname -s\`
if [ \$OS = 'Linux' ]; then
  case \"\$WINDOWMANAGER\" in
    *gnome*)
      if [ -e /etc/SuSE-release ]; then
        PATH=\$PATH:/opt/gnome/bin
        export PATH
      fi
      ;;
  esac
fi
if [ -x /etc/X11/xinit/xinitrc ]; then
  exec /etc/X11/xinit/xinitrc
fi
if [ -f /etc/X11/xinit/xinitrc ]; then
  exec sh /etc/X11/xinit/xinitrc
fi
[ -r \$HOME/.Xresources ] && xrdb \$HOME/.Xresources
xsetroot -solid grey
xterm -geometry 80x24+10+10 -ls -title \"\$VNCDESKTOP Desktop\" &
twm &
"
			echo "$XSTARTUP_SCRIPT" > "$VHOME/xstartup"
			if [ "$TOOL_DBG" == "true" ]; then
            	printf "$DSTA" "$UTIL_VNCCLIENTCONFIG" "$FUNC" "Set owner"
			fi
            chown -R "$USERNAME.$DEPARTMENT" "$VHOME/"
			if [ "$TOOL_DBG" == "true" ]; then            
				printf "$DSTA" "$UTIL_VNCCLIENTCONFIG" "$FUNC" "Set permission"
			fi
            chmod -R 755 "$VHOME/"
			if [ "$TOOL_DBG" == "true" ]; then            
				printf "$DEND" "$UTIL_VNCCLIENTCONFIG" "$FUNC" "Done"
			fi
            return $SUCCESS
        fi
		if [ "$TOOL_DBG" == "true" ]; then
			printf "%s\n" "[not ok]"
		fi
		MSG="Please check dir [$UHOME/]"
		return $NOT_SUCCESS
    fi 
    __usage "$(declare -p VNCCLIENTCONFIG_USAGE)"
    return $NOT_SUCCESS
}

