# Documentation

* Additional documentation for the  can be found [Here](https://github.com/NightWolf92/NightNode_Livepeer_Docs/tree/main/Documentation) 
* Developer documentation (i.e. if you are interested in developing go-livepeer) can be found in the [docs](https://github.com/livepeer/go-livepeer/blob/master/doc) folder
* Protocol information can be found in the [protocol](https://github.com/livepeer/protocol) repo
* Other project information can be found in the [wiki](https://github.com/livepeer/wiki/wiki)

#### Table of Contents

1. [Installation - Part 1 - Livepeer](https://github.com/NightWolf92/NightNode_Livepeer_Docs/tree/main/Install/Windows#installation-part-1-livepeer)
2. [Modifications - Livepeer](https://github.com/NightWolf92/NightNode_Livepeer_Docs/tree/main/Install/Windows#modifications)
  2a. [For Orchestrators](https://github.com/NightWolf92/NightNode_Livepeer_Docs/tree/main/Install/Windows#for-orchestrators)
  2b. [For Orchestrator/Transcoder Combo](https://github.com/NightWolf92/NightNode_Livepeer_Docs/tree/main/Install/Windows#for-orchestratortranscoder-combo)
  2c. [For Transcoders](https://github.com/NightWolf92/NightNode_Livepeer_Docs/tree/main/Install/Windows#for-transcoders)
3. [Installation - Part 2 - Grafana](https://github.com/NightWolf92/NightNode_Livepeer_Docs/tree/main/Install/Windows#installation-part-2-grafana)
4. [Installation - Part 3 - Prometheus](
  
  
# Installation (Part 1: Livepeer)

### Windows

Download the latest release located [Here](https://github.com/NightWolf92/NightNode_Livepeer_Docs/releases/tag/Latest)

The Livepeer_Setup.exe file will prompt if you want to install this for yourself, or all users. (If you choose for yourself, it installs it into appData, all users would be ```C:\Program Files(x86)\``` by default)

The installer will install the files to the stated install directory, providing default templates, config files and launch batch files that would require minimal modification to get started. It will also download the latest livepeer release from https://github.com/livepeer/go-livepeer

# Modifications 

### Windows

Navigate to the install directory that was selected, by default it is ```"C:\Program Files(x86)\Livepeer\"```. Inside the folder are a list of files that can be modified, please do so to fit your setup specifications.

```
livepeer_orchestrator.conf (This will just run the O)
livepeer_orchestratorcombo.conf (If you're going to run the O and the T Together in one window)
livepeer_transcoder - GPU ALL.conf (Runs all GPUs for livepeer)
livepeer_transcoder - GPU0.conf  (Runs just GPU0 - if you have 1 GPU, it starts at 0)
livepeer_transcoder - GPU1.conf (Runs just GPU1 - This would be your second GPU)
```

Once you modify the files, there are corresponding batch files for each launcher. If you would like to simplify it, modify the ```LaunchScript.bat``` to include the batch files you would like to launch all at once and it will launch them together.

# For Orchestrators

Follow the config file guidance The below configs will look similar to the text below, replace the field that are encapuslated with < text >, removing the brackets <> (See the #Arbitrum RPC ethURL for how it should look.)

### livepeer_orchestrator.conf (For Standalone Orchestrators - No Transcoders connected)

```
##############################################
#Uncomment the flags if you want to use them.#
##############################################
#                Settings                    #
##############################################

orchestrator
#transcoder
network arbitrum-one-mainnet

##############################################
#              RPC Providers                 #
##############################################

#Alchemy
#ethUrl <RPC URL>

#Infura
#ethUrl <RPC URl>

#Arbnode
#ethUrl <RPC URL>

#Arbitrum RPC
ethUrl arb1.arbitrum.io/rpc

##############################################
#                Configs                     #
#             Key management                 #
##############################################

ethKeystorePath <Path to Keystore>
datadir <Path to Data Directory>
ethPassword <Wallet password>

##############################################
#      Redeemer Info (if applicable)         #
##############################################
#ethOrchAddr <Eth Address>
#redeemerAddr <IP:PORT>

##############################################
#        Orchestrator Management             #
##############################################

serviceAddr <IP:PORT>
cliAddr <IP:PORT>
orchSecret <string or path to secret file> #if you're using remote transcoders
maxGasPrice 5000000000 #only processes transactions when its under .5 gwei
pricePerUnit <900-1200 recommended>
nvidia all #<all,0,1,2,3 etc>
maxSessions <#>
monitor
v 6

#####################################
#            End File               #
#####################################
```

# For Orchestrator/Transcoder Combo:

This is basically the same thing, however it just has ```transcoder``` uncommented and orchSecret is not needed since it will be local. 

### livepeer_orchestratorcombo.conf

```
##############################################
#Uncomment the flags if you want to use them.#
##############################################
#                Settings                    #
##############################################

orchestrator
transcoder
network arbitrum-one-mainnet

##############################################
#              RPC Providers                 #
##############################################

#Alchemy
#ethUrl <RPC URL>

#Infura
#ethUrl <RPC URl>

#Arbnode
#ethUrl <RPC URL>

#Arbitrum RPC
ethUrl arb1.arbitrum.io/rpc

##############################################
#                Configs                     #
#             Key management                 #
##############################################

ethKeystorePath <Path to Keystore>
datadir <Path to Data Directory>
ethPassword <Wallet password>

##############################################
#      Redeemer Info (if applicable)         #
##############################################
#ethOrchAddr <Eth Address>
#redeemerAddr <IP:PORT>

##############################################
#        Orchestrator Management             #
##############################################

serviceAddr <IP:PORT>
cliAddr <IP:PORT>
#orchSecret <string or path to secret file> #if you're using remote transcoders
maxGasPrice 5000000000 #only processes transactions when its under .5 gwei
pricePerUnit <900-1200 recommended>
nvidia all #<all,0,1,2,3 etc>
maxSessions <#>
monitor
v 6

#####################################
#            End File               #
#####################################

```

Note: running an O/T Combo in the same process will not allow remote Transcoders to connect to this node, if you want to have remote Transcoders, run the two processes separately. 

# For Transcoders:

### livepeer_transcoder - GPU ALL.conf
### livepeer_transcoder - GPU0.conf
### livepeer_transcoder - GPU1.conf

This is for local transcoders or remote transcoders, change the IP for the orchAddr to point to their IP address if necessary, if its on the same machine, you can keep it as 127.0.0.1.

This will also use all GPU's on the machine. If you want to change this for GPU 1,2,3,4,5 etc. put the corresponding number next to ```nvidia``` replacing ```all``` with the number. 

The files ```livepeer_transcoder - GPU0.conf``` and ```livepeer_transcoder - GPU1.conf``` are already configured to utilize those GPUs individually. you can also add gpus specifically by doing ```nvidia 1,3,5``` and it will run GPU 2,4,5 in your computer. (numbering starts at 0)

```
##############################################
#                Settings                    #
##############################################

transcoder

##############################################
#        Transcoder Management               #
##############################################

orchAddr 127.0.0.1:8935 #If your orchestrator is on a VPS or off site location, change the orch address to that servers IP.
cliAddr 127.0.0.1:7925
orchSecret <string or path to secret file> #if you're using remote transcoders
nvidia all
maxSessions <#>
monitor
v 6

#####################################
#            End File               #
#####################################
```


# Installation (Part 2: Grafana)

Included in the installer for livepeer is the installer for Grafana for Windows. This will install as part of the process of the installer. 

The default location for the Grafana Installation is ```C:\Program Files\GrafanaLabs\```

After grafana is installed navigate to ```localhost:3000``` to verify that grafana has been installed properly. 


# Installation (Part 3: Prometheus)



# Feedback

### Please feel free to submit feedback using the link below which will create a github issue
https://forms.gle/ASZeodPwp3uQntzC8
