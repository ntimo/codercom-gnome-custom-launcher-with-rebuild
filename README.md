# codercom-gnome-custom-launcher-with-rebuild

## Synopsis
This custom desktop shortcut was created since coder currently can't start a workspace that is turned off, and will then run into an error if you just try to start code server using the normal chrome pwa. This shortcut fixes this by using the coderc cli to start the workspace before launching chrome.

This can be used with multiple applications that you have in your coder workspace for example VSCode or PyCharm

This has been tested with Zorin OS 16 (Ubuntu 20.04).

## Requierments:
- A Coder.com instance
- The [Coder CLI](github.com/cdr/coder-cli/)

## Install guide
- Install the Coder CLI if not done already
- Login to coder using `coder login` in your terminal
- Start google chrome and setup the normal PWA for code server using coder [docs link with how to](https://coder.com/docs/coder/v1.23/workspaces/pwa)
- Grep the chrome app id from the .desktop file chrome created in `~/.local/share/applications/chrome*.desktop` the file will list `NAME=coder`
- Find a nice looking VSCode icon on google and download it to `~/.local/share/icons/coder/<application name>.png`
- Copy the desktop file from this repo to `~/.local/share/applications/VSCode.desktop`
  - Update the file with the icon path and the path to the start_coder.sh
  - Update the args of the start_coder.sh with the `<application name>` followed by the `<workspace name>` and then the `<chrome app id>`
- Copy the start_coder.sh to your home directory and make it executable `chmod +x start_coder.sh`
- Try it out and have fun.
