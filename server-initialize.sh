#!/bin/bash

cd ~
# Set DIR variable to the directory that this script was launched from
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
LOGFILE="$DIR/mc-server-initialize.log"


#Update & install other preqeqs
sudo apt update
sudo apt install -y screen
sudo apt install -y awscli
sudo apt install -y htop

#install java
cd /opt
until sudo aws s3 cp s3://mc-server-main-78009249/jdk-8u191-linux-x64.tar.gz .
do
  echo "java download timed out, retrying in 10 sec" >> "$LOGFILE"
  sleep 10
done
sudo tar -zxf jdk-8u191-linux-x64.tar.gz
sudo update-alternatives --install /usr/bin/java java /opt/jdk1.8.0_191/bin/java 1
cd ~

# download latest save save, retry if necessary
until aws s3 cp s3://mc-server-main-78009249/mc-server-backup.tar.gz ~
do
  echo "download timed out, trying again in 10 seconds..." >> "$LOGFILE"
  sleep 10
done


# download other scripts from s3 and set permissions
aws s3 cp s3://mc-server-main-78009249/server-backup.sh ~ >> "$LOGFILE"
aws s3 cp s3://mc-server-main-78009249/server-cleanup.sh ~ >> "$LOGFILE"
aws s3 cp s3://mc-server-main-78009249/ddns.sh ~ >> "$LOGFILE"
chmod +x *.sh

# run ddns script
bash ~/ddns.sh

#unzip & delete save
tar -zxf mc-server-backup.tar.gz
rm mc-server-backup.tar.gz

#execute the server in screen
cd ~/minecraft-atm
screen -S minecraft-server -d -m ./ServerStart.sh

echo "initialization completed" >> "$LOGFILE"
