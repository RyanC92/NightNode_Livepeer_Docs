# Livepeer Update Tool

This tool is relatively simple and if meant to be deployed IF you have configured your livepeer setup in the following directory, if not, please modify the script to move the livepeer files to your install directory.

```/etc/livepeer/```



## Usage:

### Please modify this file to fit your services that you are utilizing, this will stop and start services based upon the serivces used in the install scripts and will not automatically conform to your setup!                                                                                                          



Download the update script by using 

``` wget https://github.com/NightWolf92/NightNode_Livepeer_Docs/raw/main/Maintenance/Linux/Update/livepeer_update.sh ```

After downloading turn it into an executable by running the following command

``` chmod +x livepeer_update.sh ```

To run the script:

``` ./livepeer_update.sh ```

Code in one run:
```
wget https://github.com/NightWolf92/NightNode_Livepeer_Docs/raw/main/Maintenance/Linux/Update/livepeer_update.sh
chmod +x livepeer_update.sh
./livepeer_update.sh
```

## Steps this script will take:

The script will create a temporary directory called livepeersetup in your $HOME directory, this will later be removed at the end. 

Next, it will download and extract the livepeer files, stop your ```livepeer.service``` and ```orchestrator.target``` files ([part of this install script](https://github.com/NightWolf92/NightNode_Livepeer_Docs/tree/main/Install/Linux)) and copy the files to the ```/etc/livepeer/``` directory. 

Finally it will then remove the livepeersetup folder from your $HOME directory and restart ```livepeer.service``` and ```orchestrator.target```.

## Lessons Learned:

This script will always download the latest release of livepeer by using the following url:

```https://github.com/livepeer/go-livepeer/releases/latest/download/livepeer-linux-amd64.tar.gz```
