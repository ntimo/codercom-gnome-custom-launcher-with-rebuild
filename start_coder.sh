#!/bin/bash

# Author: ntimo (https://github.com/ntimo)
# Description: This script can be used to turn on a coder workspace before
#              starting chrome since this is currently not possible by coder.
#              It also prints nice help messages.


WS_NAME=""
CHROME_APP_ID=""
CODER_ICON="$HOME/.local/share/icons/coder.png"

WS_EXISTS=0
while read -r line ; do
  # parse workspace name and status from coder cmd
  ws=$(cut -d ";" -f1 <<< $line)
  status=$(cut -d ";" -f2 <<< $line)
  if [ "$ws" == "$WS_NAME" ]; then
    # workspace exists
    WS_EXISTS=$(($WS_EXISTS + 1))
    if [ "$status" == "OFF" ];then
      notify-send -i "$CODER_ICON" "Coder" "Workspace $WS_NAME is turned off"
      coder workspaces rebuild --force "$WS_NAME"
      notify-send -i "$CODER_ICON" "Coder" "Workspace $WS_NAME is beeing rebuild"
      gnome-terminal -- bash -c "coder workspaces watch-build "$WS_NAME""
      notify-send -i "$CODER_ICON" "Coder" "Worspace $WS_NAME rebuild. Starting Chrome.."
      sleep 2
      /opt/google/chrome/google-chrome --profile-directory=Default --app-id=$CHROME_APP_ID
    else
      notify-send -i "$CODER_ICON" "Coder" "Workspace $WS_NAME is turned on. Starting Chrome.."
      /opt/google/chrome/google-chrome --profile-directory=Default --app-id=$CHROME_APP_ID
    fi
  fi
done < <(coder workspaces ls | awk '{ print $1 ";" $6 }')

if [ $WS_EXISTS == 0 ]; then
  notify-send -i "$CODER_ICON" "Coder" "Workspace $WS_NAME was not found, please make sure the workspace exists"
fi
