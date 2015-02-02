#!/bin/bash
echo "checking for pip & screen"
if command -v pip >/dev/null 2>&1; then
	if command -v screen >/dev/null 2>&1; then
		echo "pip & screen is installed, proceeding"
	    sudo bash -c "pip install RAVN"
	else
		echo "screen not installed, run this screep after you have screen installed"
		echo -e "install command for debian or ubuntu distros:\n\tsudo apt-get install screen"
	fi
else
    echo "pip or screen is not installed, run this script after you have installed pip & screen.";
    echo "install command for debian or ubuntu distros:\n\tsudo apt-get install python-pip screen";
    exit 1;
fi
# PIDFile
PIDFILE=$HOME/.RAVNServer/pidfile
SERVER=$HOME/.RAVNServer/server.py
# Make directory to store server.py
mkdir -p $HOME/.RAVNServer/
# Create server.py
echo "Setting up autostart for RAVN Server"
echo "Downloading autostart.py"
sudo bash -c "wget -O $HOME/.RAVNServer/server.py https://raw.githubusercontent.com/raptorbird/RAVN/master/server.py"
#sudo bash -c "cp server.py $HOME/.RAVNServer/server.py"
echo "Downloading autostart.sh"
sudo bash -c "wget -O /etc/init.d/ravnd https://raw.githubusercontent.com/raptorbird/RAVN/master/autostart.sh"
#sudo bash -c "cp autostart.sh /etc/init.d/ravnd"
echo "Setting Up autostart.sh"
touch $PIDFILE
sudo bash -c "sed -i 's|PIDFILE|$PIDFILE|g' /etc/init.d/ravnd"
sudo bash -c "sed -i 's|SERVER|$SERVER|g' /etc/init.d/ravnd"
sudo bash -c "chmod +x /etc/init.d/ravnd"
sudo bash -c "chown root:root /etc/init.d/ravnd"
sudo bash -c "update-rc.d ravnd defaults"
sudo bash -c "update-rc.d ravnd enable"