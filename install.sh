#!/bin/bash

clear
echo -e "Copy \033[0;32micons8-docker.svg\033[0m to \033[0;32m/usr/share/icons/hicolor/scalable/apps\033[0m"
cp icons8-docker.svg /usr/share/icons/hicolor/scalable/apps/

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
    if [ $(basename ${RUN_SCRIPT_PATH}) == "run.sh" ] 
    then
        SHORTCUT_NAME=$(sed 's|'$INSTALL_SCRIPT_DIR'||g; s|/run.sh||g; s|/|-|g;' <<< $RUN_SCRIPT_PATH)
    else
        SHORTCUT_NAME=$(sed 's|'$INSTALL_SCRIPT_DIR'||g; s|/kill.sh|-kill|g; s|/|-|g;' <<< $RUN_SCRIPT_PATH)
    fi
    echo -e "Created \033[0;32m${SHORTCUT_NAME}.desktop\033[0m shortcut in \033[0;32m${HOME}/Desktop\033[0m"
    echo "$(sed 's|@1|'$SHORTCUT_NAME'|g; s|@2|'$RUN_SCRIPT_PATH'|g' <<< $SHORTCUT_TEMPLATE)" > "${HOME}/Desktop/${SHORTCUT_NAME}.desktop"
    chmod +x ${HOME}/Desktop/${SHORTCUT_NAME}.desktop
done < <(find . -regextype posix-egrep -regex ".*(run.sh|kill.sh)$" -print0)