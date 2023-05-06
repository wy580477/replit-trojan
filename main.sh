#!/bin/sh

FILES_PATH=${FILES_PATH:-./}

download_web() {
    DOWNLOAD_LINK="https://github.com/SagerNet/sing-box/releases/download/v1.3-beta11/sing-box-1.3-beta11-linux-amd64.tar.gz"
    if ! wget -qO "$ZIP_FILE" "$DOWNLOAD_LINK"; then
        echo 'error: Download failed! Please check your network or try again.'
        return 1
    fi
    return 0
}

decompression() {
    tar -zxf "$1" -C "$TMP_DIRECTORY"
    EXIT_CODE=$?
    if [ ${EXIT_CODE} -ne 0 ]; then
        "rm" -r "$TMP_DIRECTORY"
        echo "removed: $TMP_DIRECTORY"
        exit 1
    fi
}

install_web() {
    install -m 755 ${TMP_DIRECTORY}/sing-box*/sing-box ${FILES_PATH}/web
}

run_web() {
    TR_PASSWORD=$(curl -s $REPLIT_DB_URL/tr_password)
    TR_PATH=$(curl -s $REPLIT_DB_URL/tr_path)
    if [ "${TR_PASSWORD}" = "" ]; then
        NEW_PASS="$(echo $RANDOM | md5sum | head -c 8)"
        curl -sXPOST $REPLIT_DB_URL/tr_password="${NEW_PASS}"
    fi
    if [ "${TR_PATH}" = "" ]; then
        NEW_PATH=$(echo $RANDOM | md5sum | head -c 6)
        curl -sXPOST $REPLIT_DB_URL/tr_path="${NEW_PATH}"
    fi
    if [ "${PASSWORD}" = "" ]; then
        USER_PASSWORD=$(curl -s $REPLIT_DB_URL/tr_password)
    else
        USER_PASSWORD=${PASSWORD}
    fi
    if [ "${WSPATH}" = "" ]; then
        USER_PATH=/$(curl -s $REPLIT_DB_URL/tr_path)
    else
        USER_PATH=${WSPATH}
    fi
    cp -f ./config.json /tmp/config.json
    sed -i "s|PASSWORD|${USER_PASSWORD}|g;s|WSPATH|${USER_PATH}|g" /tmp/config.json
    PATH_IN_LINK=$(echo ${USER_PATH} | sed "s|\/|\%2F|g")
    echo ""
    echo "Share Link:"
    echo trojan://"${USER_PASSWORD}@${REPL_SLUG}.${REPL_OWNER}.repl.co:443?security=tls&type=ws&path=${PATH_IN_LINK}#Replit"
    echo "Trojan Password: ${USER_PASSWORD}, Websocket Path: ${USER_PATH}, Domain: ${REPL_SLUG}.${REPL_OWNER}.repl.co, Port: 443"
    echo trojan://"${USER_PASSWORD}@${REPL_SLUG}.${REPL_OWNER}.repl.co:443?security=tls&type=ws&path=${PATH_IN_LINK}#Replit" >/tmp/link
    echo ""
    qrencode -t ansiutf8 </tmp/link
    ./web run -c /tmp/config.json 2>&1 >/dev/null &
    while :; do
        curl https://${REPL_SLUG}.${REPL_OWNER}.repl.co
        sleep 600
    done
}

# Two very important variables
TMP_DIRECTORY="$(mktemp -d)"
ZIP_FILE="${TMP_DIRECTORY}/web.tar.gz"

if [ ! -f ./web ]; then
    download_web
    decompression "$ZIP_FILE"
    install_web
fi
run_web
