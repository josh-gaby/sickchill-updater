#!/bin/bash

# Path to your pip installation
PIP_PATH="$HOME/pip3/bin/"

# Path to your sickchill pid file
SICKCHILL_PID="$HOME/sickchill/SickChill.pid"

###################################################################################################################

function check_pip() {
    NV_DATA=$(${PIP_PATH}pip list --outdated | grep sickchill)
    if [[ -n "$NV_DATA" ]]; then
        NV_ARR=( $NV_DATA )
        NV_REQUIRED=true
        NV_O_VER=${NV_ARR[1]}
        NV_N_VER=${NV_ARR[2]}
    else
        NV_DATA=$(${PIP_PATH}/pip freeze | grep sickchill)
        NV_DATA=="${NV_DATA//==/$' '}"
        NV_ARR=( $NV_DATA )
        NV_O_VER=${NV_ARR[1]}
        NV_N_VER=${NV_ARR[1]}
    fi
}

function update_pip() {
    ${PIP_PATH}pip -q install --upgrade sickchill
}

function update_git() {
    git pull
}

function restart_sickchill() {
    echo "Restarting Sickchill..."
    pkill -9 -fu "$(whoami)" 'SickChill.py'
    rm -rf ${SICKCHILL_PID}
    ${PIP_PATH}/python ${PIP_PATH}/SickChill.py -d --pidfile="$SICKCHILL_PID"
}

###################################################################################################################

echo '  _____   _          _             _       _   _   _     _    _               _           _                 '
echo ' / ____| (_)        | |           | |     (_) | | | |   | |  | |             | |         | |                '
echo '| (___    _    ___  | | __   ___  | |__    _  | | | |   | |  | |  _ __     __| |   __ _  | |_    ___   _ __ '
echo ' \___ \  | |  / __| | |/ /  / __| | '\''_ \  | | | | | |   | |  | | | '\''_ \   / _` |  / _` | | __|  / _ \ | '\''__|'
echo ' ____) | | | | (__  |   <  | (__  | | | | | | | | | |   | |__| | | |_) | | (_| | | (_| | | |_  |  __/ | |   '
echo '|_____/  |_|  \___| |_|\_\  \___| |_| |_| |_| |_| |_|    \____/  | .__/   \__,_|  \__,_|  \__|  \___| |_|   '
echo '                                                                 | |                                        '
echo 'updater version 0.1                                              |_|                                        '
echo '************************************************************************************************************'
echo ''
echo "Checking if an update is available..."

NV_REQUIRED=false
NV_O_VER=0
NV_N_VER=0

# Check if there is an update available
check_pip

echo ""
echo "Installed version:  $NV_O_VER"
echo "Latest Version:     $NV_N_VER"
echo ""

if [ "$NV_REQUIRED" = true ]; then
    echo "Update available!"
    echo ""
    # Perform the update
    echo "Updating Sickchill..."
    update_pip
    
    echo ""
    # Restart Sickchill
    restart_sickchill
else 
    echo "Sickchill is already the latest version!"
fi