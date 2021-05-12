#!/bin/bash
# Version 1.0
# Apache-2.0
# Shane Coughlan
# shane@opendawn.com

# Setting colors for priting status and options to the screen

GREEN='\033[0;32m'
RESETCOLOR='\e[0m'

# Welcome note and overview

echo -e "${GREEN}This is a script to prepare a Cardano node."
echo -e "This is for a cold node."
echo -e "\e[0m..."

echo export NODE_HOME=$HOME/cardano-node >> $HOME/.bashrc
source $HOME/.bashrc
mkdir -p $NODE_HOME

# There are physical steps required here before you can proceed.
# This is necessary before this machine can generate the keys you need.
# 1: Get a copy of the cardano-cli binaries from the block node. 
# You will find them in /usr/local/bin/cardano-node on that machine.
# 2: Put them in /usr/local/bin/cardano-node on this machine.
# When you have done that you are ready to generate keys.
#
# Time to do some reading to accomplish that!
# https://www.coincashew.com/coins/overview-ada/guide-how-to-build-a-haskell-stakepool-node#9-generate-block-producer-keys

echo -e "${GREEN}There are physical steps required here before you can proceed."
echo -e "This is necessary before this machine can generate the keys you need."
echo -e "1: Get a copy of the cardano-cli binaries from the block node."
echo -e "You will find them in /usr/local/bin/cardano-node on that machine."
echo -e "2: Put them in /usr/local/bin/cardano-node on this machine."
echo -e "\e[0m..."
echo -e "When you have done that you are ready to generate keys."
echo -e "Time to do some reading to accomplish that!"
echo -e "https://www.coincashew.com/coins/overview-ada/guide-how-to-build-a-haskell-stakepool-node#9-generate-block-producer-keys"
