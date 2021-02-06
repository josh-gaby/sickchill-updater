#!/bin/bash

# This should be set to either PIP or GIT depending on how you installed Sickchill
INSTALL_TYPE=""

# Path to your Sickchill installation (no trailing slash), this should point to the directory that contains your Sickchill.py file 
SICKCHILL_PATH=""

# Path to your Sickchill pid file, leave empty if you dont start Sickchill with a --pidfile option
SICKCHILL_PID=""

# Path to your pip installation (no trailing slash), only required if INSTALL_TYPE is set to PIP and you dont want to use your systems default version of pip
PIP_PATH=""

# You can set this to a spicific python binary if required, or you can leave it empty and Sickchill will be restarted using your systems default python
PYTHON_PATH=""

###################################################################################################################

function check_pip() {

    if [ -n "$PIP_PATH" ] ; then
        NV_DATA=$(${PIP_PATH}/pip list --outdated | grep sickchill)
        if [[ -n "$NV_DATA" ]] ; then
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
    else
        echo "    PIP_PATH has not been set, exiting."
        exit 1
    fi
}

function check_git() {
    if [ -n "$SICKCHILL_PATH" ] ; then
        # Make sure we are in the Sickchill directory
        cd "$SICKCHILL_PATH"
        NV_O_VER=$(git rev-parse HEAD)
        NV_N_VER=$(git rev-parse --verify --quiet "@{upstream}")
        if [ $NV_O_VER != $NV_N_VER ] ; then
            NV_REQUIRED=true
        fi
    else
        echo "    SICKCHILL_PATH has not been set, exiting."
        exit 1
    fi
}

function update_pip() {
    if [ -n "$PIP_PATH" ] ; then
        ${PIP_PATH}/pip -q install --upgrade sickchill
    else
        echo "    PIP_PATH has not been set, exiting."
        exit 1
    fi
}

function update_git() {
    if [ -n "$SICKCHILL_PATH" ] ; then
        # Make sure we are in the Sickchill directory
        cd "$SICKCHILL_PATH"
        # Pull in the latest version using git
        git pull
    else
        echo "    SICKCHILL_PATH has not been set, exiting."
        exit 1
    fi
}

function restart_sickchill() {
    echo "Restarting Sickchill..."
    
    pkill -9 -fu "$(whoami)" 'SickChill.py'

    if [ -z "$SICKCHILL_PID" ] ; then
        ${PYTHON_PATH} ${SICKCHILL_PATH}/SickChill.py -d
    else
        rm -rf ${SICKCHILL_PID}
        ${PYTHON_PATH} ${SICKCHILL_PATH}/SickChill.py -d --pidfile="$SICKCHILL_PID"
    fi
}

###################################################################################################################
echo '                                                        '
echo '  #####                   #####                         '
echo ' #     # #  ####  #    # #     # #    # # #      #      '
echo ' #       # #    # #   #  #       #    # # #      #      '
echo '  #####  # #      ####   #       ###### # #      #      '
echo '       # # #      #  #   #       #    # # #      #      '
echo ' #     # # #    # #   #  #     # #    # # #      #      '
echo '  #####  #  ####  #    #  #####  #    # # ###### ###### '
echo '                                                        '
echo ' #     #                                                '
echo ' #     # #####  #####    ##   ##### ###### #####        '
echo ' #     # #    # #    #  #  #    #   #      #    #       '
echo ' #     # #    # #    # #    #   #   #####  #    #       '
echo ' #     # #####  #    # ######   #   #      #####        '
echo ' #     # #      #    # #    #   #   #      #   #        '
echo '  #####  #      #####  #    #   #   ###### #    #       '
echo '                                                        '
echo ' version 0.2                                            '
echo '********************************************************'

# Make sure that python path contains the correct python command if it has been left empty
if [ -z "$PYTHON_PATH" ] ; then
    if [ -z "$PIP_PATH" ] ; then
        PYTHON_PATH="python"
    else
        PYTHON_PATH="${PIP_PATH}/python"
    fi
fi

echo ''
echo "Checking if there is an update is available..."

NV_REQUIRED=false
NV_O_VER=0
NV_N_VER=0

# Check if there is an update available
if [ "$INSTALL_TYPE" = "PIP" ] ; then
    check_pip
else
    check_git
fi

echo ""
echo "Installed version:  $NV_O_VER"
echo "Latest Version:     $NV_N_VER"
echo ""

if [ "$NV_REQUIRED" = true ] ; then
    echo "Update available!"
    echo ""
    # Perform the update
    echo "Updating Sickchill..."
    if [ "$INSTALL_TYPE" = "PIP" ] ; then
        update_pip
    else
        update_git
    fi

    echo ""
    # Restart Sickchill
    restart_sickchill
else 
    echo "Sickchill is already the latest version!"
fi
