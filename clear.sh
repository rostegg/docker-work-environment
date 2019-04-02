#!/bin/bash

clear

echo -e "Removed \033[0;31m/usr/share/icons/hicolor/scalable/apps/micons8-docker.svg\033[0m icon"
sudo rm -f /usr/share/icons/hicolor/scalable/apps/icons8-docker.svg

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


function remove_application_shortcuts {
    while IFS=  read -r -d $'\0'; do
        RUN_SCRIPT_PATH=$(realpath $REPLY)
        select_shortcut_name $RUN_SCRIPT_PATH
        rm -f ${APP_FOLDER}/${SHORTCUT_NAME}.desktop
        echo -e "Removed \033[0;31m${SHORTCUT_NAME}.desktop\033[0m shortcut from \033[0;31m${APP_FOLDER}\033[0m"
    done < <(find $INSTALL_SCRIPT_DIR -regextype posix-egrep -regex ".*(${AVALIABLE_RUNNERS_REGEX})$" -print0)
}

function remove_desktop_shortcuts {
    while IFS=  read -r -d $'\0'; do
        RUN_SCRIPT_PATH=$(realpath $REPLY)
        select_shortcut_name $RUN_SCRIPT_PATH
        rm -f ${DESK_FOLDER}/${SHORTCUT_NAME}.desktop
        echo -e "Removed \033[0;31m${SHORTCUT_NAME}.desktop\033[0m shortcut from \033[0;31m${DESK_FOLDER}\033[0m"
    done < <(find $INSTALL_SCRIPT_DIR -regextype posix-egrep -regex ".*(${AVALIABLE_RUNNERS_REGEX})$" -print0)
}

echo -e "\033[0;32mSelect environment mode for removing\033[0m"

ENV_MODES=("Application mode" "Desktop shortcuts mode" "All")
APP_FOLDER="${HOME}/.local/share/applications"
DESK_FOLDER="${HOME}/Desktop"

select VALUE in "${ENV_MODES[@]}"
do
    case $VALUE in
        "Application mode")
            ENV_MODE=$VALUE
            declare -a RUNNERS_NAMES=("run.sh")
            break
            ;;
        "Desktop shortcuts mode")
            ENV_MODE=$VALUE
            declare -a RUNNERS_NAMES=("run.sh" "kill.sh")
            break
            ;;
        "All")
            ENV_MODE=$VALUE
            declare -a RUNNERS_NAMES=("run.sh" "kill.sh")
            break
            ;;
        *) echo -e "\033[0;31mInvalid option $REPLY\033[0m";;
    esac
done

AVALIABLE_RUNNERS_REGEX=$(join_by \| "${RUNNERS_NAMES[@]}")

INSTALL_SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )/"

if [ "$ENV_MODE" = "Application mode" ]
then
    remove_application_shortcuts
elif [ "$ENV_MODE" = "Desktop shortcuts mode" ] 
then
    remove_desktop_shortcuts
elif [ "$ENV_MODE" = "All" ] 
then
    remove_desktop_shortcuts
    declare -a RUNNERS_NAMES=("run.sh")
    remove_application_shortcuts
fi

