#!/bin/bash
#
# @brief   Generate Client VNC config file at
#          /home/<username>/.vnc/
# @version ver.1.0
# @date    Sun Jun 14 16:08:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_NAME=vncclientconfig
UTIL_VERSION=ver.1.0
UTIL=/root/scripts/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/usage.sh
. $UTIL/bin/logging.sh
. $UTIL/bin/devel.sh

declare -A TOOL_USAGE=(
    [TOOL_NAME]="__$UTIL_NAME"
    [ARG1]="[VNC_STRUCTURE]   System username and group"
    [EX-PRE]="# Example generating VNC config file"
    [EX]="__$UTIL_NAME rmuller ds"	
)

declare -A LOG=(
    [TOOL]="$UTIL_NAME"
    [FLAG]="error"
    [PATH]="$UTIL_LOG"
    [MSG]=""
)

#
# @brief  Generating VNC client config file at home dir
# @param  Value required structure (username and department)
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# VNC_STRUCTURE[UN]="rmuller"
# VNC_STRUCTURE[DN]="ds"
#
# __vncclientconfig $VNC_STRUCTURE 
# STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
# else
#   # false
# fi
#
function __vncclientconfig() {
	VNC_STRUCTURE=$1
    USERNAME=${VNC_STRUCTURE[UN]}
    DEPARTMENT=${VNC_STRUCTURE[DN]}
    if [ -n "$USERNAME" ] && [ -n "$DEPARTMENT" ]; then 
		if [ "$TOOL_DEBUG" == "true" ]; then
			printf "%s\n" "[Generating VNC client config file at home dir]"
            printf "%s" "Checking directory [/home/$USERNAME/]"
		fi
        if [ -d "/home/$USERNAME/" ]; then
			if [ "$TOOL_DEBUG" == "true" ]; then
            	printf "%s" "Checking VNC configuration dir "
			fi
            if [ ! -d "/home/$USERNAME/.vnc/" ]; then
				if [ "$TOOL_DEBUG" == "true" ]; then                
					printf "%s\n" "[not exist]"
                	printf "%s\n" "Create VNC config directory"
				fi
                mkdir "/home/$USERNAME/.vnc/"
            else
				if [ "$TOOL_DEBUG" == "true" ]; then
					printf "%s\n" "[ok]"
				fi
				:
            fi
			if [ "$TOOL_DEBUG" == "true" ]; then
            	printf "%s\n" "Generating VNC config file [/home/$USERNAME/.vnc/]"
			fi
            cat <<EOF>>"/home/$USERNAME/.vnc/xstartup"

#!/bin/sh
#
# NS Frobas IT
# VNC session to NSFROBAS network
#
[ -r /etc/sysconfig/i18n ] && . /etc/sysconfig/i18n
export LANG
export SYSFONT
vncconfig -iconic &
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
OS=\`uname -s\`
if [ \$OS = 'Linux' ]; then
  case "\$WINDOWMANAGER" in
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
xterm -geometry 80x24+10+10 -ls -title "\$VNCDESKTOP Desktop" &
twm &
EOF
			if [ "$TOOL_DEBUG" == "true" ]; then
            	printf "%s\n" "Set owner"
			fi
            chown -R "$USERNAME.$DEPARTMENT" "/home/$USERNAME/.vnc/"
			if [ "$TOOL_DEBUG" == "true" ]; then            
				printf "%s\n" "Set permission"
			fi
            chmod -R 755 "/home/$USERNAME/.vnc/"
			if [ "$TOOL_DEBUG" == "true" ]; then            
				printf "%s\n\n" "[Done]"
			fi
            return $SUCCESS
        else
            LOG[MSG]="Missing /home/$USERNAME/ directory"
			if [ "$TOOL_DEBUG" == "true" ]; then
				printf "%s\n" "[not ok]"
				printf "%s\n\n" "[Error] ${LOG[MSG]}"
			fi
            __logging $LOG
            return $NOT_SUCCESS
        fi
    fi 
    __usage $TOOL_USAGE
    return $NOT_SUCCESS
}

