#!/bin/bash

# Author: ntimo (https://github.com/ntimo)
# Description: This script can be used to turn on a coder workspace before
#              starting chrome since this is currently not possible by coder.
#              It also prints nice help messages.


CODER_APPLICATION=$1
WS_NAME="$2"
CHROME_APP_ID="$3"
CODER_ICON="$HOME/.local/share/icons/coder/$CODER_APPLICATION.png"

if [ $CODER_APPLICATION == "" ]; then
  notify-send "Coder" "CODER_APPLICATION can't be empty please add it to your .desktop file"
  exit 1
fi
if [ $WS_NAME == "" ]; then
  notify-send "Coder" "WS_NAME can't be empty please add it to your .desktop file"
  exit 1
fi
if [ $CHROME_APP_ID == "" ]; then
  notify-send "Coder" "CHROME_APP_ID can't be empty please  add it to your .desktop file"
  exit 1
fi

function get_ws_status() {
  while read -r line ; do
    ws=$(cut -d ";" -f1 <<< $line)
    status=$(cut -d ";" -f2 <<< $line)
    if [ "$ws" == "$WS_NAME" ]; then
      WS_STATUS=$status
    fi
  done < <(coder workspaces ls | awk '{ print $1 ";" $6 }')
  return 0
}

function check_if_ws_exists() {
  WS_EXISTS="1"
  while read -r line ; do
    ws=$(cut -d ";" -f1 <<< $line)
    status=$(cut -d ";" -f2 <<< $line)
    if [ "$ws" == "$WS_NAME" ]; then
      WS_EXISTS="0"
    fi
  done < <(coder workspaces ls | awk '{ print $1 ";" $6 }')
  return 0
}

check_if_ws_exists
if [ "$WS_EXISTS" == "1" ]; then
  notify-send -i "$CODER_ICON" "Coder" "Workspace $WS_NAME was not found, please make sure the workspace exists"
  exit 1
fi

get_ws_status
if [ "$WS_STATUS" == "OFF" ];then
    notify-send -i "$CODER_ICON" "Coder" "Workspace $WS_NAME is turned off"
    coder workspaces rebuild --force "$WS_NAME"
    notify-send -i "$CODER_ICON" "Coder" "Workspace $WS_NAME is beeing rebuild"
    gnome-terminal --hide-menubar --geometry=170x40 --title="Workspace rebuild log: '$WS_NAME'" -- bash -c "coder workspaces watch-build "$WS_NAME" && exit"
    while [ "$WS_STATUS" != "ON" ]; do
      get_ws_status
      sleep 1
    done
    notify-send -i "$CODER_ICON" "Coder" "Worspace $WS_NAME rebuild. Starting Chrome.."
    sleep 2
    /opt/google/chrome/google-chrome --profile-directory=Default --app-id=$CHROME_APP_ID
  else
    notify-send -i "$CODER_ICON" "Coder" "Workspace $WS_NAME is turned on. Starting Chrome.."
    /opt/google/chrome/google-chrome --profile-directory=Default --app-id=$CHROME_APP_ID
fi
