#!/bin/bash

if [[ -x "/opt/homebrew/bin/brew" ]] ; then
  echo "Homebrew is already installed at [/opt/homebrew/bin], quitting script!" >&2
  /opt/homebrew/bin/brew update
  /opt/homebrew/bin/brew config | grep VERSION
  exit 1
fi

# first run git to initiate download of developer tools
echo "* Check if git is installed ..."
git version || echo "If you get a popup asking to install 'developer tools', please say yes" >&2

echo "* Create a folder for Homebrew ..."
cd /opt && sudo mkdir homebrew
if [[ ! -f "/opt/homebrew" ]] ; then
  echo "Folder [/opt/homebrew] could not be created, quitting script!" >&2
  exit 1
fi
sudo chown -R "$(whoami)" /opt/homebrew

echo "* Download and install Homebrew ..."
# cf https://docs.brew.sh/Installation.
curl -L "https://github.com/Homebrew/brew/tarball/master" | tar xz --strip 1 -C homebrew

if [[ ! -x "/opt/homebrew/bin/brew" ]] ; then
  echo "Executable [/opt/homebrew/bin/brew] not found, quitting script!" >&2
  exit 1
fi

case $(basename "$SHELL") in
zsh)
  echo "* Adding [/opt/homebrew/bin] to your zsh startup config path"
  echo "export PATH=/opt/homebrew/bin:$PATH" >> ~/.zshrc
  ;;
bash)
  echo "* Adding [/opt/homebrew/bin] to your bash startup config path"
  echo "export PATH=/opt/homebrew/bin:$PATH" >> ~/.bashrc
  ;;
*)
  echo "Please add [/opt/homebrew/bin] to your path, could not be done automatically" >&2
esac

echo "* Running brew a first time to trigger compilation"
/opt/homebrew/bin/brewbrew install --build-from-source -q awk 2> /dev/null

echo "* Homebrew was installed as native binary. Version will be > 2.6"
/opt/homebrew/bin/brew config | grep VERSION

echo "* Rosetta 2 should be 'false'"
/opt/homebrew/bin/brew config | grep Rosetta
