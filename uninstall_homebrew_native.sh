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
  echo "🧽 $1"
  sleep 1
}
[[ -x "/opt/homebrew/bin/brew" ]] || die "Homebrew is not installed on [/opt/homebrew]"

# Sanity check, only run on MacOs in native mode
[[ $(uname) == "Darwin" ]] || die "This script should only be run on a MacOS machine"
[[ $(uname -m) == "arm64" ]] || die "This script should only be run in native mode, not with Rosetta 2"

remove_from_config(){
  comment="#M1HBnat"
  conffile="$1"
  tempfile="$1.tmp"
  < "$conffile" grep -v "$comment" > "$tempfile"
  [[ -f "$tempfile" ]] && [[ $(< "$tempfile" wc -l) -gt 0 ]] && mv "$conffile" "$conffile.bak" && mv "$tempfile" "$conffile"
}

case $(basename "$SHELL") in
zsh)
  progress "Removing [/opt/homebrew/bin] from your zsh startup config path"
  remove_from_config ~/.zshrc
  ;;

bash)
  progress "Removing [/opt/homebrew/bin] from your bash startup config path"
  remove_from_config ~/.bashrc
  ;;

*)
  progress "Remove all lines mentioning /opt/homebrew from your startup scripts: " >&2
  sleep 1
esac

progress "Deleting Homebrew from [/opt/homebrew]"
sudo rm -fr /opt/homebrew

[[ -d "/opt/homebrew" ]] && die "Could not remove [/opt/homebrew]"
progress "Homebrew was uninstalled!"