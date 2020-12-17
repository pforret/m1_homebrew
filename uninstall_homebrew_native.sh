#!/bin/bash
set -uo pipefail
echo "### $0 from pforret/macos_m1_cli"

die(){
  echo "$1" >&2
  tput bel
  echo "Quitting script!" >&2
  exit 1
}

[[ -x "/opt/homebrew/bin/brew" ]] || die "Homebrew is not installed on [/opt/homebrew]"

# Sanity check, only run on MacOs in native mode
[[ $(uname) == "Darwin" ]] || die "This script should only be run on a MacOS machine"
[[ $(uname -m) == "arm64" ]] || die "This script should only be run in native mode, not with Rosetta 2"
[[ $UID -eq 0 ]] && die "You should not be root to run this script"

echo "* Create a folder for Homebrew ..."
cd /opt && sudo mkdir homebrew
[[ -d "/opt/homebrew" ]] || die  "Folder [/opt/homebrew] could not be created"

sudo chown -R "$(whoami)" /opt/homebrew

echo "* Download and install Homebrew from Github ..."
# cf https://docs.brew.sh/Installation.
curl -L "https://github.com/Homebrew/brew/tarball/master" | tar xz --strip 1 -C homebrew

[[ -x "/opt/homebrew/bin/brew" ]] || die "Executable [/opt/homebrew/bin/brew] not found"

remove_from_config(){
  comment="#M1HBnat"
  conffile="$1"
  tempfile="$1.tmp"
  < "$conffile" grep -v "$comment" > "$tempfile"
  [[ -f "$tempfile" ]] && [[ $(< "$tempfile" wc -l) -gt 0 ]] && mv "$conffile" "$conffile.bak" && mv "$tempfile" "$conffile"
}

case $(basename "$SHELL") in
zsh)
  echo "* Removing [/opt/homebrew/bin] from your zsh startup config path"
  remove_from_config ~/.zshrc
  ;;

bash)
  echo "* Removing [/opt/homebrew/bin] from your bash startup config path"
  remove_from_config ~/.bashrc
  ;;

*)
  echo "* Remove all lines mentioning /opt/homebrew from your startup scripts: " >&2
  sleep 1
esac

echo "* Deleting Homebrew from [/opt/homebrew]"
sudo rm -fr /opt/homebrew