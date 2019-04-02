#!/bin/bash

clear

read -e -p $'\e[32mInstall docker? ("NO" by default):\e[0m ' INSTALL_DOCKER

if [ ! -z "$INSTALL_DOCKER" ]
then
    sudo apt update
    echo -e "Installing \033[0;32docker.io\033[0m and \033[0;32mdocker-compose\033[0m"

    : '
    Or use "sudo snap install docker" if Snappy installed

    For removing previouse version:
    sudo apt purge \
        docker.io \
        docker-compose
    OR
    sudo snap remove docker 
    '

    sudo apt install \
        docker.io \
        docker-compose

    sudo groupadd docker
    sudo usermod -aG docker $USER
    sudo chown "$USER":"$USER" /home/"$USER"/.docker -R
    sudo chmod g+rwx "$HOME/.docker" -R
fi

sudo cp icons8-docker.svg /usr/share/icons/hicolor/scalable/apps/
echo -e "Copy \033[0;32micons8-docker.svg\033[0m to \033[0;32m/usr/share/icons/hicolor/scalable/apps\033[0m"

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

function build_application_shortcut {
    while IFS=  read -r -d $'\0'; do
        RUN_SCRIPT_PATH=$(realpath $REPLY)
        SCRIPT_DIR=${RUN_SCRIPT_PATH%/*}
        select_shortcut_name $RUN_SCRIPT_PATH
        
        ACTIONS_SCRIPTS=()
        ACTIONS_NAMES=()
        
        while IFS=  read -r -d $'\0'; do
            ACTIONS_SCRIPTS+=("$REPLY")
            ACTIONS_NAMES+=($(echo "$REPLY" | sed -r "s/.+\/(.+)\..+/\1/"))
        done < <(find $SCRIPT_DIR -maxdepth 1 -name "*.sh" -print0)
        
        ACTIONS=$(join_by \; "${ACTIONS_NAMES[@]};")
        SHORTCUT="$(echo -e "$(sed 's|@1|'$SHORTCUT_NAME'|g; s|@2|'$RUN_SCRIPT_PATH'|g; s|@3|'$ACTIONS'|g;' <<< $SHORTCUT_ACTION_TEMPLATE)")\n"
        for ((i=0;i<${#ACTIONS_NAMES[@]};++i)); do
            SHORTCUT="${SHORTCUT}\n$(echo "$(sed 's|@1|'${ACTIONS_NAMES[i]}'|g; s|@2|'${ACTIONS_SCRIPTS[i]}'|g;' <<< $ACTION_TEMPLATE)")\n"
        done
        echo -e "$SHORTCUT" > "${APP_FOLDER}/${SHORTCUT_NAME}.desktop"
        chmod +x ${APP_FOLDER}/${SHORTCUT_NAME}.desktop
        echo -e "Created \033[0;32m${SHORTCUT_NAME}.desktop\033[0m shortcut in \033[0;32m${APP_FOLDER}\033[0m"
    done < <(find $INSTALL_SCRIPT_DIR -regextype posix-egrep -regex ".*(${AVALIABLE_RUNNERS_REGEX})$" -print0)
}

function build_desktop_shortcut {
    while IFS=  read -r -d $'\0'; do
        RUN_SCRIPT_PATH=$(realpath $REPLY)
        select_shortcut_name $RUN_SCRIPT_PATH
        echo "$(sed 's|@1|'$SHORTCUT_NAME'|g; s|@2|'$RUN_SCRIPT_PATH'|g' <<< $SHORTCUT_TEMPLATE)" > "${DESK_FOLDER}/${SHORTCUT_NAME}.desktop"
        chmod +x ${DESK_FOLDER}/${SHORTCUT_NAME}.desktop
        echo -e "Created \033[0;32m${SHORTCUT_NAME}.desktop\033[0m shortcut in \033[0;32m${DESK_FOLDER}\033[0m"
    done < <(find $INSTALL_SCRIPT_DIR -regextype posix-egrep -regex ".*(${AVALIABLE_RUNNERS_REGEX})$" -print0)
}

echo -e "\033[0;32mSelect environmetn mode\033[0m"

ENV_MODES=("Application mode" "Desktop shortcuts mode")
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
            read -e -p $'\e[32mGenerate kill shortcuts? ("YES" by default):\e[0m ' GENERATE_KILL_SHORTCUTS
            if [ -z "$GENERATE_KILL_SHORTCUTS" ]
            then
                declare -a RUNNERS_NAMES=("run.sh" "kill.sh")
            else
                declare -a RUNNERS_NAMES=("run.sh")
            fi
            break
            ;;
        *) echo -e "\033[0;31mInvalid option $REPLY\033[0m";;
    esac
done

AVALIABLE_RUNNERS_REGEX=$(join_by \| "${RUNNERS_NAMES[@]}")

SHORTCUT_ACTION_TEMPLATE=$(cat <<-END
[Desktop Entry]
Version=1.0
Type=Application
Terminal=true
Name[en_US]=@1
Exec=@2
Name=@1
Icon=/usr/share/icons/hicolor/scalable/apps/icons8-docker.svg

Actions=@3

END
)

SHORTCUT_TEMPLATE=$(cat <<-END
[Desktop Entry]
Version=1.0
Type=Application
Terminal=true
Name[en_US]=@1
Exec=@2
Name=@1
Icon=/usr/share/icons/hicolor/scalable/apps/icons8-docker.svg
END
)

ACTION_TEMPLATE=$(cat <<-END
[Desktop Action @1]
Exec=@2
Name=@1
Terminal=true

END
)

INSTALL_SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )/"

if [ "$ENV_MODE" = "Application mode" ]
then
    build_application_shortcut
elif [ "$ENV_MODE" = "Desktop shortcuts mode" ] 
then
    build_desktop_shortcut
fi
