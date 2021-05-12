#!/bin/bash
# Version 1.0
# Apache-2.0
# Shane Coughlan
# shane@opendawn.com

# Setting colors for priting status and options to the screen

GREEN='\033[0;32m'
RESETCOLOR='\e[0m'

# Welcome note and overview

echo -e "${GREEN}This is a script to prepare a new Ubuntu 20.04 install for Cardano."
echo -e "It is mostly based off the related https://www.coincashew.com/ guide."
echo -e "There are a few additions to deal with things like Bash not remembering"
echo -e "new PATH settings. Bug fixes and improvements welcome."
echo -e "This script is not fully automated so you will need to confirm a few things."
echo -e "\e[0m..."

# Making sure we are in the home directory

echo -e "${GREEN}Making sure we are in the home directory."
echo -e "\e[0m..."
sleep 2

cd ~

# Updating the system and cleaning it up

echo -e "${GREEN}Updating the system and cleaning it up.${RESETCOLOR}"
echo -e "\e[0m..."
sleep 2

sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get autoremove -y

# Installing key dependencies

sudo apt-get install git jq bc make automake rsync htop curl build-essential pkg-config libffi-dev libgmp-dev libssl-dev libtinfo-dev libsystemd-dev zlib1g-dev make g++ wget libncursesw5 libtool autoconf -y

# Setting up SSH

echo -e "${GREEN}Setting up SSH.${RESETCOLOR}"
echo -e "\e[0m..."
sleep 2

sudo apt-get install ssh -y

# Setting up Git
echo -e "${GREEN}Setting up Git.${RESETCOLOR}"
echo -e "\e[0m..."
sleep 2

sudo apt-get install git -y

# Confirming Git is working

echo -e "${GREEN}Confirming Git is working.${RESETCOLOR}"
echo -e "\e[0m..."
sleep 2

git --version

# Setting up CURL

echo -e "${GREEN}Setting up CURL.${RESETCOLOR}"
echo -e "\e[0m..."
sleep 2

sudo apt-get install curl -y

# Confirming CURL is working

echo -e "${GREEN}Confirming CURL is working.${RESETCOLOR}"
echo -e "\e[0m..."
sleep 2

curl --version

# Installing Libsodium

echo -e "${GREEN}Installing Libsodium.${RESETCOLOR}"
echo -e "\e[0m..."
sleep 2

mkdir $HOME/git
cd $HOME/git
git clone https://github.com/input-output-hk/libsodium
cd libsodium
git checkout 66f017f1
./autogen.sh
./configure
make
sudo make install

# Installing Cabal and dependencies.

echo -e "${GREEN}Answer NO to installing haskell-language-server (HLS).${RESETCOLOR}"
echo -e "${GREEN}Answer YES to automatically add the required PATH variable to ".bashrc".${RESETCOLOR}"
echo -e "\e[0m..."
sleep 2

sudo apt-get -y install pkg-config libgmp-dev libssl-dev libtinfo-dev libsystemd-dev zlib1g-dev build-essential curl libgmp-dev libffi-dev libncurses-dev libtinfo5

curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh

# Activate in current terminal window.
# FIXME It would be nice to do this more elegantly.

echo -e "${GREEN}Resetting ghcup path due to hiccup otherwise.${RESETCOLOR}"
echo -e "\e[0m..."
sleep 2

. "$HOME/.ghcup/env"

# Upgrading ghcup and installing Cabal

echo -e "${GREEN}Upgrading ghcup and installing Cabal.${RESETCOLOR}"
echo -e "\e[0m..."
sleep 2

ghcup upgrade
ghcup install cabal 3.4.0.0
ghcup set cabal 3.4.0.0

# Installing GHC.

echo -e "${GREEN}Installing GHC.${RESETCOLOR}"
echo -e "\e[0m..."
sleep 2

ghcup install ghc 8.10.4
ghcup set ghc 8.10.4

