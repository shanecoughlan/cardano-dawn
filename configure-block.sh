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
echo -e "You need to update something below for this to work."
echo -e "\e[0m..."

# Update the addr with your relay node's public IP address.

echo -e "${GREEN}You must add your relay node's IP address for this to work."
echo -e "${GREEN}If you have not done that please press CTRL-C and edit this file."
echo -e "\e[0m..."

RELAYNODEADDRESS='XX.XX.XX.XX'

sleep 5

mkdir $NODE_HOME
cd $NODE_HOME
wget -N https://hydra.iohk.io/build/${NODE_BUILD_NUM}/download/1/${NODE_CONFIG}-byron-genesis.json
wget -N https://hydra.iohk.io/build/${NODE_BUILD_NUM}/download/1/${NODE_CONFIG}-topology.json
wget -N https://hydra.iohk.io/build/${NODE_BUILD_NUM}/download/1/${NODE_CONFIG}-shelley-genesis.json
wget -N https://hydra.iohk.io/build/${NODE_BUILD_NUM}/download/1/${NODE_CONFIG}-config.json

# Modifying mainnet-config.json to set TraceBlockFetchDecisions to "true"

echo -e "${GREEN}Modifying mainnet-config.json to set TraceBlockFetchDecisions to "true"${RESETCOLOR}"
echo -e "\e[0m..."
sleep 2

sed -i ${NODE_CONFIG}-config.json \
    -e "s/TraceBlockFetchDecisions\": false/TraceBlockFetchDecisions\": true/g"

# Updating .bashrc with the Cardano node socket path.

echo -e "${GREEN}Modifying mainnet-config.json to set TraceBlockFetchDecisions to "true"${RESETCOLOR}"
echo -e "\e[0m..."
sleep 2

echo export CARDANO_NODE_SOCKET_PATH="$NODE_HOME/db/socket" >> $HOME/.bashrc
source $HOME/.bashrc

cat > $NODE_HOME/${NODE_CONFIG}-topology.json << EOF 
 {
    "Producers": [
      {
        "addr": "${RELAYNODEADDRESS}",
        "port": 6000,
        "valency": 1
      }
    ]
  }
EOF

# Creating a startup script.

cat > $NODE_HOME/startBlockProducingNode.sh << EOF 
#!/bin/bash
DIRECTORY=$NODE_HOME
PORT=6000
HOSTADDR=0.0.0.0
TOPOLOGY=\${DIRECTORY}/${NODE_CONFIG}-topology.json
DB_PATH=\${DIRECTORY}/db
SOCKET_PATH=\${DIRECTORY}/db/socket
CONFIG=\${DIRECTORY}/${NODE_CONFIG}-config.json
/usr/local/bin/cardano-node run --topology \${TOPOLOGY} --database-path \${DB_PATH} --socket-path \${SOCKET_PATH} --host-addr \${HOSTADDR} --port \${PORT} --config \${CONFIG}
EOF

# Adding execution permissions to the startup script.

chmod +x $NODE_HOME/startBlockProducingNode.sh

# Setting up systemd to automatically start the pool when the computer starts.

cat > $NODE_HOME/cardano-node.service << EOF 
# The Cardano node service (part of systemd)
# file: /etc/systemd/system/cardano-node.service 

[Unit]
Description     = Cardano node service
Wants           = network-online.target
After           = network-online.target 

[Service]
User            = ${USER}
Type            = simple
WorkingDirectory= ${NODE_HOME}
ExecStart       = /bin/bash -c '${NODE_HOME}/startBlockProducingNode.sh'
KillSignal=SIGINT
RestartKillSignal=SIGINT
TimeoutStopSec=2
LimitNOFILE=32768
Restart=always
RestartSec=5
SyslogIdentifier=cardano-node

[Install]
WantedBy	= multi-user.target
EOF

# Moving the systemd file to the correct location and giving it the correct permissions.

sudo mv $NODE_HOME/cardano-node.service /etc/systemd/system/cardano-node.service
sudo chmod 644 /etc/systemd/system/cardano-node.service

# Setting up auto-start at computer start.

sudo systemctl daemon-reload
sudo systemctl enable cardano-node

# Starting the node.

sudo systemctl start cardano-node

# Preparing gLiveView monitoring.

cd $NODE_HOME
sudo apt install bc tcptraceroute -y
curl -s -o gLiveView.sh https://raw.githubusercontent.com/cardano-community/guild-operators/master/scripts/cnode-helper-scripts/gLiveView.sh
curl -s -o env https://raw.githubusercontent.com/cardano-community/guild-operators/master/scripts/cnode-helper-scripts/env
chmod 755 gLiveView.sh

# Setting up our env with the updated file locations.

sed -i env \
    -e "s/\#CONFIG=\"\${CNODE_HOME}\/files\/config.json\"/CONFIG=\"\${NODE_HOME}\/mainnet-config.json\"/g" \
    -e "s/\#SOCKET=\"\${CNODE_HOME}\/sockets\/node0.socket\"/SOCKET=\"\${NODE_HOME}\/db\/socket\"/g"

# We are done. Opening gLiveView.

cd $NODE_HOME
./gLiveView.sh
