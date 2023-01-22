#!/bin/sh

# The URL of the script project is:
# https://github.com/XTLS/Xray-install

FILES_PATH=${FILES_PATH:-./}

# Gobal verbals

# Xray current version
CURRENT_VERSION=''

# Xray latest release version
RELEASE_LATEST=''

get_current_version() {
    # Get the CURRENT_VERSION
    if [[ -f "${FILES_PATH}/web" ]]; then
        CURRENT_VERSION="$(${FILES_PATH}/web -version | awk 'NR==1 {print $2}')"
        CURRENT_VERSION="v${CURRENT_VERSION#v}"
    else
        CURRENT_VERSION=""
    fi
}

get_latest_version() {
    # Get latest release version number
    RELEASE_LATEST="$(curl -IkLs -o ${TMP_DIRECTORY}/NUL -w %{url_effective} https://github.com/XTLS/Xray-core/releases/latest | grep -o "[^/]*$")"
    RELEASE_LATEST="v${RELEASE_LATEST#v}"
    if [[ -z "$RELEASE_LATEST" ]]; then
        echo "error: Failed to get the latest release version, please check your network."
        exit 1
    fi
}

download_xray() {
    DOWNLOAD_LINK="https://github.com/XTLS/Xray-core/releases/download/$RELEASE_LATEST/Xray-linux-64.zip"
    if ! wget -qO "$ZIP_FILE" "$DOWNLOAD_LINK"; then
        echo 'error: Download failed! Please check your network or try again.'
        return 1
    fi
    return 0
    if ! wget -qO "$ZIP_FILE.dgst" "$DOWNLOAD_LINK.dgst"; then
        echo 'error: Download failed! Please check your network or try again.'
        return 1
    fi
    if [[ "$(cat "$ZIP_FILE".dgst)" == 'Not Found' ]]; then
        echo 'error: This version does not support verification. Please replace with another version.'
        return 1
    fi

    # Verification of Xray archive
    for LISTSUM in 'md5' 'sha1' 'sha256' 'sha512'; do
        SUM="$(${LISTSUM}sum "$ZIP_FILE" | sed 's/ .*//')"
        CHECKSUM="$(grep ${LISTSUM^^} "$ZIP_FILE".dgst | grep "$SUM" -o -a | uniq)"
        if [[ "$SUM" != "$CHECKSUM" ]]; then
            echo 'error: Check failed! Please check your network or try again.'
            return 1
        fi
    done
}

decompression() {
    busybox unzip -q "$1" -d "$TMP_DIRECTORY"
    EXIT_CODE=$?
    if [ ${EXIT_CODE} -ne 0 ]; then
        "rm" -r "$TMP_DIRECTORY"
        echo "removed: $TMP_DIRECTORY"
        exit 1
    fi
}

install_xray() {
    install -m 755 ${TMP_DIRECTORY}/xray ${FILES_PATH}/web
}

run_xray() {
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
    cp -f ./config.yaml /tmp/config.yaml
    sed -i "s|PASSWORD|${USER_PASSWORD}|g;s|WSPATH|${USER_PATH}|g" /tmp/config.yaml
    ./web -c /tmp/config.yaml 2>&1 >/dev/null &
    PATH_IN_LINK=$(echo ${USER_PATH} | sed "s|\/|\%2F|g")
    echo ""
    echo "Share Link:"
    echo trojan://"${USER_PASSWORD}@${REPL_SLUG}.${REPL_OWNER}.repl.co:443?security=tls&type=ws&path=${PATH_IN_LINK}#Replit"
    echo "Trojan Password: ${USER_PASSWORD}, Websocket Path: ${USER_PATH}, Domain: ${REPL_SLUG}.${REPL_OWNER}.repl.co, Port: 443"
    echo trojan://"${USER_PASSWORD}@${REPL_SLUG}.${REPL_OWNER}.repl.co:443?security=tls&type=ws&path=${PATH_IN_LINK}#Replit" >/tmp/link
    echo ""
    qrencode -t ansiutf8 </tmp/link
    while :; do
        curl https://${REPL_SLUG}.${REPL_OWNER}.repl.co
        sleep 600
    done
}

# Two very important variables
TMP_DIRECTORY="$(mktemp -d)"
ZIP_FILE="${TMP_DIRECTORY}/web.zip"

get_current_version
get_latest_version
if [ "${RELEASE_LATEST}" = "${CURRENT_VERSION}" ]; then
    "rm" -rf "$TMP_DIRECTORY"
    run_xray
fi
download_xray
EXIT_CODE=$?
if [ ${EXIT_CODE} -eq 0 ]; then
    :
else
    "rm" -r "$TMP_DIRECTORY"
    echo "removed: $TMP_DIRECTORY"
    run_xray
fi
decompression "$ZIP_FILE"
install_xray
"rm" -rf "$TMP_DIRECTORY"

run_xray
