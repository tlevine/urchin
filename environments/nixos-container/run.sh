#!/bin/sh
set -e

# Create the container.
if ! nixos-container list | grep ^urchin$ > /dev/null; then
  sudo nixos-container create urchin
fi

# Configure the container.
sudo cp configuration.nix \
  /var/lib/containers/urchin/etc/nixos/configuration.nix
sudo nixos-container update urchin
sudo nixos-container start urchin

# Create the git repository.
host="tlevine@$(nixos-container show-ip urchin)"
ssh "${host}" 'if mkdir urchin 2> /dev/null; then
    cd urchin
    git init
    git config --add receive.denyCurrentBranch ignore
  fi
'

# Push to the git repository
git push "${host}":urchin

# Print information
echo "Log in:

  ssh ${host}

Add git remote

  git remote add ${host} container

"
