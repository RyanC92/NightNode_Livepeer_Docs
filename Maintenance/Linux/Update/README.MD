# Livepeer Update Tool

This tool is relatively simple and if meant to be deployed IF you have configured your livepeer setup in the following directory, if not, please modify the script to move the livepeer files to your install directory.

```/etc/livepeer/```

This script will always download the latest release of livepeer by using the following url:

```https://github.com/livepeer/go-livepeer/releases/latest/download/livepeer-linux-amd64.tar.gz```

## Steps this script will take:

The script will create a temporary directory called livepeersetup in your $HOME directory, this will later be removed at the end. 

Next, it will download and extract the livepeer files, stop your ```livepeer.service``` and ```orchestrator.target``` files ([part of this install script](https://github.com/NightWolf92/NightNode_Livepeer_Docs/tree/main/Install/Linux)) and copy the files to the ```/etc/livepeer/``` directory. 

Finally it will then remove the livepeersetup folder from your $HOME directory and restart ```livepeer.service``` and ```orchestrator.target```.
