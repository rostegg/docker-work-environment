#!/bin/bash

clear


echo -e "Removed \033[0;31m/usr/share/icons/hicolor/scalable/apps/micons8-docker.svg\033[0m icon"
sudo rm /usr/share/icons/hicolor/scalable/apps/icons8-docker.svg

function join_by { 
    local IFS="$1"; shift; echo "$*"; 
}

function select_shortcut_name {
    case $(basename $1) in
     "run.sh")      
          SHORTCUT_NAME=$(sed 's|'$INSTALL_SCRIPT_DIR'||g; s|/run.sh||g; s|/|-|g;' <<< $RUN_SCRIPT_PATH)
          ;;
     "kill.sh")      
          SHORTCUT_NAME=$(sed 's|'$INSTALL_SCRIPT_DIR'||g; s|/kill.sh|-kill|g; s|/|-|g;' <<< $RUN_SCRIPT_PATH)
          ;;
    esac
}

declare -a RUNNERS_NAMES=("run.sh" "kill.sh")
AVALIABLE_RUNNERS_REGEX=$(join_by \| "${RUNNERS_NAMES[@]}")

INSTALL_SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )/"

while IFS=  read -r -d $'\0'; do
    RUN_SCRIPT_PATH=$(realpath $REPLY)
    select_shortcut_name $RUN_SCRIPT_PATH
    rm ${HOME}/Desktop/${SHORTCUT_NAME}.desktop
    echo -e "Removed \033[0;31m${HOME}/Desktop/${SHORTCUT_NAME}.desktop\033[0m shortcut"
done < <(find . -regextype posix-egrep -regex ".*(${AVALIABLE_RUNNERS_REGEX})$" -print0)
