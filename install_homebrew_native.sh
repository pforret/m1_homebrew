#!/bin/bash
set -uo pipefail
echo "### $0 from pforret/macos_m1_cli"

die(){
  echo "$1" >&2
  tput bel
  echo "Quitting script!" >&2
  exit 1
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

# first run git to initiate download of developer tools
echo "* If you get a MacOS popup asking to install 'developer tools', please confirm"
git version

echo "* Create a folder for Homebrew ..."
cd /opt && sudo mkdir homebrew
[[ -d "/opt/homebrew" ]] || die  "Folder [/opt/homebrew] could not be created"

sudo chown -R "$(whoami)" /opt/homebrew

echo "* Download and install Homebrew from Github ..."
# cf https://docs.brew.sh/Installation.
curl -L "https://github.com/Homebrew/brew/tarball/master" | tar xz --strip 1 -C homebrew

[[ -x "/opt/homebrew/bin/brew" ]] || die "Executable [/opt/homebrew/bin/brew] not found"

startup_config(){
  comment="#M1HBnat"
  echo "## /opt/homebrew is homebrew for native Apple ARM M1 mode  $comment"
  echo "export PATH=/opt/homebrew/bin:\$PATH                       $comment"
  echo "alias brew1 \"brew --build-from-source\"                   $comment"
}

case $(basename "$SHELL") in
zsh)
  echo "* Adding [/opt/homebrew/bin] to your zsh startup config path"
  startup_config >> ~/.zshrc
  ;;

bash)
  echo "* Adding [/opt/homebrew/bin] to your bash startup config path"
  startup_config >> ~/.bashrc
  ;;

*)
  echo "Add the following to your shell startup script, could not be done automatically" >&2
  echo "#####"
  startup_config
  echo "#####"
esac

echo "* Running brew a first time to trigger compilation"
/opt/homebrew/bin/brew install --build-from-source -q awk 2> /dev/null

echo "* Homebrew was installed as native binary. Version will be > 2.6"
/opt/homebrew/bin/brew config | grep VERSION
echo "* Installation using 'brew install' will give a warning as long as Homebrew is not yet officially released for M1"
echo "* You can use 'brew1 install' to always build from source and skip that warning"
echo "* You might get build errors, but remember: you are now doing bleeding edge CLI Terminal!"

echo "> Close this Terminal and start a new one to make sure brew is in the path"
