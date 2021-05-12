# cardano-setup
This is a repository helping Cardano pool operators to quickly set up relatively secure nodes. This will take you to Step 9 of the CoinCashew guide for setting up nodes + it will help you with basic hardening.

Author: Shane Coughlan
License: Apache 2.0
Contact: shane@opendawn.com

### Get started:

1. Get a copy of Ubuntu 20.04.
2. Install it to a computer or virtual machine.
3. Create a user called "lovelace"

### Create a basic node:

1. Put "basic-preparation.sh" into the lovelace home directory.
2. Put "configure-block.sh" or "configure-relay.sh" or "configure-cold.sh" into the lovelace home directory, depending on what type of Cardano node you want to create.
3. Run "sudo bash basic-preparation.sh"
4. Run "configure-block" or "configure-relay.sh" or "configure-cold.sh" into the lovelace home directory, depending on what type of Cardano node you want to create.

### Harden the basic node:

1. Put the files from the "hardening" directory into the lovelace home directory.
2. Run "hardening.sh"

### Continue your configuration:

Start reading CoinCashew's Step 9 here: 
* https://www.coincashew.com/coins/overview-ada/guide-how-to-build-a-haskell-stakepool-node#9-generate-block-producer-keys
