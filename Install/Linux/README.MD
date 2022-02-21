# Documentation

* Additional documentation for the  can be found [Here](https://github.com/NightWolf92/NightNode_Livepeer_Docs/tree/main/Documentation) 
* Developer documentation (i.e. if you are interested in developing go-livepeer) can be found in the [docs](https://github.com/livepeer/go-livepeer/blob/master/doc) folder
* Protocol information can be found in the [protocol](https://github.com/livepeer/protocol) repo
* Other project information can be found in the [wiki](https://github.com/livepeer/wiki/wiki)


# Installation (Part 1)
### Notes: 
1. There is a lot of information here, a lot of custom configurations can be done to meet your needs, this may just cover a few of them.
2. Please backup/remove any pre-existing Livepeer, Prometheus or Grafana files prior to using this script. We do not take responsibility for any lost files as a result of using these scripts. 

### Linux

First, fetch the latest install script 
```
wget https://github.com/NightWolf92/NightNode_Livepeer_Docs/raw/main/Install/Linux/setup.sh
```
Next, run the following commands to make it executable

```
chmod +x setup.sh
```

Run the "setup.sh" file

```
./setup.sh
```


#### Combined commands for a single copy and paste

```
wget https://github.com/NightWolf92/NightNode_Livepeer_Docs/raw/main/Install/Linux/setup.sh
chmod +x setup.sh
./setup.sh

```

This will prompt the script to download all necessary files for Livepeer, prometheus and grafana and install all 3 applications

Currently it is necessary to modify the livepeer.sh and livepeer.conf file to fit your environment

By default the script will utilize the directories
```
/etc/prometheus
/etc/systemd/system/
/etc/livepeer/
/var/lib/livepeer/
```

# Modifications

### livepeer.service (Modify to select your config file)

1. In the ```/etc/systemd/system``` directory modify the ```livepeer.service``` file to point the configuration file to either the ```livepeer_orchestrator.conf```, ```livepeer_orchestratorcombo.conf``` or the ```livepeer_transcoder.conf``` file. 

2. In the ```/usr/local/bin/livepeer``` directory modify the configuration file you want to use with your instance. 
  * If you're running a Standalone Orchestrator and have transcoder connect to you remotely, use the ```livepeer_orchestrator.conf``` file. 
  * If you're running an Orchestrator/Transcoder on the same machine AND in the same process, use the ```livepeer_orchestratorcombo.conf``` file.
  * If you're running an Orchestrator/Transcoder on the same machine BUT in separate process windows (useful if you plan to include external remote transcoders), modify ```livepeer_transcoder.service``` to point towards ```livepeer_transcoder.conf``` and use ```livepeer_orchestrator.conf``` for ```livepeer.service```. The ```livepeer_transcoder.service``` will require you to ```enable``` and ```start``` the process manually (on the first launch, after doing that it should run on startup.) OR include it in the ```orchestrator.target``` ```"Wants"``` line
  * If you're running a Standalone Transcoder that will remotely connect to a remote Orchestrator, use the ```livepeer_transcoder.conf``` file.
    * Additionally, only enable the ```transcoder.target``` ```prometheus.service``` and ```livepeer.service``` service files.


## For Orchestrators:
### [livepeer_orchestrator.conf](https://github.com/NightWolf92/NightNode_Livepeer_Docs/blob/main/Install/Linux/livepeer_orchestrator.conf) (For Standalone Orchestrators)

```
orchestrator
ethUrl <infura|geth|alchemy url>
orchSecret <path to file|string password>
ethPassword <path to file|string password>
ethKeystorePath /var/lib/livepeer/.lpData/arbitrum-one-mainnet/keystore/
datadir /var/lib/livepeer/.lpData/arbitrum-one-mainnet/
serviceAddr <orchestrator url or ip>
maxGasPrice <maximum gas price to redeem a wining ticket, denoted in gwei. Example: 60 Gwei is denoted by 60000000000>
pricePerUnit <usually set between 800-1200>
reward <true|false>
maxSessions <#>
nvidia <all|0,1,2,3 etc.>
monitor 
v 6
autoAdjusPrice <true|false>
```


## For Orchestrator/Transcoder Combo:
### [livepeer_orchestratorcombo.conf](https://github.com/NightWolf92/NightNode_Livepeer_Docs/blob/main/Install/Linux/livepeer_orchestratorcombo.conf) (For Orchestrator/Transcoder Combo, running in the same process)

```
orchestrator
transcoder
ethUrl <infura|geth|alchemy url>
orchSecret <path to file|string password>
ethPassword <path to file|string password>
ethKeystorePath /var/lib/livepeer/.lpData/arbitrum-one-mainnet/keystore/
datadir /var/lib/livepeer/.lpData/arbitrum-one-mainnet/
serviceAddr <orchestrator url or ip>
maxGasPrice <maximum gas price to redeem a wining ticket, denoted in gwei. Example: 60 Gwei is denoted by 60000000000>
pricePerUnit <usually set between 800-1200>
reward <true|false> #Set this to false, I've had instances where a reward call is still called even though this value defaults to false.
maxSessions <#>
nvidia <all|0,1,2,3 etc.>
monitor 
v 6
autoAdjusPrice <true|false>
```


## For Transcoders: 
### [livepeer_transcoder.conf](https://github.com/NightWolf92/NightNode_Livepeer_Docs/blob/main/Install/Linux/livepeer_transcoder.conf) (For standalone transcoders)

```
transcoder
orchSecret <path to file|string password>
reward <true|false> #only needed if you arere using the same wallet on the same machine as the Orchestrator
maxSessions <# of sessions>
orchAddr <orchestrator domain or IP:8935>
nvidia <all|0,1,2,3 etc.>
monitor 
v 6
```
Note: reward false is not technically needed if you're not an orchestrator. However, if you're using the transcoder on the same host as the orchestrator, theres a risk of the transcoder calling the reward without the flag set to false. 


# Installation (Part 2)

Once you've run through Part 1, the necessary files should have been downloaded and moved to their proper directories. If you haven't already, go back and edit the ```livepeer.service```, ```livepeer_transcoder.service```*(if applicable)* and any of the configuration files. 

If you have a backup of prometheus's Data folder, you may copy it into ```/etc/prometheus```.
Backups of your eth wallet can be copied into ```/var/lib/livepeer/.lpData/```.

At this point you can start enabling services. 
There is a script called ```Livepeer_Setup_Services.sh``` that will handle the enabling of the following services:

```
prometheus.service
grafana-server 
livepeer.service
orchestrator.target
```

Services like ```transcoder.target``` and ```livepeer_transcoder.service``` would need to be enabled separately.

(Commands to enable and startup the services are ```sudo systemctl enable <Service>``` and ```sudo systemctl start <service>```)

At this point livepeer, prometheus and grafana will all be running. 
 * To configure grafana go to ```127.0.0.1:3000```
 * To view or configure prometheus go to ```127.0.0.1:9090/metrics```

# Feedback

### Please feel free to submit feedback using the link below which will create a github issue
https://forms.gle/ASZeodPwp3uQntzC8

