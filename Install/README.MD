# Documentation

* Additional documentation for the  can be found [Here](https://github.com/NightWolf92/NightNode_Livepeer_Docs/tree/main/Documentation) 
* Developer documentation (i.e. if you are interested in developing go-livepeer) can be found in the [docs](https://github.com/livepeer/go-livepeer/blob/master/doc) folder
* Protocol information can be found in the [protocol](https://github.com/livepeer/protocol) repo
* Other project information can be found in the [wiki](https://github.com/livepeer/wiki/wiki)


# Installation 

### Linux

First, fetch the latest install script 
```
wget https://github.com/NightWolf92/NightNode_Livepeer_Docs/raw/main/Install/setup.sh
```
Next, run the following commands to make it executable

```
chmod +x setup.sh
```

Run the "setup.sh" file

```
./setup.sh
```

This will prompt the script to download all necessary files for Livepeer, prometheus and grafana and install all 3 applications

Currently it is necessary to modify the livepeer.sh and livepeer.conf file to fit your environment

By default the script will utilize the directories
```
/etc/prometheus
/etc/systemd/system/
/usr/local/bin/livepeer/
/usr/local/bin/prometheus/
```

# Modifications


### livepeer_orchestrator.conf (For standalone orchestrators or orchestrator/transcoder combos without separate instances)

```
<orchestrator|transcoder|both(put orchestrator and transcoder by themselves on separate lines)>
ethUrl <infura|geth|alchemy url>
orchSecret <path to file|string password>
ethPassword <path to file|string password>
serviceAddr <orchestrator url or ip>
maxGasPrice <maximum gas price to redeem a wining ticket, denoted in gwei. Example: 60 Gwei is denoted by 60000000000>
pricePerUnit <usually set between 800-1200>
reward <true|false>
maxSessions <#>
nvidia <all|0,1,2,3 etc.>
monitor 
v <1-6>
autoAdjusPrice <true|false>
```

For Transcoders: 
### livepeer_transcoder.conf (For standalone transcoders)

```
transcoder
ethUrl <infura|geth|alchemy url>
orchSecret <path to file|string password>
ethPassword <path to file|string password>
maxGasPrice <maximum gas price to redeem a wining ticket, denoted in gwei. Example: 60 Gwei is denoted by 60000000000>
reward false
maxSessions <#>
orchAddr <orchestrator domain or IP:8935>
nvidia <all|0,1,2,3 etc.>
monitor 
v <1-6>
autoAdjusPrice <true|false>
```

#### Note: reward false is not technically needed if you're not an orchestrator. However, if you're using the transcoder on the same host as the orchestrator, theres a risk of the transcoder calling the reward without the flag set to false. 