# Update PATH to include Cabal and GHC and add exports.

echo -e "${GREEN}Update PATH to include Cabal and GHC and add exports.${RESETCOLOR}"
echo -e "\e[0m..."
sleep 2

echo PATH="$HOME/.local/bin:$PATH" >> $HOME/.bashrc
echo export LD_LIBRARY_PATH="/usr/local/lib:$LD_LIBRARY_PATH" >> $HOME/.bashrc
echo export NODE_HOME=$HOME/cardano-node >> $HOME/.bashrc
echo export NODE_CONFIG=mainnet>> $HOME/.bashrc
echo export NODE_BUILD_NUM=$(curl https://hydra.iohk.io/job/Cardano/iohk-nix/cardano-deployment/latest-finished/download/1/index.html | grep -e "build" | sed 's/.*build\/\([0-9]*\)\/download.*/\1/g') >> $HOME/.bashrc
source $HOME/.bashrc

# Update cabal and verify the correct versions were installed successfully.

echo -e "${GREEN}Update cabal and verify the correct versions were installed successfully.${RESETCOLOR}"
echo -e "${GREEN}Cabal library should be version 3.4.0.0 and GHC should be version 8.10.4.${RESETCOLOR}"
echo -e "\e[0m..."
sleep 2

cabal update
cabal --version
ghc --version

# Building the node.

echo -e "${GREEN}Building the node.${RESETCOLOR}"
echo -e "\e[0m..."
sleep 2

cd $HOME/git
git clone https://github.com/input-output-hk/cardano-node.git
cd cardano-node
git fetch --all --recurse-submodules --tags
git checkout tags/1.26.2

# Configuring build options.

echo -e "${GREEN}Configuring build options.${RESETCOLOR}"
echo -e "\e[0m..."
sleep 2

cabal configure -O0 -w ghc-8.10.4

# Updating the Cabal configuration, project settings and resetting the build folder.

echo -e "${GREEN}Updating the Cabal configuration, project settings and resetting the build folder.${RESETCOLOR}"
echo -e "\e[0m..."
sleep 2

echo -e "package cardano-crypto-praos\n flags: -external-libsodium-vrf" > cabal.project.local
sed -i $HOME/.cabal/config -e "s/overwrite-policy:/overwrite-policy: always/g"
rm -rf $HOME/git/cardano-node/dist-newstyle/build/x86_64-linux/ghc-8.10.4

# Building the cardano-node from source code. This may take a while.

echo -e "${GREEN}Building the cardano-node from source code. This may take a while.${RESETCOLOR}"
echo -e "\e[0m..."
sleep 2

cabal build cardano-cli cardano-node

# Copying cardano-cli and cardano-node files to our binary (bin) directory.

echo -e "${GREEN}Copying cardano-cli and cardano-node files to our binary (bin) directory.${RESETCOLOR}"
echo -e "\e[0m..."
sleep 2

sudo cp $(find $HOME/git/cardano-node/dist-newstyle/build -type f -name "cardano-cli") /usr/local/bin/cardano-cli

sudo cp $(find $HOME/git/cardano-node/dist-newstyle/build -type f -name "cardano-node") /usr/local/bin/cardano-node

# Resetting Bash to fix a known bug in this script. 
# FIXME: there is an issue with this script occasionally losing bash paths on Ubuntu 20.04

source $HOME/.bashrc

# Verifying cardano-cli and cardano-node are looking good.

echo -e "${GREEN}Verifying cardano-cli and cardano-node are looking good.${RESETCOLOR}"
echo -e "\e[0m..."
sleep 2

cardano-node version
cardano-cli version

# We are done. Rebooting the system. Proceed to configure-relay/block/cold as appropriate.

echo -e "${GREEN}We are done. Rebooting the system. Proceed to configure-relay/block/cold as appropriate.${RESETCOLOR}"
echo -e "\e[0m..."
sleep 2

systemctl reboot
