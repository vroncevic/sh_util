#!/bin/bash
#
# @brief   Generate Client VNC config file at
#          /home/<username>/.vnc/
# @version ver.1.0
# @date    Sun Jun 14 16:08:32 2015
# @company Frobas IT Department, www.frobas.com 2015
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
TOOL_NAME=vncclientconfig
TOOL_VERSION=ver.1.0
TOOL_EXECUTABLE="${BASH_SOURCE[0]}"
TOOL_BIN=`dirname $TOOL_EXECUTABLE`
TOOL_HOME=`dirname $TOOL_BIN`
TOOL_LOG=$TOOL_HOME/log

. $TOOL_BIN/usage.sh
. $TOOL_BIN/logging.sh

SUCCESS=0
NOT_SUCCESS=1

declare -A TOOL_USAGE=(
    [TOOL_NAME]="__$TOOL_NAME"
    [ARG1]="[USERNAME]   System username"
    [ARG2]="[DEPARTMENT] System group"
    [EX-PRE]="# Example generating VNC config file"
    [EX]="__$TOOL_NAME rmuller users"	
)

declare -A LOG=(
    [TOOL]="$TOOL_NAME"
    [FLAG]="error"
    [PATH]="$TOOL_LOG"
    [MSG]=""
)

#
# @brief Generating VNC client config file at home dir
# @params Values required username and department
# @retval Success return 0, else return 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __vncclientconfig rmuller users 
# STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#	# true
# else
#	# false
# fi
#
function __vncclientconfig() {
    USERNAME=$1
    DEPARTMENT=$2
    if [ -n "$USERNAME" ] && [ -n "$DEPARTMENT" ]; then 
        printf "%s" "Checking VNC configuration dir "
        if [ ! -d "/home/$USERNAME/.vnc/" ]; then
            printf "%s\n" "[not exist]"
            printf "%s\n" "Create VNC config directory..."
            mkdir "/home/$USERNAME/.vnc/"
        else
            printf "%s\n" "[ok]"
        fi
        printf "%s\n" "Generating VNC config file [/home/$USERNAME/.vnc/]"
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
        printf "%s\n" "Set owner..."
        chown -R "$USERNAME.$DEPARTMENT" "/home/$USERNAME/.vnc/"
        printf "%s\n" "Set permissions..."
        chmod -R 755 "/home/$USERNAME/.vnc/"
        printf "%s\n" "Done..."
        return $SUCCESS
    fi 
    __usage $TOOL_USAGE
    LOG[MSG]="Missing argument"
    __logging $LOG
    return $NOT_SUCCESS
}
