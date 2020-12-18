#!/bin/bash
set -uo pipefail
echo "### $(basename $0) from pforret/macos_m1_cli  Ⓜ️ 1️⃣ "

die(){
  echo "🟥 $1" >&2
  tput bel
  echo "Quitting script!" >&2
  exit 1
}

progress(){
  echo "🍺 $1"
  sleep 1
}

if [[ -x "/opt/homebrew/bin/brew" ]] ; then
  /opt/homebrew/bin/brew update > /dev/null
  /opt/homebrew/bin/brew config | grep VERSION
  die "Homebrew is already installed at [/opt/homebrew/bin]"
fi

# Sanity check, only run on MacOs in native mode
[[ $(uname) == "Darwin" ]] || die "This script should only be run on a MacOS machine"
[[ $(uname -m) == "arm64" ]] || die "This script should only be run in native mode, not with Rosetta 2"
[[ $UID -eq 0 ]] && die "You should not be root to run this script"

# first check for developer tools
if [[ ! -x "/Library/Developer/CommandLineTools/usr/bin/git" ]] ; then
  progress "First install Xcode develop tools"
  xcode-select --install
fi

progress "Create a folder for Homebrew ..."
cd /opt && sudo mkdir homebrew
[[ -d "/opt/homebrew" ]] || die  "Folder [/opt/homebrew] could not be created"

sudo chown -R "$(whoami)" /opt/homebrew

progress "Download and install Homebrew from Github ..."
# cf https://docs.brew.sh/Installation.
curl -s -L "https://github.com/Homebrew/brew/tarball/master" | tar xz --strip 1 -C homebrew

[[ -x "/opt/homebrew/bin/brew" ]] || die "Executable [/opt/homebrew/bin/brew] not found"

startup_config(){
  comment="#M1HBnat"
  echo "## /opt/homebrew contains homebrew for native Apple ARM M1 mode  $comment"
  echo "export PATH=\"/opt/homebrew/bin:\$PATH\"                   $comment"
}

case $(basename "$SHELL") in
zsh)
  progress "Adding [/opt/homebrew/bin] to your zsh startup config path"
  startup_config >> ~/.zshrc
  ;;

bash)
  progress "Adding [/opt/homebrew/bin] to your bash startup config path"
  startup_config >> ~/.bashrc
  ;;

*)
  progress "Add the following to your shell startup script, could not be done automatically"
  echo "#####"
  startup_config
  echo "#####"
esac

progress "Running brew a first time to trigger compilation"
/opt/homebrew/bin/brew install --build-from-source -q awk 2> /dev/null

progress "Homebrew was installed as native binary. Version will be > 2.6"
/opt/homebrew/bin/brew config | grep VERSION
echo "#===================================="
progress "Installation using 'brew install' will give a warning as long as Homebrew is not yet officially released for M1"
progress "You can use 'brew install -s' to always build from source and skip that warning"
progress "You might get build errors, but remember: you are an early adopter!"
echo "#===================================="

progress "Close this terminal and start a new one to make sure brew is in the path"
