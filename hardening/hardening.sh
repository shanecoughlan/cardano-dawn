# Setting colors for priting status and options to the screen

GREEN='\033[1;32m'
RESETCOLOR='\e[0m'

# Making sure we are in the home directory

cd ~

# Updating the system and cleaning it up

echo -e "${GREEN}Updating the system and cleaning it up.${RESETCOLOR}"
echo -e "\e[0m..."

sleep 2

sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get autoremove -y

# Setting up SSH
# Allowing user SSH but not allowing root SSH
# Activating the following:
# PermitRootLogin no
# MaxAuthTries 5
# Protocol 2
# ChallengeResponseAuthentication yes

echo -e "${GREEN}Setting up SSH.${RESETCOLOR}"
echo -e "${GREEN}Activating the following:${RESETCOLOR}"
echo -e "${GREEN}PermitRootLogin no${RESETCOLOR}"
echo -e "${GREEN}MaxAuthTries 5${RESETCOLOR}"
echo -e "${GREEN}Protocol 2${RESETCOLOR}"
echo -e "${GREEN}ChallengeResponseAuthentication yes${RESETCOLOR}"
echo -e "\e[0m..."

sleep 2

sudo mv /home/lovelace/sshd_config /etc/ssh/sshd_config

sudo systemctl restart ssh

# Installing two factor authentication

echo -e "${GREEN}Installing two factor authentication.${RESETCOLOR}"
echo -e "\e[0m..."

sleep 2

sudo apt install libpam-google-authenticator

# Next we want to update sshd for /etc/pam.d/sshd
# auth required pam_google_authenticator.so

echo -e "${GREEN}Next we want to update sshd for /etc/pam.d/sshd.${RESETCOLOR}"
echo -e "${GREEN}auth required pam_google_authenticator.so.${RESETCOLOR}"
echo -e "\e[0m..."

sleep 2

sudo mv /home/lovelace/sshd /etc/pam.d/sshd

# Turning off printer discovery

echo -e "${GREEN}Turning off printer discovery.${RESETCOLOR}"
echo -e "\e[0m..."

sleep 2

sudo systemctl stop cups-browsed
sudo systemctl disable cups-browsed

# Allowing outgoing but not allowing incoming port connections

echo -e "${GREEN}Allowing outgoing but not allowing incoming port connections.${RESETCOLOR}"
echo -e "\e[0m..."

sleep 2

sudo ufw default allow outgoing
sudo ufw default deny incoming

# Allowing SSH connections

echo -e "${GREEN}Allowing SSH connections.${RESETCOLOR}"
echo -e "\e[0m..."

sleep 2

sudo ufw allow ssh

# Allowed ports and explanations
# 53 – Domain Name System (DNS)
# 80 – Hypertext Transfer Protocol (HTTP)
# 443 – HTTP Secure (HTTPS)

echo -e "${GREEN}Allowing DNS, HTTP and HTTPS ports.${RESETCOLOR}"
echo -e "\e[0m..."

sleep 2

sudo ufw allow 53
sudo ufw allow 80
sudo ufw allow 443

# Allowing Cardano ports 3000, 3001 and 6000

echo -e "${GREEN}Allowing Cardano ports 3000, 3001 and 6000.${RESETCOLOR}"
echo -e "\e[0m..."

sleep 2

sudo ufw allow 3000
sudo ufw allow 3001
sudo ufw allow 6000

# Allowing Cardano EKG port 12788

echo -e "${GREEN}Allowing Cardano EKG port 12788.${RESETCOLOR}"
echo -e "\e[0m..."

sleep 2

sudo ufw allow 12788

echo -e "${GREEN}Turning on Firewall logging.${RESETCOLOR}"
echo -e "\e[0m..."

sleep 2

sudo ufw logging on

# Turning on the Firewall

echo -e "${GREEN}Turning on the Firewall.${RESETCOLOR}"
echo -e "\e[0m..."

sleep 2

sudo ufw enable

# Checking Firewall status

echo -e "${GREEN}Checking Firewall status.${RESETCOLOR}"
echo -e "\e[0m..."

sleep 2

sudo ufw status

# Setting up Fail2ban

echo -e "${GREEN}Setting up Fail2ban.${RESETCOLOR}"
echo -e "\e[0m..."

sleep 2

sudo apt install fail2ban

# Confirming Fail2ban is working

echo -e "${GREEN}Confirming Fail2ban is working.${RESETCOLOR}"
echo -e "\e[0m..."

sleep 2

sudo fail2ban-client status

# Inserting our customizations for Fail2ban

echo -e "${GREEN}Inserting our customizations for Fail2ban.${RESETCOLOR}"
echo -e "\e[0m..."

sleep 2

sudo mv /home/lovelace/jail.local /etc/fail2ban/jail.local

# Restarting to Fail2ban to confirm customizations

echo -e "${GREEN}Restarting to Fail2ban to confirm customizations.${RESETCOLOR}"
echo -e "\e[0m..."

sleep 2

sudo service fail2ban restart

# Confirming Fail2ban is working

echo -e "${GREEN}Confirming Fail2ban is working.${RESETCOLOR}"
echo -e "\e[0m..."

sleep 2

sudo fail2ban-client status

# Removing various connection servers

echo -e "${GREEN}Removing various connection servers.${RESETCOLOR}"
echo -e "\e[0m..."

sleep 2

sudo apt remove tftpd-hpa -y
sudo apt-get remove telnet -y

echo -e "${GREEN}We are done.${RESETCOLOR}"
echo -e "${GREEN}Run "google-authenticator" to set up two-factor authentication.${RESETCOLOR}"
echo -e "\e[0m..." 

sleep 2
