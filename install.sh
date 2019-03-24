#!/bin/bash

clear
echo -e "Copy \033[0;32micons8-docker.svg\033[0m to \033[0;32m/usr/share/icons/hicolor/scalable/apps\033[0m"
cp icons8-docker.svg /usr/share/icons/hicolor/scalable/apps/

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

INSTALL_SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )/"

while IFS=  read -r -d $'\0'; do
    RUN_SCRIPT_PATH=$(realpath $REPLY)
    select_shortcut_name $RUN_SCRIPT_PATH
    echo -e "Created \033[0;32m${SHORTCUT_NAME}.desktop\033[0m shortcut in \033[0;32m${HOME}/Desktop\033[0m"
    echo "$(sed 's|@1|'$SHORTCUT_NAME'|g; s|@2|'$RUN_SCRIPT_PATH'|g' <<< $SHORTCUT_TEMPLATE)" > "${HOME}/Desktop/${SHORTCUT_NAME}.desktop"
    chmod +x ${HOME}/Desktop/${SHORTCUT_NAME}.desktop
done < <(find . -regextype posix-egrep -regex ".*(${AVALIABLE_RUNNERS_REGEX})$" -print0)