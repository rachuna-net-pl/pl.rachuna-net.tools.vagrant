#!/bin/env bash

VAGRANT_DIRETORY="/vagrant"
SCRIPTS_LIST="$VAGRANT_DIRETORY/scripts_to_run"

echo -e "\033[1;33m===>\033[0m 🚀 Run bootstrap script"

echo -e "\033[1;33m===>\033[0m 📁 Copy userfiles to $HOME"
cp -fr /tmp/userfiles/. ~/
source "$HOME/.profile"

if [ ! -f "$SCRIPTS_LIST" ]; then
  echo "❌ Scripts list file '$SCRIPTS_LIST' not found!"
  exit 1
fi

while IFS= read -r script; do
  if [ -f "$VAGRANT_DIRETORY/$script" ]; then
    echo -e "\033[1;33m===>\033[0m 🚀 Running script: $VAGRANT_DIRETORY/$script"
    cmod +x "$VAGRANT_DIRETORY/$script"
    bash "$VAGRANT_DIRETORY/$script"
  else
    echo "❌ Script '$script' not found in '$VAGRANT_DIRET/$script'!"
  fi
done < "$SCRIPTS_LIST"
